# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Lobby message (colosseum_lobby_messages as Colosseum::LobbyMessage)
#
# |-------------+-------------+-------------+-------------+------+-------|
# | name        | desc        | type        | opts        | refs | index |
# |-------------+-------------+-------------+-------------+------+-------|
# | id          | ID          | integer(8)  | NOT NULL PK |      |       |
# | user_id     | ユーザーID  | integer(8)  | NOT NULL    |      | A     |
# | message     | 発言        | text(65535) | NOT NULL    |      |       |
# | msg_options | Msg options | text(65535) | NOT NULL    |      |       |
# | created_at  | 作成日時    | datetime    | NOT NULL    |      |       |
# | updated_at  | 更新日時    | datetime    | NOT NULL    |      |       |
# |-------------+-------------+-------------+-------------+------+-------|

module Colosseum
  class LobbyMessage < ApplicationRecord
    class << self
      def setup(options = {})
        if Rails.env.development?
          user = User.first
          user.lobby_chat_say("(message)")
        end
      end
    end

    belongs_to :user

    serialize :msg_options

    cattr_accessor(:chat_window_size) { 14 }

    scope :latest_list, -> { order(created_at: :desc).limit(chat_window_size) } # 実際に使うときは昇順表示なので reverse しよう

    before_validation on: :create do
      self.msg_options ||= {}
    end

    after_create do
      SlackAgent.chat_post_message(key: "ロビー発言", body: "#{user.name}: #{message}")
    end
  end
end
