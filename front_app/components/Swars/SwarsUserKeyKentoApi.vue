<template lang="pug">
client-only
  .SwarsUserKeyKentoApi.has-background-white-bis
    MainNavbar
      template(slot="brand")
        b-navbar-item(@click="back_handle")
          b-icon(icon="chevron-left")
        b-navbar-item.has-text-weight-bold.is_small_if_mobile(tag="div") {{page_title}}
    MainSection
      .container
        b-field(label="1. URLをコピー").mt-3
          .control
            b-button(icon-left="clipboard-plus-outline" @click="sound_play('click'); clipboard_copy({text: kento_api_url})")
          b-input(type="text" :value="kento_api_url" expanded readonly)

        b-field(label="2. KENTO側で設定").mt-6
          .control
            b-button(tag="a" href="https://www.kento-shogi.com/setting" target="_blank" icon-right="open-in-new") 移動

        .image.box.mt-5
          img(src="~/assets/kento_settings_api.png")

        p.mt-6.mb-0
          | これでKENTO側でも棋譜一覧が出るようになります
</template>

<script>
export default {
  name: "SwarsUserKeyKentoApi",
  head() {
    return {
      title: this.page_title,
      meta: [
        { hid: "og:title",       property: "og:title",       content: this.page_title,                                    },
        { hid: "twitter:card",   property: "twitter:card",   content: "summary",                                          },
        { hid: "og:image",       property: "og:image",       content: this.$config.MY_NUXT_URL + "/ogp/swars-search.png", },
        { hid: "og:description", property: "og:description", content: "",                                                 },
      ],
    }
  },
  methods: {
    back_handle() {
      this.sound_play('click')
      this.back_to({name: "swars-search", query: {query: this.$route.params.key}})
    },
  },
  computed: {
    page_title() {
      return `${this.$route.params.key}さん専用の KENTO API 設定手順`
    },
    kento_api_url() {
      const params = new URLSearchParams()
      params.set("query", this.$route.params.key)
      params.set("format_type", "kento")
      return this.$config.MY_SITE_URL + `/w.json?${params}`
    },
  },
}
</script>

<style lang="sass">
.SwarsUserKeyKentoApi
  min-height: 100vh

  .MainSection
    &:first-of-type
      padding-top: 2.6rem
  .image
    max-width: 400px
</style>
