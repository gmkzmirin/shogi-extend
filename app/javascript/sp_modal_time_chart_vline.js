// chart.js に縦線を入れる方法
// https://stackoverflow.com/questions/30256695/chart-js-drawing-an-arbitrary-vertical-line

const LocationColorList = [
  "hsla(204, 86%,  53%, 0.4)", // $cyan   先手
  "hsla(348, 100%, 61%, 0.4)", // $danger 後手
]

const ChartVlinePlugin = {
  // Plugin API
  // https://misc.0o0o.org/chartjs-doc-ja/developers/plugins.html
  afterDatasetsDraw(instance, easing) {
    if (instance.config.chart_turn != null) {
      this.vertical_line_render(instance, instance.config.chart_turn)
    }
  },

  // private methods

  line_position_get(instance, chart_turn) {
    const index_info = instance.config.index_info_hash[chart_turn]
    if (index_info) {
      const meta = instance.getDatasetMeta(index_info.datasetIndex)
      // meta:
      //   type: "line"
      //   data: Array(54)
      //     0: ChartElement
      //       _chart: Chart {id: 0, ctx: null, canvas: null, config: {…}, width: 828, …}
      //       _datasetIndex: 1
      //       _index: 0
      //       hidden: false
      //       _xScale: ChartElement {id: "x-axis-0", type: "category", options: {…}, ctx: CanvasRenderingContext2D, chart: Chart, …}
      //       _yScale: ChartElement {id: "y-axis-0", type: "linear", options: {…}, ctx: CanvasRenderingContext2D, chart: Chart, …}
      //       _options: {backgroundColor: "rgba(100.00%, 22.00%, 37.60%, 0.10)", borderColor: "rgba(100.00%, 22.00%, 37.60%, 0.60)", borderWidth: 1, hitRadius: 5, hoverBackgroundColor: undefined, …}
      //       _model: {x: 49.173176518192996, y: 133.96444444444444, skip: false, radius: 1.2, pointStyle: "circle", …}
      //       _view: {x: 49.173176518192996, y: 133.96444444444444, skip: false, radius: 1.2, pointStyle: "circle", …}
      //       _start: null
      //       __proto__: Element
      //     1: ChartElement {_chart: Chart, _datasetIndex: 1, _index: 1, hidden: false, _xScale: ChartElement, …}
      //     2: ChartElement {_chart: Chart, _datasetIndex: 1, _index: 2, hidden: false, _xScale: ChartElement, …}
      //     ...snip...
      //   dataset: ChartElement {_chart: Chart, _datasetIndex: 1, hidden: false, _scale: ChartElement, _children: Array(54), …}
      //   controller: ChartElement {chart: Chart, index: 1, _data: Array(54)}
      //   hidden: null
      //   xAxisID: "x-axis-0"
      //   yAxisID: "y-axis-0"
      //   $filler: {visible: true, fill: "origin", chart: Chart, el: ChartElement, boundary: {…}, …}
      const data = meta.data
      return data[index_info.index]
    } else {
      // 0手目の場合
    }
  },

  vertical_line_render(instance, chart_turn) {
    const chart_element = this.line_position_get(instance, chart_turn)
    if (chart_element) {
      const lineLeftOffset = chart_element._model.x       // chart_turn に対応するX座標
      const _datasetIndex = chart_element._datasetIndex   // chart_turn は先後どちらか

      const scale = instance.scales['y-axis-0']
      const context = instance.chart.ctx

      // render vertical line
      context.beginPath()
      context.strokeStyle = LocationColorList[_datasetIndex]
      context.moveTo(lineLeftOffset, scale.top)
      context.lineTo(lineLeftOffset, scale.bottom)
      context.stroke()

      // write label
      // context.fillStyle = "#ff0000"
      // context.textAlign = 'center'
      // context.fillText('MY TEXT', lineLeftOffset, (scale.bottom - scale.top) / 2 + scale.top)
    }
  },
}

export default {
  props: {
    chart_turn: { required: true, },
  },

  watch: {
    chart_turn(v, ov) {
      this.debug_alert(`watch chart_turn ${ov} => ${v}`)
      this._chart_config.chart_turn = v
      window.chart_instance.update()
    },
  },

  methods: {
    vline_setup() {
      // plugin 適応
      this._chart_config.plugins = [ChartVlinePlugin]

      // chart.js のインスタンスに他のデータを渡す
      // 予約キーと衝突しなかったら自由に引数を追加できる
      // 初期位置設定
      this._chart_config.chart_turn = this.chart_turn
    },

    // 手数から先後どちらのデータを参照したらいいのか難しいため
    // 手数からO(n)で参照するデータを特定できるようにする
    //
    // time_chart_params:
    //   labels: (5) [0, 1, 2, 3, 4]
    //   datasets[0]
    //     label: "devuser1"
    //     data[]
    //       0: {x: 1, y: +3}
    //       1: {x: 3, y: +2}
    //       ...
    //   datasets[1]
    //     label: "devuser2"
    //     data[]
    //       0: {x: 2, y: -3}
    //       1: {x: 4, y: -2}
    //
    // ↓変換
    //
    // {
    //   1 => {datasetIndex: 0, index: 0}
    //   2 => {datasetIndex: 1, index: 0} ← 2手目は datasetIndex が 1 つまり後手で、並びの 0 番目のデータを参照すればいいことがわかる
    //   3 => {datasetIndex: 0, index: 1}
    //   4 => {datasetIndex: 1, index: 1}
    // }
    //
    index_info_hash(time_chart_params) {
      const hash = {}
      time_chart_params.datasets.forEach((dataset, i) => {
        dataset.data.forEach((e, j) => {
          hash[e.x] = { datasetIndex: i, index: j }
        })
      })
      return hash
    },
  },
}
