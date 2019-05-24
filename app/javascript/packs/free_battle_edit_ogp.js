import html2canvas from "html2canvas"

window.FreeBattleEditOgp = Vue.extend({
  data() {
    return {
      tweet_image_url: this.$options.tweet_image_url,
      start_turn: this.$options.og_turn,
      slider_show: false,
    }
  },

  mounted() {
    this.slider_show = true
    this.$nextTick(() => this.$refs.ogp_turn_slider.focus())
  },

  methods: {
    capture_dom_save() {
      const html2canvas_options = {
        // scale: 2,
        // dpi: 144,
      }
      const dom = document.querySelector("#capture_main")
      if (!dom) {
        alert("キャプチャ対象が見つかりません")
        return
      }
      html2canvas(dom, html2canvas_options).then(canvas => {
        const loading_instance = this.$loading.open()
        const params = new URLSearchParams()
        params.set("canvas_image_base64_data_url", canvas.toDataURL("image/png"))
        params.set("image_turn", this.start_turn)
        this.$http.put(this.$options.xhr_put_path, params).then(response => {
          loading_instance.close()
          console.log(response.data)
          this.$toast.open({message: response.data.message})
          this.tweet_image_url = response.data.tweet_image_url
          this.debug_alert(this.tweet_image_url)
        }).catch(error => {
          loading_instance.close()
          console.table([error.response])
          this.$toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
        })
      })
    },

    og_image_create() {
      this.debug_alert("og_image_create")
      this.capture_dom_save()
    },

    og_image_destroy() {
      this.debug_alert("og_image_destroy")

      const params = new URLSearchParams()
      params.set("og_image_destroy", true)
      this.$http.put(this.$options.xhr_put_path, params).then(response => {
        this.$toast.open({message: response.data.message})
        this.tweet_image_url = null
      }).catch(error => {
        console.table([error.response])
        this.$toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
      })
    },

    og_image_create2() {
      const loading_instance = this.$loading.open()
      const params = new URLSearchParams()
      params.set("gazodetukuru", "true")
      params.set("image_turn", this.start_turn)
      this.$http.put(this.$options.xhr_put_path, params).then(response => {
        loading_instance.close()
        console.log(response.data)
        this.$toast.open({message: response.data.message})
        this.tweet_image_url = response.data.tweet_image_url
        this.debug_alert(this.tweet_image_url)
      }).catch(error => {
        loading_instance.close()
        console.table([error.response])
        this.$toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
      })
    },
  },
})
