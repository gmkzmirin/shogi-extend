import numeral from "numeral"
import _ from "lodash"
import axios from "axios"
import chat_room_name from "./chat_room_name.js"

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
    connected: function() {
      // Called when the subscription is ready for use on the server
      console.log("ChatRoomChannel.connected")
      // App.chat_vm.online_members = _.concat(App.chat_vm.online_members, js_global_params.current_chat_user.id)

      this.perform("room_in")
      this.chat_say(`<span class="has-text-primary">入室しました</span>`)
    },
    disconnected: function() {
      console.log("ChatRoomChannel.disconnected")
      // // Called when the subscription has been terminated by the server
      // console.log("disconnected")
      // // App.chat_vm.online_members = _.without(App.chat_vm.online_members, js_global_params.current_chat_user.id)
      this.perform("room_out")
      this.chat_say(`<span class="has-text-primary">退出しました</span>`) // 呼ばれない？
    },

    // Ruby 側の ActionCable.server.broadcast("chat_room_channel", chat_article: chat_article) に反応して呼ばれる
    received: function(data) {
      if (!_.isNil(data["without_id"]) && data["without_id"] === js_global_params.current_chat_user.id) {
        console.log("skip")
        return
      }

      // ↓この方法にすればシンプル
      // if (data["chat_room"]) {
      //   const v = data["chat_room"]
      //   // App.chat_vm.kifu_body_sfen = v.chat_room.kifu_body_sfen
      //   App.chat_vm.current_preset_key = v.preset_key
      //   App.chat_vm.game_started_at = v.game_started_at
      // }

      if (data["game_started_at"]) {
        App.chat_vm.game_started_at = data["game_started_at"]
        App.chat_vm.game_setup()
      }

      // Called when there"s incoming data on the websocket for this channel
      // console.log("received")
      // console.table(data)

      // if (data["turn_info"]) {
      //   App.chat_vm.turn_info = data["turn_info"]
      // }

      if (data["turn_max"]) {
        App.chat_vm.turn_max = data["turn_max"]
      }

      if (data["kifu_body_sfen"]) {
        if (data["without_self"] && data["current_chat_user"]["id"] === js_global_params.current_chat_user.id) {
          // ブロードキャストに合わせて自分も更新すると駒音が重複してしまうため自分自身は更新しない
          // (が、こうすると本当にまわりにブロードキャストされたのか不安ではある)
        } else {
          App.chat_vm.kifu_body_sfen = data["kifu_body_sfen"]
        }
      }

      if (data["preset_key"]) {
        App.chat_vm.current_preset_key = data["preset_key"]
      }

      if (data["human_kifu_text"]) {
        App.chat_vm.human_kifu_text = data["human_kifu_text"]
      }

      // // 指し手の反映
      // if (data["last_hand"]) {
      //   App.chat_vm.chat_articles.push(data["last_hand"])
      // }

      if (data["online_members"]) {
        App.chat_vm.online_members = data["online_members"]
      }

      // 発言の反映
      if (data["chat_article"]) {
        console.log("発言の反映")
        console.log(data)
        App.chat_vm.chat_articles.push(data["chat_article"])
      }

      // 部屋名の共有
      if (data["room_name"]) {
        App.chat_vm.room_name = data["room_name"]
      }
    },

    // 自由に定義してよいメソッド
    chat_say: function(chat_article_body) {
      console.log(`chat_say: ${chat_article_body}`)
      console.log(`chat_say: ${js_global_params.current_chat_user.id}`)
      // app/channels/chat_room_channel.rb の chat_say メソッドに処理が渡る

      this.perform("chat_say", {
        sayed_chat_user_id: js_global_params.current_chat_user.id,
        chat_room_id: chat_room_app_params.chat_room.id,
        chat_article_body: chat_article_body,
      })
    },

    system_say(str) {
      this.chat_say(`<span class="has-text-info">${str}</span>`)
    },

    // 自由に定義してよいメソッド
    room_name_changed: function(data) {
      this.perform("room_name_changed", data)
    },

    kifu_body_sfen_broadcast: function(data) {
      this.perform("kifu_body_sfen_broadcast", data)
    },

    preset_key_broadcast(data) {
      this.perform("preset_key_broadcast", data)
    },

    member_location_change_broadcast(data) {
      this.perform("member_location_change_broadcast", data)
    },

    game_start(data) {
      this.perform("game_start", data)
    },
  })

  App.chat_vm = new Vue({
    mixins: [chat_room_name],
    el: "#chat_room_app",
    data() {
      return {
        message: "",                          // 発言
        chat_articles: [],                    // 発言一覧
        online_members: [],                   // 参加者
        human_kifu_text: "(human_kifu_text)", // 棋譜
        // turn_max: 0,

        // 入室したときに局面を反映する(これはビューの方で行なってもよい)
        // App.chat_vm.kifu_body_sfen = chat_room_app_params.chat_room.kifu_body_sfen
        kifu_body_sfen: chat_room_app_params.chat_room.kifu_body_sfen,
        current_preset_key: chat_room_app_params.chat_room.preset_key,
        game_started_at: chat_room_app_params.chat_room.game_started_at,
        turn_max: chat_room_app_params.chat_room.turn_max,

        timer_count: {black: 0, white: 0},
        limit_seconds: 60 * 10,
        turn_info: null,
      }
    },

    created() {
      this.timer_running_p = !_.isNil(this.game_started_at)

      setInterval(() => {
        if (this.timer_running_p) {
          this.timer_count[this.current_location.key]++
        }
      }, 1000)
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

    methods: {
      game_start() {
        App.chat_room.game_start()
        // this.game_started_at = new Date()
      },

      game_setup() {
        this.timer_running_p = true
      },

      // 手番の変更
      preset_key_broadcast(v) {
        if (this.current_preset_key !== v) {
          this.current_preset_key = v
          App.chat_room.preset_key_broadcast({preset_key: this.current_preset_info.name})
          App.chat_room.system_say(`手合割を${this.current_preset_info.name}に変更しました`)
        }
      },

      member_location_change(chat_membership_id, location_key) {
        App.chat_room.member_location_change_broadcast({chat_membership_id: chat_membership_id, location_key: location_key})
      },

      message_enter(value) {
        if (this.message !== "") {
          App.chat_room.chat_say(this.message)
        }
        this.message = ""
      },

      play_mode_long_sfen_set(v) {
        const params = new URLSearchParams()
        params.append("kifu_body", v)

        axios({
          method: "post",
          timeout: 1000 * 10,
          headers: {"X-TAISEN": true},
          url: chat_room_app_params.player_mode_moved_path,
          data: params,
        }).then((response) => {
          if (response.data.error_message) {
            Vue.prototype.$toast.open({message: response.data.error_message, position: "is-bottom", type: "is-danger"})
            App.chat_room.chat_say(`<span class="has-text-danger">${response.data.error_message}</span>`)
          }
          if (response.data.kifu_body_sfen) {
            if (false) {
              // これまでの方法
              this.kifu_body_sfen = response.data.kifu_body_sfen
            } else {
              // 局面を共有する
              // /Users/ikeda/src/shogi_web/app/channels/chat_room_channel.rb の receive を呼び出してブロードキャストする

              // App.chat_room.send({...chat_room_app_params, kifu_body_sfen: response.data.sfen})

              App.chat_room.kifu_body_sfen_broadcast({...chat_room_app_params, ...response.data})
              App.chat_room.system_say(`${response.data.last_hand}`)
            }
          }
        }).catch((error) => {
          console.table([error.response])
          Vue.prototype.$toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
        })
      },
      chat_user_self_p(chat_user) {
        return chat_user.id === js_global_params.current_chat_user.id
      },

      rest_time(location_key) {
        let v = this.limit_seconds - this.timer_count[location_key]
        if (v < 0) {
          v = 0
        }
        return v
      },

      time_format(location_key) {
        return numeral(this.rest_time(location_key)).format("0:00")
      },

    },
    computed: {
      latest_chat_articles() {
        return _.takeRight(this.chat_articles, 10)
      },

      preset_info_values() {
        return PresetInfo.values
      },

      current_preset_info() {
        return PresetInfo.fetch(this.current_preset_key)
      },

      location_infos() {
        return [
          { key: "black",  name: "☗" + (this.komaochi_p ? "下手" : "先手"), },
          { key: "white",  name: "☖" + (this.komaochi_p ? "上手" : "後手"), },
          { key: null,     name: "観戦",   }, // null だと Bufy が意図を呼んで色を薄くしてくれる
        ]
      },

      current_location() {
        const index = (this.komaochi_p ? 1 : 0) + this.turn_max
        return Location.values[index % Location.values.length]
      },

      komaochi_p() {
        return this.current_preset_info.first_location_key === "white"
      },

      current_membership() {
        return _.find(this.online_members, (e) => this.chat_user_self_p(e.chat_user))
      },

      human_side() {
        if (this.current_membership) {
          return this.current_membership.location_key
        }
      },

      flip() {
        return this.human_side === "white"
      },

      run_mode() {
        if (this.human_side) {
          return "play_mode"
        } else {
          return "play_mode"    // FIXME: view_mode にするとおかしくなる
        }
      },
    },
  })
})
