# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Room (actb_battles as Actb::Room)
#
# |------------+-----------+-------------+-------------+------+-------|
# | name       | desc      | type        | opts        | refs | index |
# |------------+-----------+-------------+-------------+------+-------|
# | id         | ID        | integer(8)  | NOT NULL PK |      |       |
# | begin_at   | Begin at  | datetime    | NOT NULL    |      | A     |
# | end_at     | End at    | datetime    |             |      | B     |
# | final_key  | Final key | string(255) |             |      | C     |
# | rule_key   | Rule key  | string(255) |             |      | D     |
# | created_at | 作成日時  | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時  | datetime    | NOT NULL    |      |       |
# |------------+-----------+-------------+-------------+------+-------|

# user1 = Colosseum::User.create!
# user2 = Colosseum::User.create!
#
# battle = Actb::Room.create! do |e|
#   e.memberships.build(user: user1, judge_key: "win")
#   e.memberships.build(user: user2, judge_key: "lose")
# end
#
# battle.room_messages.create!(user: user1, body: "a") # => #<Actb::RoomMessage id: 1, user_id: 31, battle_id: 18, body: "a", created_at: "2020-05-05 07:18:46", updated_at: "2020-05-05 07:18:46">
#
module Actb
  class Room < ApplicationRecord
    has_many :battles, dependent: :destroy
    has_many :messages, class_name: "RoomMessage", dependent: :destroy
    has_many :memberships, class_name: "RoomMembership", dependent: :destroy
    has_many :users, through: :memberships

    before_validation do
      self.begin_at ||= Time.current
      if final_key
        self.end_at ||= Time.current
      end

      self.rule_key ||= :marathon_rule

      self.rensen_index ||= 0
    end

    with_options presence: true do
      validates :begin_at
      validates :rule_key
    end

    after_create_commit do
      Actb::RoomBroadcastJob.perform_later(self)
    end

    def final_info
      FinalInfo.fetch_if(final_key)
    end
  end
end
