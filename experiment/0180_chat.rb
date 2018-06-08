#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

ChatMessage.destroy_all
User.destroy_all
BattleRoom.destroy_all
Membership.destroy_all

alice = User.create!
bob = User.create!

battle_room = OwnerRoom.create!
battle_room.users << alice
battle_room.users << bob

tp battle_room.memberships

alice.chat_messages.create(battle_room: battle_room, message: "(body)")
tp ChatMessage

tp battle_room

alice.update!(current_battle_room: battle_room)
tp battle_room.current_users

# >> |----+--------------+--------------+------------+--------------+----------+------------+-----------------+---------------------------+---------------------------|
# >> | id | battle_room_id | user_id | preset_key | location_key | position | standby_at | fighting_now_at | created_at                | updated_at                |
# >> |----+--------------+--------------+------------+--------------+----------+------------+-----------------+---------------------------+---------------------------|
# >> |  1 |            1 |            2 | 平手       | black        |        0 |            |                 | 2018-05-17 20:31:14 +0900 | 2018-05-17 20:31:14 +0900 |
# >> |  2 |            1 |            3 | 平手       | white        |        1 |            |                 | 2018-05-17 20:31:14 +0900 | 2018-05-17 20:31:14 +0900 |
# >> |----+--------------+--------------+------------+--------------+----------+------------+-----------------+---------------------------+---------------------------|
# >> |----+--------------+--------------+---------+---------------------------+---------------------------|
# >> | id | battle_room_id | user_id | message | created_at                | updated_at                |
# >> |----+--------------+--------------+---------+---------------------------+---------------------------|
# >> |  1 |            1 |            2 | (body)  | 2018-05-17 20:31:14 +0900 | 2018-05-17 20:31:14 +0900 |
# >> |----+--------------+--------------+---------+---------------------------+---------------------------|
# >> |--------------------------+-------------------------------------------------------------------------------|
# >> |                       id | 1                                                                             |
# >> |            room_owner_id | 2                                                                             |
# >> |         black_preset_key | 平手                                                                          |
# >> |         white_preset_key | 平手                                                                          |
# >> |             lifetime_key | lifetime_m5                                                                 |
# >> |                     name | 野良1号の対戦部屋 #1                                                          |
# >> |           kifu_body_sfen | position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 |
# >> |             clock_counts | {:black=>[], :white=>[]}                                                      |
# >> |                 turn_max | 0                                                                             |
# >> |        battle_request_at |                                                                               |
# >> |          auto_matched_at |                                                                               |
# >> |                 begin_at |                                                                               |
# >> |                   end_at |                                                                               |
# >> |          last_action_key |                                                                               |
# >> |         win_location_key |                                                                               |
# >> | current_users_count | 0                                                                             |
# >> |  watch_memberships_count | 0                                                                             |
# >> |               created_at | 2018-05-17 20:31:14 +0900                                                     |
# >> |               updated_at | 2018-05-17 20:31:14 +0900                                                     |
# >> |--------------------------+-------------------------------------------------------------------------------|
# >> |----+---------+----------------------+-----------+-----------------+-------------+---------------+---------------+---------------+---------------------------+---------------------------|
# >> | id | name    | current_battle_room_id | online_at | fighting_now_at | matching_at | lifetime_key  | self_preset_key | oppo_preset_key | created_at                | updated_at                |
# >> |----+---------+----------------------+-----------+-----------------+-------------+---------------+---------------+---------------+---------------------------+---------------------------|
# >> |  2 | 野良1号 |                    1 |           |                 |             | lifetime_m5 | 平手          | 平手          | 2018-05-17 20:31:14 +0900 | 2018-05-17 20:31:14 +0900 |
# >> |----+---------+----------------------+-----------+-----------------+-------------+---------------+---------------+---------------+---------------------------+---------------------------|
