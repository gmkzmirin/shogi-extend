// Vue.js にする必要ない気がするけど今後膨らむかもしれないのでこれでいい

import * as GooglePalette from 'google-palette'

document.addEventListener("DOMContentLoaded", () => {
  window.SwarsPlayerInfoApp = Vue.extend({
    data() {
      return {
      }
    },

    mounted() {
      new Chart(this.$refs.battle_canvas, this.battle_chart_params)
      new Chart(this.$refs.rule_canvas, this.rule_chart_params)
    },

    methods: {
      color_generate(size) {
        // http://google.github.io/palette.js/
        return GooglePalette("cb-Pastel2", size).map(hex => "#" + hex)
      },
    },

    computed: {
      battle_chart_params() {
        return Object.assign({}, this.$options.battle_chart_params, {
          options: {
            title: {
              display: true,
              text: "対局日時",
            },

            // https://misc.0o0o.org/chartjs-doc-ja/configuration/layout.html
            layout: {
              padding: {
                // left: 0,
                right: 12,
                // top: 0,
                // bottom: 0
              },
            },

            // https://qiita.com/Haruka-Ogawa/items/59facd24f2a8bdb6d369#3-5-%E6%95%A3%E5%B8%83%E5%9B%B3
            scales: {
              xAxes: [
                {
                  type: 'time',
                  time: {
                    unit: "day",
                    displayFormats: {
                      day: "M/D",
                    },
                  },
                },
              ],
              yAxes: [
                {
                  scaleLabel: {
                    display: false,
                    labelString: "時",
                  },
                  ticks: {
                    // suggestedMax: 25,
                    // suggestedMin: 0,
                    // stepSize: 60,
                    callback(value, index, values) {
                      return Math.trunc(value / 60) + "時"
                    }
                  }
                },
              ]
            },

            // https://tr.you84815.space/chartjs/configuration/tooltip.html
            legend: {
              display: true,
            },

            tooltips: {
              callbacks: {
                title(tooltipItems, data) {
                  return ""
                },
                label(tooltipItem, data) {
                  const y = data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index].y
                  const hour = Math.trunc(y / 60)
                  const min = y % 60
                  return `${hour}時${min}分`
                },
              },
            },
          },
        })
      },

      rule_chart_params() {
        const v = Object.assign({}, this.$options.rule_chart_params, {
          options: {
            title: {
              display: true,
              text: "対局モード",
            },
          },
        })
        v.data.datasets[0].backgroundColor = this.color_generate(v.data.datasets[0].data.length)
        return v
      },
    },
  })
})
