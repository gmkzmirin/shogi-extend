# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 棋譜投稿 (free_battles as FreeBattle)
#
# |---------------+--------------------+----------------+-------------+------------+-------|
# | name          | desc               | type           | opts        | refs       | index |
# |---------------+--------------------+----------------+-------------+------------+-------|
# | id            | ID                 | integer(8)     | NOT NULL PK |            |       |
# | key           | ユニークなハッシュ | string(255)    | NOT NULL    |            | A!    |
# | kifu_url      | 棋譜URL            | string(255)    |             |            |       |
# | kifu_body     | 棋譜               | text(16777215) | NOT NULL    |            |       |
# | turn_max      | 手数               | integer(4)     | NOT NULL    |            | E     |
# | meta_info     | 棋譜ヘッダー       | text(65535)    | NOT NULL    |            |       |
# | battled_at    | Battled at         | datetime       | NOT NULL    |            | D     |
# | outbreak_turn | Outbreak turn      | integer(4)     |             |            | B     |
# | use_key       | Use key            | string(255)    | NOT NULL    |            | C     |
# | accessed_at   | Accessed at        | datetime       | NOT NULL    |            |       |
# | created_at    | 作成日時           | datetime       | NOT NULL    |            |       |
# | updated_at    | 更新日時           | datetime       | NOT NULL    |            |       |
# | user_id       | User               | integer(8)     |             | => User#id | I     |
# | title         | タイトル           | string(255)    |             |            |       |
# | description   | 説明               | text(65535)    | NOT NULL    |            |       |
# | start_turn    | 開始局面           | integer(4)     |             |            | F     |
# | critical_turn | 開戦               | integer(4)     |             |            | G     |
# | saturn_key    | 公開範囲           | string(255)    | NOT NULL    |            | H     |
# | sfen_body     | SFEN形式棋譜       | string(8192)   | NOT NULL    |            |       |
# | image_turn    | OGP画像の局面      | integer(4)     |             |            |       |
# | preset_key    | Preset key         | string(255)    | NOT NULL    |            |       |
# | sfen_hash     | Sfen hash          | string(255)    | NOT NULL    |            |       |
# |---------------+--------------------+----------------+-------------+------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

require "open-uri"

class FreeBattle < ApplicationRecord
  include BattleModelMod
  include ShareBoardMod

  class << self
    def setup(options = {})
      super

      # if Rails.env.development?
      #   unless exists?
      #     30.times { create!(kifu_body: "") }
      #   end
      # end

      if AppConfig[:free_battles_import]
        Pathname.glob(Rails.root.join("config/app_data/free_battles/**/0*.kif")).each { |file| file_import(file) }
      end

      # if Rails.env.development?
      #   Pathname("~/src/bioshogi").expand_path.glob("experiment/必死道場/*.kif").sort.each do |file|
      #     name = file.basename(".*").to_s
      #     key = Digest::MD5.hexdigest(file.to_s)
      #
      #     if record = find_by(key: key)
      #       record.destroy!
      #     end
      #
      #     record = find_by(key: key) || new(key: key)
      #     record.user = User.find_by(name: Rails.application.credentials.production_my_user_name) || User.sysop
      #     record.kifu_body = file.read.toutf8
      #     record.title = "必死道場 #{name}"
      #     record.start_turn = 0
      #     record.save!
      #     p [file.to_s, record.id]
      #   end
      # end
    end

    def file_import(file)
      kifu_body = file.read

      if md = file.basename(".*").to_s.match(/(?<number>\w+?)_(?<key>\w+?)_(?<saturn_key>.)_(?<title_with_desc>.*)/)
        title, description = md["title_with_desc"].split("__")
        record = find_by(key: md["key"]) || new(key: md["key"])
        record.user = User.find_by(name: Rails.application.credentials.production_my_user_name) || User.sysop
        record.kifu_body = kifu_body
        record.title = title.gsub(/_/, " ")

        if description
          if md2 = description.match(/\As(?<start_turn>\d+)_?(?<rest>.*)/)
            record.start_turn = md2["start_turn"].to_i
            description = md2["rest"]
          end

          record.description = description.to_s.gsub(/_/, " ").strip
        end

        # record.public_send("#{:kifu_body}_will_change!") # 強制的にパースさせるため

        if saturn_info = SaturnInfo.find { |e| e.char_key == md["saturn_key"] }
          record.saturn_key = saturn_info.key
        end

        error = nil
        begin
          # record.parser_exec    # かならずパースする
          if kifu_body.blank?
            if record.persisted?
              record.destroy!
            end
          else
            record.save!
          end
        rescue => error
          pp record
          pp record.errors.full_messages
          pp error
          raise error
        end

        p [record.id, record.title, record.description, error]
      end
    end

    def old_record_destroy(params = {})
      params = {
        expires_in: 8.weeks,
      }.merge(params)

      s = all
      s = s.where(arel_table[:use_key].eq_any(["adapter", "share_board"]))
      s = s.where(arel_table[:accessed_at].lteq(params[:expires_in].ago))
      s.find_in_batches(batch_size: 100) do |g|
        begin
          g.each(&:destroy)
        rescue ActiveRecord::Deadlocked => error
          puts error
        end
      end
    end
  end

  has_secure_token :key

  attribute :kifu_file

  belongs_to :user, required: false

  class << self
    def generate_unique_secure_token
      if Rails.env.test?
        return "#{name.demodulize.underscore}#{count.next}"
      end
      SecureRandom.hex
    end
  end

  before_validation do
    if Rails.env.test?
      self.kifu_body ||= Pathname(__dir__).join("嬉野流.kif").read
    end

    self.title ||= default_title
    self.description ||= ""
    self.kifu_body ||= ""

    if kifu_file
      v = kifu_file.read
      v = v.to_s.toutf8 rescue nil
      self.kifu_body = v
    end

    if will_save_change_to_attribute?(:kifu_url)
      if v = kifu_url.presence
        self.kifu_body = http_get_body(v)
        self.kifu_url = nil
      end
    end

    if will_save_change_to_attribute?(:kifu_body) && kifu_body
      if v = UrlEmbedKifuParser.parse(kifu_body)
        self.kifu_body = v
      end
    end
  end

  before_save do
    if will_save_change_to_attribute?(:kifu_body)
      if kifu_body
        # 「**候補手」のようなのがついていると容量が大きすぎてDBに保存できなくなるためコメントを除外する
        # コメントは残したいので ** で始まるものだけ除去する
        if Bioshogi::Parser::KifParser.accept?(kifu_body)
          self.kifu_body = Bioshogi::Parser.source_normalize(kifu_body).gsub(/^\*\*.*\R/, "")
        end
        parser_exec
      end
    end
  end

  def to_param
    key
  end

  def battle_decorator_class
    BattleDecorator::FreeBattleDecorator
  end

  concerning :SaturnMethods do
    included do
      before_validation do
        self.saturn_key ||= "public"
      end
    end

    def saturn_info
      SaturnInfo.fetch(saturn_key)
    end
  end

  # ここは nil でよくね？
  def tournament_name
    if v = safe_meta_info
      v.dig(:header, "棋戦")
    end
  end

  # コントローラーでは meta_info を除外しているため取れない場合がある
  # そういうとき meta_info にアクセスする用
  def safe_meta_info
    if has_attribute?(:meta_info)
      meta_info
    else
      self.class.where(id: id).pluck(:meta_info).first
    end
  end

  def default_title
    # "#{self.class.count.next}番目の何かの棋譜"
    ""
  end

  def safe_title
    title.presence || key
  end

  # 01060_77dacfcf0a24e8315ddd51e86152d3b2_横歩取り_急戦1__飛車先を受けずに互いに攻め合うと封じ込まれて後手有利.kif
  # のような形式にする
  def download_filename
    if use_info.key == :adapter
      return key
    end

    parts = []
    parts << "%05d" % id
    parts << "_"
    parts << key
    parts << "_"
    parts << saturn_info.char_key
    parts << "_"
    parts << title.gsub(/\p{Space}+/, "_")
    if description.present?
      parts << "__"

      if start_turn
        parts << "s#{start_turn}" + "_"
      end

      parts << description.truncate(80, omission: "").gsub(/\p{Space}+/, "_")
    end
    parts.join
  end

  def http_get_body(url)
    UrlEmbedKifuParser.http_get_body(url)
  end

  def fast_parser_options
    if use_info.key == :share_board
      # めちゃくちゃな操作でもエラーにしない
      {
        :candidate_enable => false,
        :validate_enable  => false,
      }
    else
      {}
    end
  end

  # 野良棋譜の場合、手合割は解析しないとわからない
  # ウォーズはあらかじめわかっているのでこの処理はいれない
  def preset_key_set(info)
    self.preset_key = info.preset_info.key
  end

  def parser_exec_after(info)
    self.meta_info = info.mediator.players.inject({}) do |a, player|
      a.merge(player.location.key => player.skill_set.to_h)
    end

    if use_info.key == :basic
      self.defense_tag_list = ""
      self.attack_tag_list = ""
      self.technique_tag_list = ""
      self.note_tag_list = ""
      # self.other_tag_list = ""

      defense_tag_list.add   info.mediator.players.flat_map { |e| e.skill_set.defense_infos.normalize.flat_map { |e| [e.name, *e.alias_names] } }
      attack_tag_list.add    info.mediator.players.flat_map { |e| e.skill_set.attack_infos.normalize.flat_map  { |e| [e.name, *e.alias_names] } }
      technique_tag_list.add info.mediator.players.flat_map { |e| e.skill_set.technique_infos.normalize.flat_map  { |e| [e.name, *e.alias_names] } }
      note_tag_list.add      info.mediator.players.flat_map { |e| e.skill_set.note_infos.normalize.flat_map  { |e| [e.name, *e.alias_names] } }
    end
  end

  # free_battle = FreeBattle.same_body_fetch(body: "68銀")
  # free_battle.simple_versus_desc # =>  "▲嬉野流 vs △その他"
  def simple_versus_desc
    if meta_info
      if meta_info.kind_of?(Hash)
        if meta_info.has_key?(:black)
          hash = meta_info.inject({}) { |a, (location_key, hash)|
            name = []
            name += hash[:attack]
            name += hash[:defense]
            a.merge(location_key => name)
          }
          if hash.values.any?(&:present?)
            hash.collect { |location_key, e|
              [Bioshogi::Location.fetch(location_key).hexagon_mark, (e.presence || ["その他"]).join(" ")].join
            }.join(" vs ")
          end
        end
      end
    end
  end

  concerning :UseInfoMethods do
    included do
      before_validation do
        self.use_key ||= UseInfo.fetch(:basic).key
      end

      with_options presence: true do
        validates :use_key
      end

      with_options allow_blank: true do
        validates :use_key, inclusion: UseInfo.keys.collect(&:to_s)
      end
    end

    def use_info
      UseInfo.fetch(use_key)
    end
  end

  concerning :TimeChartMod do
    # FreeBattle の方は preset_info がないため
    def preset_info
      @preset_info ||= fast_parsed_info.preset_info
    end

    def time_chart_datasets
      Bioshogi::Location.collect do |location|
        {
          label: location.name,
          data: time_chart_xy_list(location),
        }
      end
    end
  end

  concerning :HelperMod do
    def piyo_shogi_base_params
      decorator = mini_battle_decorator
      a = {}
      a[:game_name] = decorator.normalized_full_tournament_name
      names = Bioshogi::Location.collect { |e| [decorator.player_name_for(e), decorator.grade_name_for(e)].compact.join(" ") }
      a.update([:sente_name, :gote_name].zip(names).to_h)
      a
    end
  end
end
