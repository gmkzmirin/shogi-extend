require "./setup"

User.delete_all

Actb.destroy_all
Actb.setup

Actb::Lineage.all.collect(&:key)                 # => ["詰将棋", "実戦詰め筋", "手筋", "必死", "必死逃れ", "定跡", "秘密"]
Actb::Judge.all.collect(&:key)                   # => ["win", "lose", "draw", "pending"]
Actb::Rule.all.collect(&:key)                    # => ["marathon_rule", "singleton_rule", "hybrid_rule"]
Actb::Final.all.collect(&:key)                   # => ["f_give_up", "f_disconnect", "f_success", "f_draw", "f_pending"]

10.times do
  Actb::Season.create!
end
Actb::Season.count              # => 11

# tp Actb.info

user1 = User.sysop
user2 = User.find_or_create_by!(key: "alice")

User.setup
# 8.times do |e|
#   User.create!
# end

# 問題作成
10.times do |i|
  question = user1.actb_questions.create! do |e|
    e.init_sfen = "4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l#{i+1}p 1"
    e.moves_answers.build(moves_str: "G*4b")
    e.moves_answers.build(moves_str: "G*5b")
    e.moves_answers.build(moves_str: "G*6b")

    e.updated_at = Time.current - 1.days + i.hours

    e.time_limit_sec        = 60 * 3
    e.difficulty_level      = 5
    e.title                 = "(title)"
    e.description           = "(description)"
    e.hint_desc             = "(hint_desc)"
    if i.odd?
      e.other_author        = "(other_author)"
    end
  end
end
Actb::Question.count           # => 10

question = Actb::Question.first!
question.lineage.key               # => "詰将棋"

# 最初の問題だけゴミ箱へ
question = Actb::Question.first!
# question.update!(folder: question.user.actb_trash_box) の方法はださい
question.user.actb_trash_box.questions << question
question.folder # => #<Actb::TrashBox id: 27, user_id: 9, type: "Actb::TrashBox", created_at: "2020-06-06 12:53:14", updated_at: "2020-06-06 12:53:14">

# 2番目の問題は下書きへ
question = Actb::Question.second!
question.folder_key           # => "active"
question.folder_key = :draft
question.save!                 # => true
question.folder.type           # => "Actb::DraftBox"
# tp question.as_json
# exit

# 部屋を立てる
room = Actb::Room.create! do |e|
  e.memberships.build(user: user1)
  e.memberships.build(user: user2)
end

room.users.collect(&:name)                      # => ["運営", "名無しの棋士2号"]

# 対戦を作成
battle = room.battles.create! do |e|
  e.memberships.build(user: user1)
  e.memberships.build(user: user2)
end
battle                          # => #<Actb::Battle id: 1, room_id: 1, parent_id: nil, rule_id: 1, final_id: 5, begin_at: "2020-06-06 12:53:16", end_at: nil, rensen_index: 0, created_at: "2020-06-06 12:53:16", updated_at: "2020-06-06 12:53:16">

battle.users.count                # => 2
battle.rensen_index               # => 0

battle2 = battle.onaji_heya_wo_atarasiku_tukuruyo # => #<Actb::Battle id: 2, room_id: 1, parent_id: 1, rule_id: 1, final_id: 5, begin_at: "2020-06-06 12:53:16", end_at: nil, rensen_index: 1, created_at: "2020-06-06 12:53:16", updated_at: "2020-06-06 12:53:16">
battle2.rensen_index                            # => 1

membership = battle.memberships.first

# 出題
battle.best_questions             # => [{"id"=>3, "init_sfen"=>"position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l3p 1", "time_limit_sec"=>180, "difficulty_level"=>5, "title"=>"(title)", "description"=>"(description)", "hint_desc"=>"(hint_desc)", "other_author"=>"(other_author)", "other_author_link"=>"(other_author_link)", "user"=>{"id"=>9, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0005_fallback_avatar_icon-acde5a972cba71490139455574a35d908e0b3fe25535de9a39e2d98beae4b0aa.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"G*4b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*6b", "end_sfen"=>nil}]}, {"id"=>4, "init_sfen"=>"position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l4p 1", "time_limit_sec"=>180, "difficulty_level"=>5, "title"=>"(title)", "description"=>"(description)", "hint_desc"=>"(hint_desc)", "other_author"=>"(other_author)", "other_author_link"=>"(other_author_link)", "user"=>{"id"=>9, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0005_fallback_avatar_icon-acde5a972cba71490139455574a35d908e0b3fe25535de9a39e2d98beae4b0aa.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"G*4b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*6b", "end_sfen"=>nil}]}, {"id"=>5, "init_sfen"=>"position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l5p 1", "time_limit_sec"=>180, "difficulty_level"=>5, "title"=>"(title)", "description"=>"(description)", "hint_desc"=>"(hint_desc)", "other_author"=>"(other_author)", "other_author_link"=>"(other_author_link)", "user"=>{"id"=>9, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0005_fallback_avatar_icon-acde5a972cba71490139455574a35d908e0b3fe25535de9a39e2d98beae4b0aa.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"G*4b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*6b", "end_sfen"=>nil}]}, {"id"=>6, "init_sfen"=>"position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l6p 1", "time_limit_sec"=>180, "difficulty_level"=>5, "title"=>"(title)", "description"=>"(description)", "hint_desc"=>"(hint_desc)", "other_author"=>"(other_author)", "other_author_link"=>"(other_author_link)", "user"=>{"id"=>9, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0005_fallback_avatar_icon-acde5a972cba71490139455574a35d908e0b3fe25535de9a39e2d98beae4b0aa.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"G*4b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*6b", "end_sfen"=>nil}]}, {"id"=>7, "init_sfen"=>"position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l7p 1", "time_limit_sec"=>180, "difficulty_level"=>5, "title"=>"(title)", "description"=>"(description)", "hint_desc"=>"(hint_desc)", "other_author"=>"(other_author)", "other_author_link"=>"(other_author_link)", "user"=>{"id"=>9, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0005_fallback_avatar_icon-acde5a972cba71490139455574a35d908e0b3fe25535de9a39e2d98beae4b0aa.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"G*4b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*6b", "end_sfen"=>nil}]}, {"id"=>8, "init_sfen"=>"position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l8p 1", "time_limit_sec"=>180, "difficulty_level"=>5, "title"=>"(title)", "description"=>"(description)", "hint_desc"=>"(hint_desc)", "other_author"=>"(other_author)", "other_author_link"=>"(other_author_link)", "user"=>{"id"=>9, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0005_fallback_avatar_icon-acde5a972cba71490139455574a35d908e0b3fe25535de9a39e2d98beae4b0aa.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"G*4b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*6b", "end_sfen"=>nil}]}, {"id"=>9, "init_sfen"=>"position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l9p 1", "time_limit_sec"=>180, "difficulty_level"=>5, "title"=>"(title)", "description"=>"(description)", "hint_desc"=>"(hint_desc)", "other_author"=>"(other_author)", "other_author_link"=>"(other_author_link)", "user"=>{"id"=>9, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0005_fallback_avatar_icon-acde5a972cba71490139455574a35d908e0b3fe25535de9a39e2d98beae4b0aa.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"G*4b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*6b", "end_sfen"=>nil}]}, {"id"=>10, "init_sfen"=>"position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l10p 1", "time_limit_sec"=>180, "difficulty_level"=>5, "title"=>"(title)", "description"=>"(description)", "hint_desc"=>"(hint_desc)", "other_author"=>"(other_author)", "other_author_link"=>"(other_author_link)", "user"=>{"id"=>9, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0005_fallback_avatar_icon-acde5a972cba71490139455574a35d908e0b3fe25535de9a39e2d98beae4b0aa.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"G*4b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*6b", "end_sfen"=>nil}]}]

# すべての問題に解答する
Actb::Question.all.each.with_index do |question, i|
  ox_mark_key = Actb::OxMarkInfo[i.modulo(Actb::OxMarkInfo.count)].key
  user1.actb_histories.create!(membership: membership, question: question, ox_mark: Actb::OxMark.fetch(ox_mark_key))
end

# 終局
battle.katimashita(user1, :win, :f_success)

# 切断したことにする
user1.actb_current_xrecord.update!(final: Actb::Final.fetch(:f_disconnect))
tp user1.actb_current_xrecord
tp user1.actb_master_xrecord

# Good, Bad, Clip
user1.actb_good_marks.create!(question: Actb::Question.first!)
user1.actb_bad_marks.create!(question: Actb::Question.second!)
user1.actb_clip_marks.create!(question: Actb::Question.third!)

# 問題に対してコメント
5.times do
  question = Actb::Question.first!
  question.messages.create!(user: user1, body: "message") # => #<Actb::QuestionMessage id: 1, user_id: 9, question_id: 1, body: "message", created_at: "2020-06-06 12:53:17", updated_at: "2020-06-06 12:53:17">, #<Actb::QuestionMessage id: 2, user_id: 9, question_id: 1, body: "message", created_at: "2020-06-06 12:53:17", updated_at: "2020-06-06 12:53:17">, #<Actb::QuestionMessage id: 3, user_id: 9, question_id: 1, body: "message", created_at: "2020-06-06 12:53:17", updated_at: "2020-06-06 12:53:17">, #<Actb::QuestionMessage id: 4, user_id: 9, question_id: 1, body: "message", created_at: "2020-06-06 12:53:17", updated_at: "2020-06-06 12:53:17">, #<Actb::QuestionMessage id: 5, user_id: 9, question_id: 1, body: "message", created_at: "2020-06-06 12:53:17", updated_at: "2020-06-06 12:53:17">
  question.messages_count                    # => 1, 2, 3, 4, 5
end

tp Actb::Question

tp Actb.info
# >> |------------------+---------------------------|
# >> |               id | 9                         |
# >> |          user_id | 9                         |
# >> |        season_id | 12                        |
# >> |         judge_id | 5                         |
# >> |         final_id | 2                         |
# >> |     battle_count | 1                         |
# >> |        win_count | 1                         |
# >> |       lose_count | 0                         |
# >> |         win_rate | 1.0                       |
# >> |           rating | 1516                      |
# >> | rating_last_diff | 16                        |
# >> |       rating_max | 1516                      |
# >> |     rensho_count | 1                         |
# >> |     renpai_count | 0                         |
# >> |       rensho_max | 1                         |
# >> |       renpai_max | 0                         |
# >> |     create_count | 1                         |
# >> |       generation | 11                        |
# >> |       created_at | 2020-06-06 21:53:14 +0900 |
# >> |       updated_at | 2020-06-06 21:53:17 +0900 |
# >> | disconnect_count | 0                         |
# >> |  disconnected_at |                           |
# >> |------------------+---------------------------|
# >> |------------------+---------------------------|
# >> |               id | 9                         |
# >> |          user_id | 9                         |
# >> |         judge_id | 8                         |
# >> |         final_id | 5                         |
# >> |     battle_count | 0                         |
# >> |        win_count | 0                         |
# >> |       lose_count | 0                         |
# >> |         win_rate | 0.0                       |
# >> |           rating | 1500                      |
# >> | rating_last_diff | 0                         |
# >> |       rating_max | 1500                      |
# >> |     rensho_count | 0                         |
# >> |     renpai_count | 0                         |
# >> |       rensho_max | 0                         |
# >> |       renpai_max | 0                         |
# >> |       created_at | 2020-06-06 21:53:14 +0900 |
# >> |       updated_at | 2020-06-06 21:53:14 +0900 |
# >> | disconnect_count | 0                         |
# >> |  disconnected_at |                           |
# >> |------------------+---------------------------|
# >> |----+---------+-----------+------------+--------------------------------------------+----------------+------------------+---------+---------------+-------------+----------------+---------------------+---------------------------+---------------------------+---------------------+----------------------+---------+---------+-----------+------------+-----------------+-----------------+------------------+-----------------+------------------+----------------|
# >> | id | user_id | folder_id | lineage_id | init_sfen                                  | time_limit_sec | difficulty_level | title   | description   | hint_desc   | other_author   | other_author_link   | created_at                | updated_at                | moves_answers_count | endpos_answers_count | o_count | x_count | bad_count | good_count | histories_count | favorites_count | good_marks_count | bad_marks_count | clip_marks_count | messages_count |
# >> |----+---------+-----------+------------+--------------------------------------------+----------------+------------------+---------+---------------+-------------+----------------+---------------------+---------------------------+---------------------------+---------------------+----------------------+---------+---------+-----------+------------+-----------------+-----------------+------------------+-----------------+------------------+----------------|
# >> |  1 |       9 |        27 |          8 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l1p 1  |            180 |                5 | (title) | (description) | (hint_desc) | (other_author) | (other_author_link) | 2020-06-06 21:53:16 +0900 | 2020-06-06 21:53:16 +0900 |                   3 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |                1 |               0 |                0 |              5 |
# >> |  2 |       9 |        26 |          8 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l2p 1  |            180 |                5 | (title) | (description) | (hint_desc) | (other_author) | (other_author_link) | 2020-06-06 21:53:16 +0900 | 2020-06-06 21:53:16 +0900 |                   3 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |                0 |               1 |                0 |              0 |
# >> |  3 |       9 |        25 |          8 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l3p 1  |            180 |                5 | (title) | (description) | (hint_desc) | (other_author) | (other_author_link) | 2020-06-06 21:53:16 +0900 | 2020-06-05 23:53:16 +0900 |                   3 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |                0 |               0 |                1 |              0 |
# >> |  4 |       9 |        25 |          8 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l4p 1  |            180 |                5 | (title) | (description) | (hint_desc) | (other_author) | (other_author_link) | 2020-06-06 21:53:16 +0900 | 2020-06-06 00:53:16 +0900 |                   3 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |                0 |               0 |                0 |              0 |
# >> |  5 |       9 |        25 |          8 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l5p 1  |            180 |                5 | (title) | (description) | (hint_desc) | (other_author) | (other_author_link) | 2020-06-06 21:53:16 +0900 | 2020-06-06 01:53:16 +0900 |                   3 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |                0 |               0 |                0 |              0 |
# >> |  6 |       9 |        25 |          8 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l6p 1  |            180 |                5 | (title) | (description) | (hint_desc) | (other_author) | (other_author_link) | 2020-06-06 21:53:16 +0900 | 2020-06-06 02:53:16 +0900 |                   3 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |                0 |               0 |                0 |              0 |
# >> |  7 |       9 |        25 |          8 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l7p 1  |            180 |                5 | (title) | (description) | (hint_desc) | (other_author) | (other_author_link) | 2020-06-06 21:53:16 +0900 | 2020-06-06 03:53:16 +0900 |                   3 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |                0 |               0 |                0 |              0 |
# >> |  8 |       9 |        25 |          8 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l8p 1  |            180 |                5 | (title) | (description) | (hint_desc) | (other_author) | (other_author_link) | 2020-06-06 21:53:16 +0900 | 2020-06-06 04:53:16 +0900 |                   3 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |                0 |               0 |                0 |              0 |
# >> |  9 |       9 |        25 |          8 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l9p 1  |            180 |                5 | (title) | (description) | (hint_desc) | (other_author) | (other_author_link) | 2020-06-06 21:53:16 +0900 | 2020-06-06 05:53:16 +0900 |                   3 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |                0 |               0 |                0 |              0 |
# >> | 10 |       9 |        25 |          8 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l10p 1 |            180 |                5 | (title) | (description) | (hint_desc) | (other_author) | (other_author_link) | 2020-06-06 21:53:16 +0900 | 2020-06-06 06:53:16 +0900 |                   3 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |                0 |               0 |                0 |              0 |
# >> |----+---------+-----------+------------+--------------------------------------------+----------------+------------------+---------+---------------+-------------+----------------+---------------------+---------------------------+---------------------------+---------------------+----------------------+---------+---------+-----------+------------+-----------------+-----------------+------------------+-----------------+------------------+----------------|
# >> |------------------------+-------+--------|
# >> | model                  | count | 最終ID |
# >> |------------------------+-------+--------|
# >> | User                   |     9 |     17 |
# >> | Actb::Question         |    10 |     10 |
# >> | Actb::QuestionMessage  |     5 |      5 |
# >> | Actb::Room             |     1 |      1 |
# >> | Actb::RoomMembership   |     2 |      2 |
# >> | Actb::RoomMessage      |     0 |        |
# >> | Actb::Battle           |     2 |      2 |
# >> | Actb::BattleMembership |     4 |      4 |
# >> | Actb::Season           |    11 |     12 |
# >> | Actb::SeasonXrecord    |     9 |     17 |
# >> | Actb::Setting          |     9 |     17 |
# >> | Actb::GoodMark         |     1 |      1 |
# >> | Actb::BadMark          |     1 |      1 |
# >> | Actb::ClipMark         |     1 |      1 |
# >> | Actb::Folder           |    27 |     51 |
# >> | Actb::Lineage          |     7 |     14 |
# >> | Actb::Judge            |     4 |      8 |
# >> | Actb::LobbyMessage     |     0 |        |
# >> |------------------------+-------+--------|
