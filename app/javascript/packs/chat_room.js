import _ from "lodash"
import axios from "axios"
import chat_room_name from "./chat_room_name.js"
import chess_clock from "./chess_clock.js"

import { PresetInfo } from 'shogi-player/src/preset_info.js'
import { Location } from 'shogi-player/src/location.js'

// (function() {
//   this.chat_vm || (this.chat_vm = {})
// }).call(this)

// app/assets/javascripts/cable/subscriptions/chat.coffee
// App.cable.subscriptions.create { channel: "ChatChannel", room: "Best Room" }
//
// # app/assets/javascripts/cable/subscriptions/lobby.coffee
// App.cable.subscriptions.create { channel: "LobbyChannel" }

document.addEventListener('DOMContentLoaded', () => {
  App.chat_room = App.cable.subscriptions.create({
    channel: "ChatRoomChannel",
    chat_room_id: chat_room_app_params.chat_room.id,
  }, {
    connected() {
      console.log("ChatRoomChannel.connected")
      this.perform("room_in")
      this.system_say("入室しました")
    },

    disconnected() {
      console.log("ChatRoomChannel.disconnected")
      // 【注意】接続が切れている状態なのでここから perform で ruby 側を呼び出すことはできない。が、ruby 側の unsubscribed は自動的に呼ばれるのでそこで退室時の処理を書ける
      // this.perform("room_out")
      // this.system_say("退室しました")
    },

    received(data) {
      // 部屋名の共有
      if (data["chat_room"]) {
        // alert(data["chat_room"])
      }

      // 結局使ってない
      if (!_.isNil(data["without_id"]) && data["without_id"] === js_global_params.current_chat_user.id) {
        console.log("skip")
        return
      }

      if (data["watch_users"]) {
        App.chat_vm.watch_users = data["watch_users"]
      }

      // ↓この方法にすればシンプル
      // if (data["chat_room"]) {
      //   const v = data["chat_room"]
      //   // App.chat_vm.kifu_body_sfen = v.chat_room.kifu_body_sfen
      //   App.chat_vm.preset_key = v.preset_key
      //   App.chat_vm.battle_begin_at = v.battle_begin_at
      // }

      if (data["battle_begin_at"]) {
        App.chat_vm.game_setup(data)
      }

      // Called when there"s incoming data on the websocket for this channel
      // console.log("received")
      // console.table(data)

      if (data["turn_max"]) {
        App.chat_vm.turn_max = data["turn_max"]
        App.chat_vm.clock_counts = data["clock_counts"]
        App.chat_vm.think_counter_reset()
      }

      if (data["kifu_body_sfen"]) {
        // これはだめ
        // if (!_.isNil(data["moved_chat_user_id"]) && data["moved_chat_user_id"] === js_global_params.current_chat_user.id) {
        //   // ブロードキャストに合わせて自分も更新すると駒音が重複してしまうため自分自身は更新しない
        //   // (が、こうすると本当にまわりにブロードキャストされたのか不安ではある)
        // } else {
        // }

        // 観戦モード(view_mode)にしたとき棋譜が最新になっているようにするため指した本人にも通知する
        App.chat_vm.kifu_body_sfen = data["kifu_body_sfen"]
      }

      if (data["preset_key"]) {
        App.chat_vm.preset_key = data["preset_key"]
      }

      if (data["lifetime_key"]) {
        App.chat_vm.current_lifetime_key = data["lifetime_key"]
      }

      if (data["human_kifu_text"]) {
        App.chat_vm.human_kifu_text = data["human_kifu_text"]
      }

      if (data["room_members"]) {
        App.chat_vm.room_members = data["room_members"]
      }

      // 発言の反映
      if (data["room_chat_message"]) {
        App.chat_vm.room_chat_messages.push(data["room_chat_message"])
      }

      // 部屋名の共有
      if (data["room_name"]) {
        App.chat_vm.room_name = data["room_name"]
      }

      // 終了
      if (data["battle_end_at"]) {
        App.chat_vm.game_ended(data)
      }

      // 定期的に呼ぶ場合
      if (data["action"] === "update_count") {
        console.log(data["count"])
      }
    },

    chat_say(message) {
      this.perform("chat_say", {message: message})
    },

    system_say(str) {
      this.chat_say(`<span class="has-text-info">${str}</span>`)
    },

    room_name_changed(room_name) {
      this.perform("room_name_changed", {room_name: room_name})
    },

    // kifu_body_sfen_broadcast(data) {
    //   this.perform("kifu_body_sfen_broadcast", data)
    // },

    // preset_key_update(data) {
    //   this.perform("preset_key_update", data)
    // },

    lifetime_key_update(data) {
      this.perform("lifetime_key_update", data)
    },

    game_start(data) {
      this.perform("game_start", data)
    },

    game_end_time_up_trigger(data) {
      this.perform("game_end_time_up_trigger", data)
    },

    game_end_give_up_trigger(data) {
      this.perform("game_end_give_up_trigger", data)
    },

    location_flip_all(data) {
      this.perform("location_flip_all", data)
    },

    play_mode_long_sfen_set(data) {
      this.perform("play_mode_long_sfen_set", data)
    },

  })

  App.chat_vm = new Vue({
    mixins: [
      chat_room_name,
      chess_clock,
    ],
    el: "#chat_room_app",
    data() {
      return {
        message: "",                          // 発言
        room_chat_messages: [],                    // 発言一覧
        human_kifu_text: "(human_kifu_text)", // 棋譜

        room_members: chat_room_app_params.room_members,
        kifu_body_sfen: chat_room_app_params.chat_room.kifu_body_sfen,
        preset_key: chat_room_app_params.chat_room.preset_key,
        current_lifetime_key: chat_room_app_params.chat_room.lifetime_key,
        battle_begin_at: chat_room_app_params.chat_room.battle_begin_at,
        battle_end_at: chat_room_app_params.chat_room.battle_end_at,
        win_location_key: chat_room_app_params.chat_room.win_location_key,
        last_action_key: chat_room_app_params.chat_room.last_action_key,
        watch_users: chat_room_app_params.chat_room.watch_users,
        turn_max: chat_room_app_params.chat_room.turn_max,
      }
    },

    watch: {
      // 使ってはいけない
      // 使うとブロードキャストの無限ループを考慮する必要がでてきてカオスになる
      // ちょっとバグっただけで無限ループになる
      // 遠回りだが @input にフックしてサーバー側に送って返ってきた値で更新する
      // 遠回りだと「更新」するのが遅くなると思うかもしれないがブロードキャストする側の画面は切り替わっているので問題ない
      // ただしチャットのメッセージは除く。チャットの場合は入力を即座にチャット一覧に反映していないため
      // このように一概にどう扱うのがよいのか判断が難しい
      // 間違っても watch は使うな
    },

    created() {
    },

    methods: {
      room_in() {
      },

      // バトル開始！(1人がトリガー)
      game_start() {
        App.chat_room.system_say("バトル開始！")
        App.chat_room.game_start()
      },

      // バトル開始(トリガーから全体通知が来たときの処理)
      game_setup(data) {
        this.battle_begin_at = data["battle_begin_at"]
        this.battle_end_at = null
        this.think_counter_reset()
      },

      // ゲーム終了(投了により
      game_end_give_up_trigger() {
        App.chat_room.game_end_give_up_trigger({win_location_key: this.current_location.flip.key})
        App.chat_room.system_say("負けました")
      },

      // ゲーム終了(時間切れにより・生き残っている全員で送信)
      game_end_time_up_trigger() {
        if (this.member_p) {
          App.chat_room.game_end_time_up_trigger({win_location_key: this.current_location.flip.key})
        }
      },

      // 終了の通達があった
      game_ended(data) {
        this.battle_end_at = data["battle_end_at"]
        this.win_location_key = data["win_location_key"]
        this.last_action_key = data["last_action_key"]

        // App.chat_room.system_say(`${this.win_location.name}の勝ち！`)

        if (this.member_p) {
          // 対局者同士
          if (this.my_uniq_locations.length >= 2) {
            // 両方に所属している場合(自分対自分になっている場合)
            // 客観的な味方で報告
            this.kyakkanntekina_kekka_dialog()
          } else {
            // 片方に所属している場合
            if (_.includes(this.my_uniq_locations, this.win_location)) {
              // 勝った方
              Vue.prototype.$dialog.alert({
                title: "勝利",
                message: "勝ちました",
                type: 'is-primary',
                hasIcon: true,
                icon: 'crown',
                iconPack: 'mdi',
              })
            } else {
              // 負けた方
              Vue.prototype.$dialog.alert({
                title: "敗北",
                message: "負けました",
                type: 'is-primary',
              })
            }
          }
        } else {
          // 観戦者
          this.kyakkanntekina_kekka_dialog()
        }
      },

      // 客観的結果通知
      kyakkanntekina_kekka_dialog() {
        Vue.prototype.$dialog.alert({title: "結果", message: `${this.last_action_name}により${this.location_name(this.win_location)}が勝ちました`, type: 'is-primary'})
      },

      // // 手合割の変更
      // preset_key_update(v) {
      //   if (this.preset_key !== v) {
      //     this.preset_key = v
      //     App.chat_room.preset_key_update({preset_key: this.current_preset_info.name})
      //     App.chat_room.system_say(`手合割を${this.current_preset_info.name}に変更しました`)
      //   }
      // },

      // 持ち時間の変更
      lifetime_key_update(v) {
        if (this.current_lifetime_key !== v) {
          this.current_lifetime_key = v
          App.chat_room.lifetime_key_update({lifetime_key: this.current_lifetime_info.key})
          App.chat_room.system_say(`持ち時間を${this.current_lifetime_info.name}に変更しました`)
        }
      },

      // 先後反転(全体)
      location_flip_all() {
        App.chat_room.location_flip_all()
      },

      location_key_name(membership) {
        return this.location_infos[membership.location_key].name
      },

      location_mark(membership) {
        if (this.current_membership === membership) {
          return "○"
        }
      },

      // メッセージ送信
      message_enter(value) {
        if (this.message !== "") {
          App.chat_room.chat_say(this.message)
        }
        this.message = ""
      },

      // chat_user は自分か？
      user_self_p(chat_user) {
        return chat_user.id === js_global_params.current_chat_user.id
      },

      __membership_self_p(e) {
        return this.user_self_p(e.chat_user)
      },

      play_mode_long_sfen_set(v) {
        if (this.battle_end_at) {
          return
        }
        if (!this.battle_begin_at) {
          return
        }
        App.chat_room.play_mode_long_sfen_set({kifu_body: v, think_counter: this.think_counter, current_location_key: this.current_location.key})
      },

      location_name(location) {
        return location.any_name(this.komaochi_p)
      },

    },
    computed: {
      // チャットに表示する最新メッセージたち
      latest_room_chat_messages() {
        return _.takeRight(this.room_chat_messages, 10)
      },

      // 手番選択用
      location_infos() {
        return {
          "black": { name: "☗" + this.location_name(Location.fetch("black")), },
          "white": { name: "☖" + this.location_name(Location.fetch("white")), },
        }
      },

      // 駒落ち？
      komaochi_p() {
        return this.current_preset_info.first_location_key === "white"
      },

      // 現在の手番番号
      current_index() {
        return (this.komaochi_p ? 1 : 0) + this.turn_max
      },

      // 現在手番を割り当てられたメンバー
      current_membership() {
        return this.room_members[this.current_index % this.room_members.length]
      },

      // 現在の手番はそのメンバーの先後
      current_location() {
        return Location.fetch(this.current_membership.location_key)
      },

      // 現在の手番は私ですか？(1人の場合常にtrueになる)
      current_membership_is_self_p() {
        return this.__membership_self_p(this.current_membership)
      },

      // 操作する側を返す
      // 手番のメンバーが自分の場合に、自分の先後を返せばよい
      human_side_key() {
        if (this.current_membership_is_self_p) {
          return this.current_location.key
        }
      },

      // 盤面を反転するか？
      flip() {
        if (this.current_membership_is_self_p) {
          return this.current_location.key === "white"
        }
      },

      // この部屋にいる私は対局者ですか？
      member_p() {
        return this.my_memberships.length >= 1
      },

      my_memberships() {
        return _.filter(this.room_members, (e) => this.user_self_p(e.chat_user))
      },

      my_uniq_locations() {
        return _.uniq(_.map(this.my_memberships, (e) => Location.fetch(e.location_key)))
      },

      run_mode() {
        if (_.isNil(this.battle_begin_at)) {
          return "edit_mode"
        }
        if (this.battle_end_at) {
          return "view_mode"
        }
        if (this.member_p) {
          return "play_mode"
        } else {
          return "view_mode"
        }
      },

      // 手合割一覧
      preset_infos() {
        return PresetInfo.values
      },

      // 現在選択されている手合割情報
      current_preset_info() {
        return PresetInfo.fetch(this.preset_key)
      },

      // 考え中？ (プレイ中？)
      thinking_p() {
        return !_.isNil(this.battle_begin_at) && _.isNil(this.battle_end_at)
      },

      // 勝った方
      win_location() {
        return Location.fetch(this.win_location_key)
      },

      last_action_name() {
        const table = {
          TORYO: "投了",
          TIME_UP: "時間切れ",
          ILLEGAL_MOVE: "反則",
        }
        return table[this.last_action_key]
      },

    },
  })
})
