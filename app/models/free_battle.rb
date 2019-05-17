# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 棋譜投稿 (free_battles as FreeBattle)
#
# |-------------------+--------------------+-------------+-------------+-----------------------------------+-------|
# | name              | desc               | type        | opts        | refs                              | index |
# |-------------------+--------------------+-------------+-------------+-----------------------------------+-------|
# | id                | ID                 | integer(8)  | NOT NULL PK |                                   |       |
# | key               | ユニークなハッシュ | string(255) | NOT NULL    |                                   | A!    |
# | kifu_url          | 棋譜URL            | string(255) |             |                                   |       |
# | kifu_body         | 棋譜               | text(65535) | NOT NULL    |                                   |       |
# | turn_max          | 手数               | integer(4)  | NOT NULL    |                                   | D     |
# | meta_info         | 棋譜ヘッダー       | text(65535) | NOT NULL    |                                   |       |
# | battled_at        | Battled at         | datetime    | NOT NULL    |                                   | C     |
# | created_at        | 作成日時           | datetime    | NOT NULL    |                                   |       |
# | updated_at        | 更新日時           | datetime    | NOT NULL    |                                   |       |
# | colosseum_user_id | 所有者ID           | integer(8)  |             | :owner_user => Colosseum::User#id | B     |
# | title             | タイトル           | string(255) |             |                                   |       |
# | description       | 備考               | text(65535) | NOT NULL    |                                   |       |
# | start_turn        | 開始手数           | integer(4)  |             |                                   |       |
# | critical_turn     | 開戦               | integer(4)  |             |                                   |       |
# | saturn_key        | Saturn key         | string(255) | NOT NULL    |                                   |       |
# |-------------------+--------------------+-------------+-------------+-----------------------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_many :free_battles, foreign_key: :colosseum_user_id
#--------------------------------------------------------------------------------

require "open-uri"

class FreeBattle < ApplicationRecord
  include BattleModelSharedMethods

  class << self
    def setup(**options)
      super

      # if Rails.env.development?
      #   unless exists?
      #     30.times { create!(kifu_body: "") }
      #   end
      # end

      Pathname.glob(Rails.root.join("config/app_data/free_battles/0*.kif")).each { |file| file_import(file) }
    end

    def file_import(file)
      if md = file.basename(".*").to_s.match(/(?<number>\w+?)_(?<key>\w+?)_(?<saturn_key>.)_(?<title_with_desc>.*)/)
        title, description = md["title_with_desc"].split("__")
        record = find_by(key: md["key"]) || new(key: md["key"])
        record.owner_user = Colosseum::User.find_by(name: Rails.application.credentials.production_my_user_name) || Colosseum::User.sysop
        record.kifu_body = file.read
        record.title = title.gsub(/_/, " ")
        record.description = description.to_s.gsub(/_/, " ")
        # record.public_send("#{:kifu_body}_will_change!") # 強制的にパースさせるため

        if md["saturn_key"] == "0"
          record.saturn_key = :private
        end
        if md["saturn_key"] == "1"
          record.saturn_key = :public
        end

        error = nil
        begin
          # record.parser_exec    # かならずパースする
          record.save!
        rescue => error
          pp record
          pp record.errors.full_messages
          pp error
          raise error
        end

        p [record.id, record.title, record.description, error]
      end
    end
  end

  has_secure_token :key

  has_one_attached :kifu_file

  belongs_to :owner_user, :class_name => "Colosseum::User", :foreign_key => "colosseum_user_id", required: false

  class << self
    def generate_unique_secure_token
      SecureRandom.hex
    end
  end

  def safe_title
    title.presence || "#{self.class.count.next}番目の何かの棋譜"
  end

  def to_title
    title
  end

  # 01060_77dacfcf0a24e8315ddd51e86152d3b2_横歩取り_急戦1__飛車先を受けずに互いに攻め合うと封じ込まれて後手有利.kif
  # のような形式にする
  def download_filename
    parts = []
    parts << "%05d" % id
    parts << "_"
    parts << key
    parts << "_"
    parts << title.gsub(/\p{Space}+/, "_")
    if description.present?
      parts << "__"
      parts << description.truncate(80, omission: "").gsub(/\p{Space}+/, "_")
    end
    parts.join
  end

  before_validation do
    self.title = safe_title
    self.description ||= ""

    self.kifu_body ||= ""

    if kifu_file.attached?
      v = kifu_file.download
      v = v.to_s.toutf8 rescue nil
      self.kifu_body = v
    end

    if changes_to_save[:kifu_url]
      if v = kifu_url.presence
        self.kifu_body = open(v, &:read).toutf8
        self.kifu_url = nil
      end
    end

    if changes_to_save[:kifu_body]
      if v = kifu_body.to_s.strip.presence
        if v.start_with?("http")
          self.kifu_body = open(v, &:read).toutf8
        end
      end
    end
  end

  before_save do
    if changes_to_save[:kifu_body]
      kifu_file.purge
      if kifu_body
        parser_exec
      end
    end
  end

  after_create do
    if Rails.env.production? || Rails.env.test?
      SlackAgent.message_send(key: "棋譜投稿", body: title)
    end
  end

  concerning :TagMethods do
    included do
      acts_as_ordered_taggable_on :defense_tags
      acts_as_ordered_taggable_on :attack_tags
      acts_as_ordered_taggable_on :technique_tags
      acts_as_ordered_taggable_on :note_tags
      acts_as_ordered_taggable_on :other_tags
    end
  end
end
