# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Message (acns1_messages as Acns1::Message)
#
# |------------+----------+-------------+-------------+-----------------------+-------|
# | name       | desc     | type        | opts        | refs                  | index |
# |------------+----------+-------------+-------------+-----------------------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |                       |       |
# | user_id    | User     | integer(8)  |             | => Colosseum::User#id | A     |
# | room_id    | Room     | integer(8)  |             |                       | B     |
# | body       | 内容     | text(65535) |             |                       |       |
# | created_at | 作成日時 | datetime    | NOT NULL    |                       |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |                       |       |
# |------------+----------+-------------+-------------+-----------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# 【警告:リレーション欠如】Colosseum::Userモデルで has_many :acns1/messages されていません
#--------------------------------------------------------------------------------

module Acns1
  class Message < ApplicationRecord
    belongs_to :user, class_name: "Colosseum::User" # , foreign_key: "colosseum_user_id"
    belongs_to :room

    before_validation on: :create do
      self.room ||= Room.first
      self.body ||= SecureRandom.hex
    end

    with_options presence: true do
      validates :body
    end

    after_create_commit do
      Acns1::MessageBroadcastJob.perform_later(self)
    end
  end
end
