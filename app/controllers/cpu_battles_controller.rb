class CpuBattlesController < ApplicationController
  def js_cpu_battle
    sp_params = self.params.dup
    sp_params[:theme] ||= "real"
    sp_params[:piece_variant] ||= "a"

    {
      player_mode_moved_path: url_for([:cpu_battles, format: "json"]),
      cpu_brain_infos: CpuBrainInfo,
      cpu_brain_key: current_cpu_brain_key,
      sp_params: sp_params,
    }
  end

  def show
    if false
      talk("talk")
      direct_talk("direct_talk")
    end
  end

  def create
    if v = params[:kifu_body]
      info = Bioshogi::Parser.parse(v)
      begin
        mediator = info.mediator
      rescue => error
        lines = error.message.lines
        error_message = [
          "#{lines.first.remove("【反則】")}",

          # "<br><br>"
          # "<pre>", lines.drop(1).join, "</pre>",

          # "<br>",
          # "<br>",
          # '<span class="is-size-7 has-text-grey">一手戻して再開できます</span>'
        ].join

        # info.move_infos.size - 0

        # before_sfen = Bioshogi::Parser.parse(v, turn_limit: 1).mediator.to_sfen
        # before_sfen = Bioshogi::Parser.parse(v, typical_error_case: :embed).mediator.to_sfen
        # render json: {error_message: error_message, before_sfen: before_sfen}

        render json: {error_message: error_message}
        return
      end

      talk(mediator.hand_logs.last.yomiage)

      captured_soldier = mediator.opponent_player.executor.captured_soldier
      if captured_soldier
        if captured_soldier.piece.key == :king
          render json: {you_win_message: "玉を取って勝ちました！", sfen: mediator.to_sfen}
          return
        end
      end

      puts mediator
      if current_cpu_brain_info.depth_max_range
        brain = mediator.current_player.brain(diver_class: Bioshogi::NegaScoutDiver, evaluator_class: Bioshogi::EvaluatorAdvance)
        records = []
        time_limit = current_cpu_brain_info.time_limit

        begin
          records = brain.iterative_deepening(time_limit: time_limit, depth_max_range: current_cpu_brain_info.depth_max_range)
        rescue Bioshogi::BrainProcessingHeavy
          time_limit += 1
          p [:retry, {time_limit: time_limit}]
          retry
        end
        tp Bioshogi::Brain.human_format(records)

        if records.empty?
          render json: {you_win_message: "CPUが投了しました", sfen: mediator.to_sfen}
          return
        end

        record = records.first
        if record[:score] <= -Bioshogi::INF_MAX
          render json: {you_win_message: "CPUが降参しました", sfen: mediator.to_sfen}
          return
        end

        hand = record[:hand]
      else
        hands = mediator.current_player.normal_all_hands.to_a
        if current_cpu_brain_info.legal_only
          hands = hands.find_all { |e| e.legal_move?(mediator) }
        end
        hand = hands.sample
        unless hand
          render json: {you_win_message: "CPUはもう何も指す手がなかったようです", sfen: mediator.to_sfen}
          return
        end
      end

      # CPUの手を指す
      mediator.execute(hand.to_sfen, executor_class: Bioshogi::PlayerExecutorCpu)
      response = { sfen: mediator.to_sfen }

      # CPUの手を読み上げる
      talk(mediator.hand_logs.last.yomiage)

      if true
        # 人間側の合法手が生成できなければ人間側の負け
        if mediator.current_player.legal_all_hands.none?
          render json: response.merge(you_lose_message: "CPUの勝ちです")
          return
        end
      end

      captured_soldier = mediator.opponent_player.executor.captured_soldier
      if captured_soldier
        if captured_soldier.piece.key == :king
          render json: response.merge(you_lose_message: "玉を取られました")
          return
        end
      end

      render json: response
      return
    end
  end

  def current_cpu_brain_info
    CpuBrainInfo.fetch(current_cpu_brain_key)
  end

  def current_cpu_brain_key
    params[:cpu_brain_key].presence || :level3
  end

  class CpuBrainInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :level1, name: "あきれるほど弱い",   time_limit: nil, depth_max_range: nil,  legal_only: false, }, # ランダム
      { key: :level2, name: "ありえないほど弱い", time_limit: nil, depth_max_range: nil,  legal_only: true,  }, # 合法手のランダム
      { key: :level3, name: "めちゃくちゃ弱い",   time_limit: nil, depth_max_range: 0..0, legal_only: nil,   }, # 最初の合法手リストを最善手順に並べたもの
      { key: :level4, name: "かなり弱い",         time_limit:   3, depth_max_range: 0..9, legal_only: nil,   }, # 3秒まで深読みできる
      { key: :level5, name: "弱い",               time_limit:   5, depth_max_range: 0..9, legal_only: nil,   }, # 必ず相手の手を読む
    ]
  end
end
