<template lang="pug">
.vs-clock
  XclockApp
</template>

<script>
export default {
  name: "Xclock",
  head() {
    return {
      title: "対局時計",
      meta: [
        { hid: "og:title",       property: "og:title",       content: "対局時計"                                                       },
        { hid: "twitter:card",   property: "twitter:card",   content: "summary_large_image"                                            },
        { hid: "og:image",       property: "og:image",       content: this.$config.MY_NUXT_URL + "/ogp/vs-clock.png"                    },
        { hid: "og:description", property: "og:description", content: "ネット対局と同じような持ち時間のプリセットが入った対局時計です" },
      ],
    }
  },
}
</script>

<style lang="sass">
.vs-clock
</style>
