<template lang="pug">
.the_menu_debug
  .primary_header
    .header_center_title デバッグモード
  .menu_buttons
    b-field
      b-switch(v-model="app.debug_summary_p") オンライン数の表示
    b-field
      b-switch(v-model="app.debug_force_edit_p") 他人の問題を編集
    b-field
      b-switch(v-model="app.debug_read_p") デバッグ情報の表示
    b-field
      b-switch(v-model="app.debug_write_p" type="is-danger") 破壊系を有効化
    b-field
      b-switch(v-model="app.config.lobby_clock_restrict_p") バトル開催時間制限

    b-button(expanded tag="a" :href="`${$config.MY_SITE_URL}/admin/script/user-switch`") 運営ユーザー切り替え
    b-button(expanded tag="a" :href="user_switch_direct_url('sysop')") → 運営
    b-button(expanded tag="a" :href="user_switch_direct_url('932ed39bb18095a2fc73e0002f94ecf1')") → きなこもち
    b-button(expanded tag="a" :href="user_switch_direct_url('bot')") → BOT
    b-button(expanded tag="a" :href="user_switch_direct_url('cdc5800125cd263735933b8419e09b36')") → わらびもち
    b-button(expanded @click="app.menu_to('the_menu_etc')") もどる
</template>

<script>
import { support } from "../support.js"

export default {
  name: "the_menu_debug",
  mixins: [
    support,
  ],
  methods: {
    user_switch_direct_url(user_key) {
      const params = new URLSearchParams()
      params.set("user_key", user_key)
      params.set("redirect_to", location.href)
      return `/admin/script/user_switch_direct?${params}`
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.the_menu_debug
</style>
