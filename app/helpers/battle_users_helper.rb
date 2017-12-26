# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズユーザーテーブル (battle_users as BattleUser)
#
# |------------------------------+------------------------------+-------------+-------------+-------------------+-------|
# | カラム名                     | 意味                         | タイプ      | 属性        | 参照              | INDEX |
# |------------------------------+------------------------------+-------------+-------------+-------------------+-------|
# | id                           | ID                           | integer(8)  | NOT NULL PK |                   |       |
# | uid                          | Uid                          | string(255) | NOT NULL    |                   | A!    |
# | battle_grade_id              | Battle grade                 | integer(8)  | NOT NULL    | => BattleGrade#id | B     |
# | last_reception_at            | Last reception at            | datetime    |             |                   |       |
# | battle_user_receptions_count | Battle user receptions count | integer(4)  | DEFAULT(0)  |                   |       |
# | created_at                   | 作成日時                     | datetime    | NOT NULL    |                   |       |
# | updated_at                   | 更新日時                     | datetime    | NOT NULL    |                   |       |
# |------------------------------+------------------------------+-------------+-------------+-------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・BattleUser モデルは BattleGrade モデルから has_many :battle_users されています。
#--------------------------------------------------------------------------------

module BattleUsersHelper
end
