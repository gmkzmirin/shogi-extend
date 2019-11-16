import dayjs from "dayjs"

export default {
  data() {
    return {
      memento_list: [],
      memento_list_max: 200,   //  LocalStorage の最大容量は 5MB なので 5.megabytes / url.size => 9118 だけど 2000 ぐらいで重くなるので控えめにする
    }
  },

  created() {
    this.memento_list_load()
  },

  methods: {
    memento_create(event) {
      const last = _.last(this.memento_list)
      if (last) {
        if (last.enc_base64 === this.enc_base64) {
          return
        }
      }

      this.memento_list.push({
        time: dayjs().format("YYYY-MM-DD HH:mm"),
        event: event,
        summary: this.summary,
        current_track: this.current_track,
        book_title: this.book_title,
        enc_base64: this.enc_base64,

      })
      this.memento_list = _.takeRight(this.memento_list, this.memento_list_max)
      this.memento_list_save()
    },

    memento_restore(row) {
      this.log_modal.close()
      const message = "指定の時間の状態に戻しました"
      this.talk(message)
      this.$buefy.toast.open({message: message, position: "is-bottom", type: "is-info", duration: 1000 * 1, queue: false})
      this.data_restore_from_base64(row.enc_base64)
    },

    memento_list_load() {
      if (false) {
        this.memento_list_clear()
      }

      const base64 = localStorage.getItem(this.memento_list_storage_key)
      if (base64) {
        this.memento_list = this.base64_to_value(base64)
      }
    },

    memento_list_save() {
      localStorage.setItem(this.memento_list_storage_key, this.value_to_base64(this.memento_list))
    },

    memento_list_clear() {
      localStorage.removeItem(this.memento_list_storage_key)
      this.memento_list = []
    },
  },

  computed: {
    memento_list_storage_key() {
      return [this.local_storage_key, "log"].join("_")
    },
  },
}
