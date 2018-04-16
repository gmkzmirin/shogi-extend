import _ from "lodash"
import axios from "axios"

// (function() {
//   this.chat_vm || (this.chat_vm = {})
// }).call(this)

// app/assets/javascripts/cable/subscriptions/chat.coffee
// App.cable.subscriptions.create { channel: "ChatChannel", room: "Best Room" }
//
// # app/assets/javascripts/cable/subscriptions/appearance.coffee
// App.cable.subscriptions.create { channel: "AppearanceChannel" }

document.addEventListener('DOMContentLoaded', () => {
  App.chat_room = App.cable.subscriptions.create({
    channel: "ChatRoomChannel",
    chat_room_id: chat_room_app_params.chat_room.id,
  }, {
    connected: function() {
      // Called when the subscription is ready for use on the server
      console.log("connected")
      // App.chat_vm.online_chat_users = _.concat(App.chat_vm.online_chat_users, chat_room_app_params.current_chat_user.id)

      // this.perform("appear", chat_room_app_params)
      this.chat_say(`<span class="has-text-primary">${chat_room_app_params.current_chat_user.id}さんが入室しました</span>`)
    },
    disconnected: function() {
      // // Called when the subscription has been terminated by the server
      // console.log("disconnected")
      // // App.chat_vm.online_chat_users = _.without(App.chat_vm.online_chat_users, chat_room_app_params.current_chat_user.id)
      // this.perform("disappear", chat_room_app_params)
      // this.chat_say(`<span class="has-text-primary">${chat_room_app_params.current_chat_user.id}さんが退出しました</span>`)
    },

    // Ruby 側の ActionCable.server.broadcast("chat_room_channel", chat_article: chat_article) に反応して呼ばれる
    received: function(data) {
      // Called when there"s incoming data on the websocket for this channel
      console.log("received")
      console.table(data)

      if (data["kifu_body_sfen"]) {
        console.log(data["current_chat_user"]["id"])
        console.log(chat_room_app_params.current_chat_user.id)

        if (data["current_chat_user"]["id"] === chat_room_app_params.current_chat_user.id) {
          // ブロードキャストに合わせて自分も更新すると駒音が重複してしまうため自分自身は更新しない
          // (が、こうすると本当にまわりにブロードキャストされたのか不安ではある)
        } else {
          App.chat_vm.kifu_body_sfen = data["kifu_body_sfen"]
        }
      }

      if (data["online_chat_users"]) {
        App.chat_vm.online_chat_users = data["online_chat_users"]
      }

      if (data["chat_article"]) {
        const chat_article = data["chat_article"]
        App.chat_vm.list.push(chat_article)
      }
    },

    // 自由に定義してよいメソッド
    chat_say: function(chat_article_body) {
      console.log(`chat_say: ${chat_article_body}`)
      console.log(`chat_say: ${chat_room_app_params.current_chat_user.id}`)
      // app/channels/chat_room_channel.rb の chat_say メソッドに処理が渡る

      this.perform("chat_say", {chat_user_id: chat_room_app_params.current_chat_user.id, chat_room_id: chat_room_app_params.chat_room.id, chat_article_body: chat_article_body})
    },

    kifu_body_sfen_broadcast: function(data) {
      this.perform("kifu_body_sfen_broadcast", data)
    },
  })

  // $(document).on("keypress", "[data-behavior~=chat_room_speaker]", (event) => {
  //   if (event.keyCode === 13) {
  //     App.chat_room.chat_say(event.target.value)
  //     event.target.value = ""
  //     event.preventDefault()
  //   }
  // })

  App.chat_vm = new Vue({
    el: "#chat_room_app",
    data: function() {
      return {
        kifu_body_sfen: "position startpos",
        message: "",
        list: [],
        online_chat_users: [],
      }
    },
    methods: {
      foo() {
        alert(1)
      },
      input_send(value) {
        App.chat_room.chat_say(this.message)
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
          }
          if (response.data.sfen) {
            if (false) {
              // これまでの方法
              this.kifu_body_sfen = response.data.sfen
            } else {
              // 局面を共有する
              // /Users/ikeda/src/shogi_web/app/channels/chat_room_channel.rb の receive を呼び出してブロードキャストする

              // App.chat_room.send({...chat_room_app_params, kifu_body_sfen: response.data.sfen})

              App.chat_room.kifu_body_sfen_broadcast({...chat_room_app_params, kifu_body_sfen: response.data.sfen})
            }
          }
        }).catch((error) => {
          console.table([error.response])
          Vue.prototype.$toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
        })
      },
    },
    computed: {
      latest_list() {
        return _.takeRight(this.list, 10)
      },
    },
  })
})
