<template lang="pug">
.the_lobby_debug.box(v-if="app.debug_write_p")
  .buttons.are-small
    template(v-for="row in app.RuleInfo.values")
      b-button(@click="app.debug_matching_add_handle(row)") 自分以外を{{row.name}}に参加させる
    b-button(@click="app.matching_users_clear_handle") 全員解散
    b-button(@click="app.new_challenge_accept_handle({rule_key: 'test_rule', user: {id:1,name:'user1'}})") マッチングの人と直接対戦する
    b-button(@click="app.new_challenge_notify({rule_key: 'test_rule', user: {id:1,name:'user1'}, duration: 1000*60*60})") マッチングを開始した人がいる通知
    b-button(@click="app.new_challenge_notify({rule_key: 'test_rule', user: {id:1,name:'user1'}, duration: 1000})") マッチングを開始した人がいる通知(1秒)
    b-button(@click="app.new_challenge_snackbar_clear") 挑戦者登場snackbar消去({{app.snackbar_instances.length}})
</template>

<script>
import { support } from "./support.js"

export default {
  name: "the_builder",
  mixins: [
    support,
  ],
}
</script>

<style lang="sass">
@import "support.sass"
.the_lobby_debug
  .image
    img
</style>
