import _ from "lodash"

import CpuBrainInfo from "cpu_brain_info"

window.CpuBattlesApp = Vue.extend({
  data() {
    return {
      CpuBrainInfo,
      sp_params: this.$options.sp_params,
      full_sfen: "position startpos",
      cpu_brain_key: this.$options.cpu_brain_key,
      current_user: js_global.current_user, // 名前を読み上げるため
    }
  },

  created() {
    CpuBrainInfo.memory_record_reset(this.$options.cpu_brain_infos)

    setTimeout(() => this.talk(`よろしくお願いします。${this.current_call_name}のてばんです`), 1000 * 1)
  },

  computed: {
    cpu_brain_info() {
      return CpuBrainInfo.fetch(this.cpu_brain_key)
    },

    // 対戦者の名前
    current_call_name() {
      let str = null
      if (!str) {
        if (this.current_user) {
          str = `${this.current_user.name}さん`
        }
      }
      if (!str) {
        str = "あなた"
      }
      return str
    },
  },

  watch: {
    cpu_brain_key() {
      this.talk(`${this.cpu_brain_info.name}に変更しました`)
    },
  },

  methods: {
    play_mode_long_sfen_set(v) {
      this.$http.post(this.$options.player_mode_moved_path, {kifu_body: v, cpu_brain_key: this.cpu_brain_key}).then(response => {
        if (response.data["error_message"]) {
          this.$buefy.dialog.alert({
            title: "反則負け",
            message: response.data["error_message"],
            type: 'is-danger',
            hasIcon: true,
            icon: 'times-circle',
            iconPack: 'fa',
          })
          this.talk("反則負けです")

          // this.$buefy.dialog.alert({
          //   message: response.data["normal_message"],
          // })

        }

        if (response.data["you_win_message"]) {
          // this.$buefy.toast.open({message: response.data["normal_message"], position: "is-bottom", type: "is-info", duration: 1000 * 10})

          this.$buefy.dialog.alert({
            title: "勝利",
            message: response.data["you_win_message"],
            type: 'is-primary',
            hasIcon: true,
            icon: 'trophy',
            iconPack: 'mdi',
          })
          this.talk("勝ちました")
        }

        if (response.data["you_lose_message"]) {
          // this.$buefy.toast.open({message: response.data["normal_message"], position: "is-bottom", type: "is-info", duration: 1000 * 10})

          this.$buefy.dialog.alert({
            title: "敗北",
            message: response.data["you_lose_message"],
            type: 'is-primary',
          })
          this.talk("負けました")
        }

        // CPUの指し手を読み上げる
        if (response.data["yomiage"]) {
          this.talk(response.data["yomiage"])
        }

        if (response.data["sfen"]) {
          this.full_sfen = response.data["sfen"]
        }

      }).catch(error => {
        console.table([error.response])
        this.$buefy.toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
      })
    },
  },
})
