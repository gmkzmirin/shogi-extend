<template lang="pug">
.modal-card.AnySourceReadModal
  header.modal-card-head
    p.modal-card-title 棋譜の読み込み
  section.modal-card-body
    b-input(type="textarea" v-model="any_source" ref="any_source")
  footer.modal-card-foot
    b-button(@click="close_handle") キャンセル
    b-button(@click="submit_handle" type="is-primary") 読み込む
</template>

<script>
export default {
  name: "AnySourceReadModal",
  data() {
    return {
      any_source: "",
    }
  },
  mounted() {
    this.desktop_focus_to(this.$refs.any_source.$refs.textarea)
  },
  methods: {
    close_handle() {
      this.sound_play("click")
      this.$emit("close")
    },
    submit_handle() {
      this.close_handle()
      this.$emit("update:any_source", this.any_source)
    },
  },
}
</script>

<style lang="sass">
.AnySourceReadModal
  .modal-card-foot
    justify-content: flex-end
    .button
      font-weight: bold
</style>
