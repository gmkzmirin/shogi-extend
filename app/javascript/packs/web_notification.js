// import _ from "lodash"
// import axios from "axios"

document.addEventListener('DOMContentLoaded', () => {
  App.web_notification = App.cable.subscriptions.create({
    channel: "WebNotificationChannel",
    // chat_room_id: chat_room_app_params.chat_room.id,
  }, {
    connected() {
    },
    disconnected() {
    },
    received(data) {
      if (data["message"]) {
        const message = data["message"]
        const from = data["from"]
        const to = data["to"]
        str = `${from.name}: ${message}`
        Vue.prototype.$toast.open({message: str, position: "is-bottom", type: "is-info", duration: 1000 * 2})
      }
    },
    // 自由に定義してよいメソッド
    message_send_to(data) {
      this.perform("message_send_to", data)
    },
  })

  // App.web_notification_vm = new Vue({
  //   el: "#web_notification_app",
  //   data() {
  //     return {
  //       kifu_body_sfen: "position startpos",  // 棋譜(shogi-player用)
  //       message: "",                          // 発言
  //       chat_articles: [],                    // 発言一覧
  //       online_chat_users: [],                // 参加者
  //       human_kifu_text: "(human_kifu_text)", // 棋譜
  //     }
  //   },
  //   watch: {
  //   },
  //   methods: {
  //     message_enter(value) {
  //       if (this.message !== "") {
  //         App.chat_room.chat_say(this.message)
  //       }
  //       this.message = ""
  //     },
  //
  //     chat_user_self_p(chat_user) {
  //       return chat_user.id === chat_room_app_params.current_chat_user.id
  //     },
  //   },
  //   computed: {
  //     latest_chat_articles() {
  //       return _.takeRight(this.chat_articles, 10)
  //     },
  //   },
  // })
})
