<template lang="pug">
span.MembershipMedal(:class="wrapper_class" @click="click_handle")
  template(v-if="params.emoji")
    | {{params.emoji}}
  template(v-else-if="params.icon")
    b-icon(:icon="params.icon" :type="params.type" size="is-small" :class="params.class")
  template(v-else)
    | {{params}}
</template>

<script>
export default {
  name: "MembershipMedal",
  props: {
    params: { type: Object, required: true },
  },
  methods: {
    click_handle() {
      const message = this.params.message
      if (message) {
        this.sound_play("click")
        this.toast_ok(message)
      }
    },
  },
  computed: {
    wrapper_class() {
      return {
        my_emoji: this.params.emoji,
        my_icon:  this.params.icon,
        my_raw:   !(this.params.emoji || this.params.icon),
        is_clickable: this.params.message,
      }
    },
  },
}
</script>

<style lang="sass">
.MembershipMedal
  &.my_emoji
    margin-right: 0.2rem
  &.my_icon
    margin-right: 0.4rem

  +mobile
    &.my_emoji
      // 絵文字によって大きさが異なるのので結局完璧に揃えるのは難しい
      margin-right: 0.35rem
    &.my_icon
      margin-right: 0.7rem
</style>
