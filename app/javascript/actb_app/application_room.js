import { Room } from "./models/room.js"

export const application_room = {
  data() {
    return {
      // チャット用
      room_messages: null, // メッセージ(複数)
      room_message_body:  null, // 入力中のメッセージ
    }
  },

  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    room_unsubscribe() {
      this.ac_unsubscribe("$ac_room")
    },

    room_setup(room) {
      this.lobby_unsubscribe()

      this.room = new Room(room)

      this.battle_count = 0

      this.room_speak_init()

      this.__assert__(this.$ac_room == null)
      this.$ac_room = this.ac_subscription_create({channel: "Actb::RoomChannel", room_id: this.room.id})
    },

    // メンバーの誰かが RoomChannel を unsubscribe したとき全員に配信される
    // room_member_disconnect_broadcasted(params) {
    //   console.log(params)
    //   debugger
    // },

    // 自分が退出する
    room_out_handle() {
      this.$ac_room.perform("room_out_handle", {membership_id: this.current_membership.id})
    },
    // 相手を退出させる
    room_out_handle2() {
      this.$ac_room.perform("room_out_handle", {membership_id: this.opponent_membership.id})
    },
    room_out_handle_broadcasted(params) {
      this.room_speak(`*${params.membership_id} が退出したことを知った`)
    },

    ////////////////////////////////////////////////////////////////////////////////

    // room_setup connected
    // ↓
    // app/channels/actb/room_channel.rb subscribed
    // ↓
    // app/jobs/actb/battle_broadcast_job.rb broadcast
    // ↓
    battle_broadcasted(params) {
      if (this.info.debug_scene === "battle_marathon_rule" || this.info.debug_scene === "battle_singleton_rule" || this.info.debug_scene === "battle_hybrid_rule") {
        this.battle_setup(this.info.battle)
        return
      }

      if (this.info.debug_scene === "result") {
        this.battle_setup(this.info.battle)
        return
      }

      this.battle_setup(params.battle)
    },

    ////////////////////////////////////////////////////////////////////////////////

    room_speak_init() {
      this.room_messages = []
      this.room_message_body = ""
    },

    room_speak_handle() {
      this.room_speak(this.room_message_body)
      this.room_message_body = ""
    },

    room_speak(message_body) {
      // 受信をバトル側にしている理由は battle_id が自明だと都合が良いため
      this.$ac_battle.perform("speak", {message_body: message_body}) // --> app/channels/actb/battle_channel.rb
    },

    room_speak_broadcasted(params) {
      this.lobby_speak_broadcasted_shared_process(params)
      this.room_messages.push(params.message)
    },

    ////////////////////////////////////////////////////////////////////////////////
  },
}
