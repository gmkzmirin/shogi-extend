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
# | title             | 題名               | string(255) |             |                                   |       |
# | description       | 説明               | text(65535) | NOT NULL    |                                   |       |
# | start_turn        | 開始手数           | integer(4)  |             |                                   |       |
# | critical_turn     | 開戦               | integer(4)  |             |                                   |       |
# | saturn_key        | Saturn key         | string(255) | NOT NULL    |                                   |       |
# |-------------------+--------------------+-------------+-------------+-----------------------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_many :free_battles, foreign_key: :colosseum_user_id
#--------------------------------------------------------------------------------

class CreateFreeBattles < ActiveRecord::Migration[5.1]
  def up
    create_table :free_battles, force: true do |t|
      t.string :key, null: false, index: {unique: true}, charset: 'utf8', collation: 'utf8_bin', comment: "URL識別子"
      t.string :kifu_url, comment: "入力した棋譜URL"
      t.text :kifu_body, null: false, comment: "棋譜本文"
      t.integer :turn_max, null: false, comment: "手数"
      t.text :meta_info, null: false, comment: "棋譜メタ情報"
      t.datetime :battled_at, null: false, comment: "対局開始日時"
      t.timestamps null: false
    end

    create_table :converted_infos, force: true do |t|
      t.belongs_to :convertable, polymorphic: true, null: false, comment: "親"
      t.text :text_body, null: false, comment: "棋譜内容"
      t.string :text_format, null: false, index: true, comment: "棋譜形式"
      t.timestamps null: false
    end
  end
end
