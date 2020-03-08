# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 棋譜投稿 (free_battles as FreeBattle)
#
# |-------------------+--------------------+----------------+-------------+-----------------------------------+-------|
# | name              | desc               | type           | opts        | refs                              | index |
# |-------------------+--------------------+----------------+-------------+-----------------------------------+-------|
# | id                | ID                 | integer(8)     | NOT NULL PK |                                   |       |
# | key               | ユニークなハッシュ | string(255)    | NOT NULL    |                                   | A!    |
# | kifu_url          | 棋譜URL            | string(255)    |             |                                   |       |
# | kifu_body         | 棋譜               | text(16777215) |             |                                   |       |
# | turn_max          | 手数               | integer(4)     | NOT NULL    |                                   | D     |
# | meta_info         | 棋譜ヘッダー       | text(16777215) | NOT NULL    |                                   |       |
# | battled_at        | Battled at         | datetime       | NOT NULL    |                                   | C     |
# | created_at        | 作成日時           | datetime       | NOT NULL    |                                   |       |
# | updated_at        | 更新日時           | datetime       | NOT NULL    |                                   |       |
# | colosseum_user_id | 所有者ID           | integer(8)     |             | :owner_user => Colosseum::User#id | B     |
# | title             | 題名               | string(255)    |             |                                   |       |
# | description       | 説明               | text(16777215) | NOT NULL    |                                   |       |
# | start_turn        | 開始局面           | integer(4)     |             |                                   |       |
# | critical_turn     | 開戦               | integer(4)     |             |                                   | E     |
# | saturn_key        | 公開範囲           | string(255)    | NOT NULL    |                                   | F     |
# | sfen_body         | SFEN形式棋譜       | string(8192)   |             |                                   |       |
# | image_turn        | OGP画像の局面      | integer(4)     |             |                                   |       |
# | use_key           | Use key            | string(255)    | NOT NULL    |                                   |       |
# | outbreak_turn     | Outbreak turn      | integer(4)     |             |                                   |       |
# | accessed_at       | Accessed at        | datetime       | NOT NULL    |                                   |       |
# |-------------------+--------------------+----------------+-------------+-----------------------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_many :free_battles, foreign_key: :colosseum_user_id
#--------------------------------------------------------------------------------

class AddOutbreakTurnToFreeBattles < ActiveRecord::Migration[5.2]
  def change
    [:swars_battles, :free_battles].each do |table|
      change_table table do |t|
        # t.remove :accessed_at rescue nil
        # t.remove :outbreak_turn rescue nil
        t.integer :outbreak_turn, null: true
      end
    end

    model = Swars::Battle
    change_table model.table_name do |t|
      t.datetime :accessed_at, null: true
    end
    model.reset_column_information
    model.update_all("accessed_at = last_accessd_at")
    change_table model.table_name do |t|
      t.change :accessed_at, :datetime, null: false
    end
    model.reset_column_information

    model = FreeBattle
    change_table model.table_name do |t|
      t.datetime :accessed_at, null: true
    end
    model.reset_column_information
    model.update_all("accessed_at = updated_at")
    change_table model.table_name do |t|
      t.change :accessed_at, :datetime, null: false
    end
    model.reset_column_information
  end
end
