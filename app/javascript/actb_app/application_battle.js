import { Question } from "./models/question.js"
import { Battle } from "./models/battle.js"
import { MemberInfo } from "./models/member_info.js"

import dayjs from "dayjs"

import { application_battle_marathon_rule  } from "./application_battle_marathon_rule.js"
import { application_battle_singleton_rule } from "./application_battle_singleton_rule.js"
import { application_battle_hybrid_rule    } from "./application_battle_hybrid_rule.js"

export const application_battle = {
  mixins: [
    application_battle_marathon_rule,
    application_battle_singleton_rule,
    application_battle_hybrid_rule,
  ],
  data() {
    return {
      battle: null,

      x_mode:                     null,  // バトル中の状態遷移
      answer_button_disable_p:    null,  // true:誤答でおてつき中
      battle_continue_tap_counts: null,  // それぞれの再戦希望数
      battle_count:               null,  // 同じ相手との対戦回数
      share_sfen:                 null,  // 自分の操作を相手に伝える棋譜
      question_index:             null,  // 現在の問題インデックス

      q_turn_offset: null,
      main_interval_id: null,
      main_interval_count: null,

      q2_interval_id: null,
      q2_interval_count: null,

      // 各 membership_id はどこまで進んでいるかわかる
      // {
      //   3 => ["correct", "mistake"],
      // }
      member_infos_hash: null,
    }
  },

  methods: {
    ac_battle_perform(action, params = {}) {
      let membership = null

      if (params.ms_flip) {
        this.__assert__(typeof params.ms_flip === "boolean")
      }

      if (params.ms_flip) {
        membership = this.opponent_membership
      } else {
        membership = this.current_membership
      }

      params = Object.assign({}, {
        membership_id: membership.id,
      }, params)

      if (this.app.config.action_cable_debug) {
        this.room_speak(`**→ [${membership.user.name}][${action}] ` + JSON.stringify(params))
      }

      this.$ac_battle.perform(action, params) // --> app/channels/actb/battle_channel.rb
    },

    battle_unsubscribe() {
      this.ac_unsubscribe("$ac_battle")
    },

    battle_setup(battle) {
      this.battle_unsubscribe()

      this.battle = new Battle(battle)

      this.mode = "battle"
      this.sub_mode = "standby"

      this.battle_continue_tap_counts = {}

      this.member_infos_hash = this.battle.memberships.reduce((a, e) => ({...a, [e.id]: new MemberInfo(e.id)}), {})

      this.question_index = 0

      this.__assert__(this.$ac_battle == null)
      this.$ac_battle = this.ac_subscription_create({channel: "Actb::BattleChannel", battle_id: this.battle.id}, {
        connected: () => {
          this.start_hook()
        },
        received: (data) => {
          if (this.app.config.action_cable_debug) {
            this.room_speak(`**← [${data.bc_action}] ` + JSON.stringify(data.bc_params))
          }
        },
      })
    },

    ////////////////////////////////////////////////////////////////////////////////

    start_hook() {
      this.battle_count += 1

      if (this.info.debug_scene === "result") {
        this.result_setup(this.info.battle)
        return
      }

      this.__assert__(this.battle.best_questions.length >= 1, "対戦開始しようとしたが問題集が空")

      this.debug_alert("battle 接続")

      this.ac_battle_perform("start_hook", {
        question_id: this.current_question.id,
        question_index: this.question_index,
      }) // --> app/channels/actb/battle_channel.rb

      this.ok_notice("対戦開始")
      this.sub_mode = "readygo_wait"
      this.delay(this.config.readygo_mode_delay, () => {
        this.deden_mode_trigger()
      })
    },

    deden_mode_trigger() {
      this.sound_play("deden")
      this.sub_mode = "deden_mode"

      this.delay(this.config.deden_mode_delay, () => {
        this.operation_mode_trigger()
      })
    },

    operation_mode_trigger() {
      this.sub_mode = "operation_mode"
      this.x_mode = "x1_thinking"
      this.answer_button_disable_p = false
      this.share_sfen = null
    },

    q_turn_offset_set(turn) {
      this.q_turn_offset = turn

      const max = this.current_question.moves_count_max + this.config.turn_limit_lazy_count
      if (turn >= max) {
        this.x2_play_timeout_handle()
      }
    },

    play_mode_advanced_full_moves_sfen_set(long_sfen) {
      if (this.sub_mode === "operation_mode") {

        if (this.battle.rule.key === "singleton_rule") {
          // 安全のため残り0秒になってから操作しても無効とする
          if (this.q2_rest_seconds === 0) {
            return
          }

          // 駒を1つでも動かしたら3秒に復帰する
          if (this.x_mode === "x2_play") {
            this.q2_interval_restart()
          }

          this.kyouyuu(long_sfen)
        }

        if (this.current_question.sfen_valid_p(long_sfen)) {
          this.kotae_sentaku("correct")
        }
      }
    },

    kyouyuu(share_sfen) {
      this.ac_battle_perform("kyouyuu", { // 戻値なし
        share_sfen: share_sfen,
      }) // --> app/channels/actb/battle_channel.rb
    },
    kyouyuu_broadcasted(params) {
      if (params.membership_id === this.current_membership.id) {
        // 自分は操作中なので何も変化させない
      } else {
        // 自分の操作を相手の盤面で動かす
        this.share_sfen = params.share_sfen
        this.sound_play("pishi") // shogi-player で音が鳴らないのでここで鳴らす
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 正解または不正解
    kotae_sentaku(ox_mark_key, ms_flip = false) {
      this.__assert__(ox_mark_key === "correct" || ox_mark_key === "timeout")
      this.ac_battle_perform("kotae_sentaku", {
        ms_flip: ms_flip,
        question_id: this.current_question.id,
        question_index: this.question_index,
        ox_mark_key: ox_mark_key,
      }) // --> app/channels/actb/battle_channel.rb
    },
    // 状況を反映する
    kotae_sentaku_broadcasted(params) {
      const ox_mark_info = this.OxMarkInfo.fetch(params.ox_mark_key) // 正解・不正解
      const mi = this.member_infos_hash[params.membership_id]          // 対応する membership の情報

      // 効果音
      this.sound_play(ox_mark_info.sound_key)

      if (this.battle.rule.key === "marathon_rule") {
        this.seikai_user_niha_maru(mi, ox_mark_info) // 正解時は正解したユーザーが送信者なので正解者には○

        if (ox_mark_info.key === "timeout") {
          mi.ox_list.push("timeout")
        }

        this.itteijikan_maru_hyouji(mi, ox_mark_info) // なくてもいいけど○を一定時間表示

        // correct_mode or mistake_mode
        if (params.membership_id === this.current_membership.id) {
          this.sub_mode = `${ox_mark_info.key}_mode`
          this.delay_and_owattayo_or_next_trigger(ox_mark_info)
        }
      }

      // 正解時         → 正解したユーザーが送信者
      // タイムアウト時 → プレイマリーユーザーが送信者
      if (this.battle.rule.key === "singleton_rule" || this.battle.rule.key === "hybrid_rule") {
        this.sub_mode = `${ox_mark_info.key}_mode` // correct_mode or mistake_mode

        this.seikai_user_niha_maru(mi, ox_mark_info)  // 正解時は正解したユーザーが送信者なので正解者には○
        this.ryousya_jikangire(ox_mark_info)          // タイムアウトのときは両者に時間切れ
        this.itteijikan_maru_hyouji(mi, ox_mark_info) // なくてもいいけど○を一定時間表示

        this.delay_and_owattayo_or_next_trigger(ox_mark_info) // [ONCE]
      }
    },

    // タイムアウトのときは両者に時間切れ
    ryousya_jikangire(ox_mark_info) {
      if (ox_mark_info.key === "timeout") {
        _.each(this.member_infos_hash, (v, k) => v.ox_list.push("timeout"))
      }
    },

    // 正解時は正解したユーザーが送信者なので正解者には○
    seikai_user_niha_maru(mi, ox_mark_info) {
      if (ox_mark_info.key === "correct") {
        this.score_add(mi.membership_id, ox_mark_info.score)
        mi.ox_list.push("correct")
      }
    },

    itteijikan_maru_hyouji(mi, ox_mark_info) {
      this.delay_stop(mi.delay_id) // 前のが動いている場合があるので止める
      mi.latest_ox = ox_mark_info.key
      mi.delay_id = this.delay(ox_mark_info.delay_second, () => {
        mi.delay_id = null
        mi.latest_ox = null
      })
    },

    delay_and_owattayo_or_next_trigger(ox_mark_info) {
      console.log(1)
      this.delay(ox_mark_info.delay_second, () => {
        console.log(2)
        if (this.battle_end_p || this.next_question_empty_p) {
          console.log(3)
          this.ac_battle_perform("owattayo", {member_infos_hash: this.member_infos_hash}) // --> app/channels/actb/battle_channel.rb
        } else {
          console.log(4)
          this.next_trigger()
        }
      })
    },

    ////////////////////////////////////////////////////////////////////////////////

    // singleton_rule では両方呼ぶが片方はキャンセルされる
    next_trigger() {
      this.ac_battle_perform("next_trigger", {
        question_index: this.question_index + 1, // 次に進めたい(希望)
        question_id: this.next_question.id,
      }) // --> app/channels/actb/battle_channel.rb
    },
    next_trigger_broadcasted(params) {
      if (this.battle.rule.key === "marathon_rule") {
        if (params.membership_id === this.current_membership.id) {
          this.question_index = params.question_index // 自分だったら次に進める
          this.deden_mode_trigger()
        }
      }
      if (this.battle.rule.key === "singleton_rule" || this.battle.rule.key === "hybrid_rule") {
        this.question_index = params.question_index // 相手もそろって次に進める
        this.deden_mode_trigger()
      }
    },

    // 早押しボタンを押した(解答権はまだない)
    wakatta_handle(ms_flip = false) {
      this.sound_play("click")
      this.ac_battle_perform("wakatta_handle", {ms_flip: ms_flip, question_id: this.current_question.id}) // --> app/channels/actb/battle_channel.rb
    },
    wakatta_handle_broadcasted(params) {
      if (params.membership_id === this.current_membership.id) {
        // 先に解答ボタンを押せた本人
        this.x_mode = "x2_play"
        this.q2_interval_start()
        this.sound_play("poon")
      } else {
        // 解答ボタンを押さなかった相手
        if (this.answer_button_disable_p) {
          this.answer_button_disable_p = false // 元々誤答していたら解答権利復活させる
        }
        this.x_mode = "x3_see"
        this.share_sfen = this.current_question.init_sfen // 初期状態にしておく
        this.sound_play("poon")
      }
    },

    // 早押しボタンを押して解答中に時間切れ
    x2_play_timeout_handle(ms_flip = false) {
      this.ac_battle_perform("x2_play_timeout_handle", {
        ms_flip: ms_flip,
        question_id: this.current_question.id,
      }) // --> app/channels/actb/battle_channel.rb
    },
    // singleton_rule での操作中の時間切れは不正解相当
    x2_play_timeout_handle_broadcasted(params) {
      this.member_infos_hash[params.membership_id].ox_list.push("mistake")
      this.score_add(params.membership_id, -1)
      if (params.membership_id === this.current_membership.id) {
        this.answer_button_disable_p = true
      } else {
        this.answer_button_disable_p = false
      }
      this.sound_play("mistake")
      this.x_mode = "x1_thinking"
      this.q2_interval_stop()
    },

    // private
    score_add(membership_id, diff) {
      const mi = this.member_infos_hash[membership_id]
      let v = mi.b_score + diff
      if (v < 0) {
        v = 0
      }
      mi.b_score = v
    },

    // 結果画面へ
    katimake_set_broadcasted(params) {
      this.result_setup(params.battle)
    },

    battle_continue_handle() {
      this.sound_play("click")
      this.ac_battle_perform("battle_continue_handle", {membership_id: this.current_membership.id})
    },
    battle_continue_handle_broadcasted(params) {
      this.battle_continue_tap_counts = params.battle_continue_tap_counts

      this.talk2("再戦希望")
      this.$buefy.toast.open({message: "再戦希望", position: "is-top", queue: false})
    },

    battle_continue_force_handle() {
      this.sound_play("click")
      this.ac_battle_perform("battle_continue_force_handle")
    },

    member_disconnect_handle(ms_flip = false) {
      this.ac_battle_perform("member_disconnect_handle", {ms_flip: ms_flip})
    },

    ////////////////////////////////////////////////////////////////////////////////

    result_setup(battle) {
      this.battle = new Battle(battle)
      this.mode = "result"
      this.sound_play(this.app.current_membership.judge.key)
    },

    // 部屋から退出する
    yameru_handle() {
      this.battle_leave_handle()    // 「退出しました」発言が中で行われる
      // this.room_speak("*退出しました")
      this.lobby_handle()
    },

    // 退出通知
    battle_leave_handle(ms_flip = false) {
      this.ac_battle_perform("battle_leave_handle", {ms_flip: ms_flip})
    },
    battle_leave_handle_broadcasted(params) {
      const membership = this.battle.memberships.find(e => e.id === params.membership_id)
      this.room_speak(`**${membership.user.name}さんが退出したことを知った`)
      this.member_infos_hash[membership.id].member_active_p = false // 退出記録
    },

    ////////////////////////////////////////////////////////////////////////////////
    main_interval_start() {
      this.main_interval_clear()
      this.main_interval_count = 0
      this.main_interval_id = setInterval(this.main_interval_processing, 1000)
    },

    main_interval_clear() {
      if (this.main_interval_id) {
        clearInterval(this.main_interval_id)
        this.main_interval_id = null
      }
    },

    main_interval_processing() {
      if (this.battle.rule.key === "marathon_rule") {
        if (this.sub_mode === "operation_mode") {
          this.main_interval_count += 1
          if (this.q1_rest_seconds === 0) {
            this.kotae_sentaku('timeout')
          }
        }
      }
      if (this.battle.rule.key === "hybrid_rule") {
        if (this.sub_mode === "operation_mode") {
          this.main_interval_count += 1
          if (this.q1_rest_seconds === 0) {
            this.kotae_sentaku('timeout') // [ONCE]
          }
        }
      }
      if (this.battle.rule.key === "singleton_rule") {
        if (this.sub_mode === "operation_mode") {
          if (this.x_mode === "x1_thinking") {
            this.main_interval_count += 1
            if (this.q1_rest_seconds === 0) {
              this.kotae_sentaku('timeout') // [ONCE]
            }
          }
        }
      }
    },

    ////////////////////////////////////////////////////////////////////////////////
    q2_interval_start() {
      this.q2_interval_stop()
      this.q2_interval_count = 0
      this.q2_interval_id = setInterval(this.q2_interval_processing, 1000)
    },

    q2_interval_stop() {
      if (this.q2_interval_id) {
        clearInterval(this.q2_interval_id)
        this.q2_interval_id = null
      }
    },

    q2_interval_restart() {
      this.q2_interval_stop()
      this.q2_interval_start()
    },

    q2_interval_processing() {
      if (this.sub_mode === "operation_mode") {
        this.q2_interval_count += 1
        if (this.q2_rest_seconds === 0) {
          this.x2_play_timeout_handle()
        }
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

  },

  computed: {
    // leader_p() {
    //   return this.battle.memberships[this.app.config.leader_index].id === this.current_membership.id
    // },
    current_membership() {
      const v = this.battle.memberships.find(e => e.user.id === this.current_user.id)
      this.__assert__(v, "current_membership is blank")
      return v
    },
    opponent_membership() {
      const v = this.battle.memberships.find(e => e.user.id !== this.current_user.id)
      this.__assert__(v, "opponent_membership is blank")
      return v
    },
    current_question() {
      const v = this.battle.best_questions[this.question_index]
      this.__assert__(v, `[${this.question_index}]の問題が空`)
      return v
    },
    next_question() {
      const v = this.battle.best_questions[this.question_index + 1]
      this.__assert__(v, "next_question is blank")
      return v
    },

    ////////////////////////////////////////////////////////////////////////////////

    q1_time_str() {
      return dayjs().startOf("year").set("seconds", this.q1_rest_seconds).format("m:ss")
    },
    q1_rest_seconds() {
      let v = this.q1_time_limit_sec - this.main_interval_count
      if (v < 0) {
        v = 0
      }
      return v
    },
    q1_time_limit_sec() {
      const v = this.app.config.thinking_time_sec
      if (v != null) {
        return v
      }

      // if (this.development_p) {
      //   return 3
      // }
      return this.current_question.time_limit_sec
    },

    ////////////////////////////////////////////////////////////////////////////////

    q2_rest_seconds() {
      let v = this.config.q2_time_limit_sec - this.q2_interval_count
      if (v < 0) {
        v = 0
      }
      return v
    },

    ////////////////////////////////////////////////////////////////////////////////

    next_question_exist_p() {
      return !this.next_question_empty_p
    },
    next_question_empty_p() {
      return (this.question_index + 1) >= this.battle.questions_count
    },
    score_orderd_memberships() {
      return _.sortBy(this.battle.memberships, e => -this.member_infos_hash[e.id].b_score)
    },
    score_debug_info() {
      return this.score_orderd_memberships.map(e => `${e.user.name}(${this.member_infos_hash[e.id].b_score})`).join(", ")
    },
    b_score_max() {
      return _.max(_.map(this.member_infos_hash, (e, membership_id) => e.b_score))
    },

    // バトル終了条件
    battle_end_p() {
      return this.b_score_max >= this.app.config.b_score_max_for_win
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 自分が必ず左側にいる memberships
    // -1:左 +1:右
    ordered_memberships() {
      return _.sortBy(this.battle.memberships, e => e.user.id === this.current_user.id ? -1 : 0)
    },
  },
}
