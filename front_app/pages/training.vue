<template lang="pug">
client-only
  .training
    TrainingApp(:info="info")
</template>

<script>
export default {
  name: "training",
  head() {
    return {
      title: "将棋トレーニングバトル",
      meta: [
        { hid: "og:title",       property: "og:title",       content: "将棋トレーニングバトル"                      },
        { hid: "og:image",       property: "og:image",       content: this.$config.MY_NUXT_URL + "/ogp/training.png" },
        { hid: "og:description", property: "og:description", content: "将棋の問題を解く力を競う対戦ゲーム"          },
      ],
    }
  },
  async asyncData({ $axios, query }) {
    const info = await $axios.$get("/api/training.json", {params: query})
    return { info }
  },
}
</script>

<style lang="sass">
.training
</style>
