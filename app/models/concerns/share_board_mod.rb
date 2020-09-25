module ShareBoardMod
  extend ActiveSupport::Concern

  class_methods do
    # 本来スペースは + になり Rails が復元してくれる
    # しかし Slack ? などでそれをさらにエスケープされると + は %2B になってしまい
    # Rails が復元したときは %2B → + で終わる
    # + を %2B にするのは CGI.escape と同じ処理なので CGI.unescape で戻す
    DOUBLE_ESCAPE_MEASURES = true # 2重エスケープ対策をするか？

    def same_body_fetch(params)
      body = params[:body] || "position startpos"
      if DOUBLE_ESCAPE_MEASURES
        body = CGI.unescape(body) # "+" → " "
      end
      body = body.sub(Bioshogi::Sfen::STARTPOS_EXPANSION, "startpos")
      sfen_hash = Digest::MD5.hexdigest(body)
      find_by(sfen_hash: sfen_hash, use_key: :share_board) || create!(kifu_body: body, use_key: :share_board, saturn_key: :private)
    end
  end
end
