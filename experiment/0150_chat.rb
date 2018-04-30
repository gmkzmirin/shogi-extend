#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

ChatArticle.destroy_all
ChatUser.destroy_all
ChatRoom.destroy_all
ChatMembership.destroy_all

alice = ChatUser.create!
bob = ChatUser.create!

chat_room = alice.owner_rooms.create!
chat_room.chat_users << alice
chat_room.chat_users << bob

tp chat_room.chat_memberships

alice.chat_articles.create(chat_room: chat_room, message: "(body)")
tp ChatArticle

tp chat_room

alice.update!(current_chat_room: chat_room)
tp chat_room.current_chat_users

# >> |----+--------------+--------------+--------------+----------+---------------------------+---------------------------|
# >> | id | chat_room_id | chat_user_id | location_key | position | created_at                | updated_at                |
# >> |----+--------------+--------------+--------------+----------+---------------------------+---------------------------|
# >> |  9 |            6 |            9 | black        |        0 | 2018-04-30 16:44:02 +0900 | 2018-04-30 16:44:02 +0900 |
# >> | 10 |            6 |           10 | white        |        1 | 2018-04-30 16:44:02 +0900 | 2018-04-30 16:44:02 +0900 |
# >> |----+--------------+--------------+--------------+----------+---------------------------+---------------------------|
# >> |----+--------------+--------------+---------+---------------------------+---------------------------|
# >> | id | chat_room_id | chat_user_id | message | created_at                | updated_at                |
# >> |----+--------------+--------------+---------+---------------------------+---------------------------|
# >> |  4 |            6 |            9 | (body)  | 2018-04-30 16:44:02 +0900 | 2018-04-30 16:44:02 +0900 |
# >> |----+--------------+--------------+---------+---------------------------+---------------------------|
# >> |----------------+-------------------------------------------------------------------------------|
# >> |             id | 6                                                                             |
# >> |  room_owner_id | 9                                                                             |
# >> |     preset_key | 平手                                                                          |
# >> |           name | 野良1号の対戦部屋 #1                                                          |
# >> | kifu_body_sfen | position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 |
# >> |     created_at | 2018-04-30 16:44:02 +0900                                                     |
# >> |     updated_at | 2018-04-30 16:44:02 +0900                                                     |
# >> |----------------+-------------------------------------------------------------------------------|
# >> |----+---------+----------------------+--------------+-------------+---------------------------+---------------------------|
# >> | id | name    | current_chat_room_id | appearing_at | matching_at | created_at                | updated_at                |
# >> |----+---------+----------------------+--------------+-------------+---------------------------+---------------------------|
# >> |  9 | 野良1号 |                    6 |              |             | 2018-04-30 16:44:02 +0900 | 2018-04-30 16:44:02 +0900 |
# >> |----+---------+----------------------+--------------+-------------+---------------------------+---------------------------|
