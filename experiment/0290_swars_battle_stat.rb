#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

Swars::Battle.destroy_all
Swars::Battle.user_import(user_key: "Yamada_Taro")

tp Swars::Battle

tp Swars::Battle.first

battle = Swars::Battle.last
tp battle.memberships.last.attack_tag_list

user = Swars::User.find_by(user_key: "Yamada_Taro")

tp user.memberships.first

tp user.basic_summary
tp user.stat2
tp user.stat3
# >> |-----+-----------------------------------------+---------------------------+----------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------+-------------+----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------+-------------------+---------------------------+---------------------------+------------+------------------+-----------------+----------------+-----------------|
# >> | id  | key                                     | battled_at                | rule_key | csa_seq                                                                                                                                                                                                                                                             | final_key | win_user_id | turn_max | meta_info                                                                                                                                                                                                                                                                                                  | last_accessd_at           | access_logs_count | created_at                | updated_at                | preset_key | defense_tag_list | attack_tag_list | other_tag_list | secret_tag_list |
# >> |-----+-----------------------------------------+---------------------------+----------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------+-------------+----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------+-------------------+---------------------------+---------------------------+------------+------------------+-----------------+----------------+-----------------|
# >> | 137 | devuser1-Yamada_Taro-20190111_230933 | 2019-01-11 23:09:33 +0900 | ten_min  | [["-7162GI", 599], ["+2726FU", 597], ["-4132KI", 598], ["+6978KI", 590], ["-5354FU", 596], ["+3948GI", 588], ["-6253GI", 595], ["+9796FU", 582], ["-9394FU", 594], ["+7776FU", 568], ["-4344FU", 592], ["+7968GI", 563], ["-5162OU", 589], ["+6877GI", 552], ["-... | TORYO     |           2 |       67 | {:header=>{"先手"=>"devuser1 2級", "後手"=>"Yamada_Taro 十段", "開始日時"=>"2019/01/11 23:09:33", "棋戦"=>"将棋ウォーズ(10分切れ負け 指導対局 二枚落ち)", "持ち時間"=>"00:10+00"}, :detail_names=>[[], []], :simple_names=>[[["devuser1", "2級"]], [["Yamada_Taro", "十段"]]], :skill_set_hash=>{... | 2019-01-15 18:15:13 +0900 |                 0 | 2019-01-15 18:15:13 +0900 | 2019-01-15 18:15:13 +0900 | 二枚落ち   |                  |                 |                |                 |
# >> | 138 | Takechan831-Yamada_Taro-20190111_223848   | 2019-01-11 22:38:48 +0900 | ten_min  | [["-7162GI", 599], ["+2726FU", 597], ["-4132KI", 598], ["+6978KI", 590], ["-5354FU", 596], ["+3948GI", 588], ["-6253GI", 595], ["+9796FU", 582], ["-9394FU", 594], ["+7776FU", 568], ["-4344FU", 592], ["+7968GI", 563], ["-5162OU", 589], ["+6877GI", 552], ["-... | TORYO     |           2 |       67 | {:header=>{"先手"=>"Takechan831 2級", "後手"=>"Yamada_Taro 十段", "開始日時"=>"2019/01/11 22:38:48", "棋戦"=>"将棋ウォーズ(10分切れ負け 指導対局 二枚落ち)", "持ち時間"=>"00:10+00"}, :detail_names=>[[], []], :simple_names=>[[["Takechan", "8312級"]], [["Yamada_Taro", "十段"]]], :skill_set_hash=>{}}      | 2019-01-15 18:15:14 +0900 |                 0 | 2019-01-15 18:15:14 +0900 | 2019-01-15 18:15:14 +0900 | 二枚落ち   |                  |                 |                |                 |
# >> | 139 | kibou36-Yamada_Taro-20190111_222649       | 2019-01-11 22:26:49 +0900 | ten_min  | [["-7162GI", 599], ["+2726FU", 597], ["-4132KI", 598], ["+6978KI", 590], ["-5354FU", 596], ["+3948GI", 588], ["-6253GI", 595], ["+9796FU", 582], ["-9394FU", 594], ["+7776FU", 568], ["-4344FU", 592], ["+7968GI", 563], ["-5162OU", 589], ["+6877GI", 552], ["-... | TORYO     |           2 |       67 | {:header=>{"先手"=>"kibou36 2級", "後手"=>"Yamada_Taro 十段", "開始日時"=>"2019/01/11 22:26:49", "棋戦"=>"将棋ウォーズ(10分切れ負け 指導対局 二枚落ち)", "持ち時間"=>"00:10+00"}, :detail_names=>[[], []], :simple_names=>[[["kibou", "362級"]], [["Yamada_Taro", "十段"]]], :skill_set_hash=>{}}              | 2019-01-15 18:15:14 +0900 |                 0 | 2019-01-15 18:15:14 +0900 | 2019-01-15 18:15:14 +0900 | 二枚落ち   |                  |                 |                |                 |
# >> | 140 | Yamada_Taro-kz0619-20190111_190218        | 2019-01-11 19:02:18 +0900 | ten_min  | [["-7162GI", 599], ["+2726FU", 597], ["-4132KI", 598], ["+6978KI", 590], ["-5354FU", 596], ["+3948GI", 588], ["-6253GI", 595], ["+9796FU", 582], ["-9394FU", 594], ["+7776FU", 568], ["-4344FU", 592], ["+7968GI", 563], ["-5162OU", 589], ["+6877GI", 552], ["-... | TORYO     |           5 |       67 | {:header=>{"先手"=>"Yamada_Taro 2級", "後手"=>"kz0619 十段", "開始日時"=>"2019/01/11 19:02:18", "棋戦"=>"将棋ウォーズ(10分切れ負け 指導対局 二枚落ち)", "持ち時間"=>"00:10+00"}, :detail_names=>[[], []], :simple_names=>[[["Yamada_Taro", "2級"]], [["kz0619", "十段"]]], :skill_set_hash=>{}}                | 2019-01-15 18:15:14 +0900 |                 0 | 2019-01-15 18:15:14 +0900 | 2019-01-15 18:15:14 +0900 | 二枚落ち   |                  |                 |                |                 |
# >> | 141 | SOAREMAN-Yamada_Taro-20190111_181540      | 2019-01-11 18:15:40 +0900 | ten_min  | [["-7162GI", 599], ["+2726FU", 597], ["-4132KI", 598], ["+6978KI", 590], ["-5354FU", 596], ["+3948GI", 588], ["-6253GI", 595], ["+9796FU", 582], ["-9394FU", 594], ["+7776FU", 568], ["-4344FU", 592], ["+7968GI", 563], ["-5162OU", 589], ["+6877GI", 552], ["-... | TORYO     |           2 |       67 | {:header=>{"先手"=>"SOAREMAN 2級", "後手"=>"Yamada_Taro 十段", "開始日時"=>"2019/01/11 18:15:40", "棋戦"=>"将棋ウォーズ(10分切れ負け 指導対局 二枚落ち)", "持ち時間"=>"00:10+00"}, :detail_names=>[[], []], :simple_names=>[[["SOAREMAN", "2級"]], [["Yamada_Taro", "十段"]]], :skill_set_hash=>{}}            | 2019-01-15 18:15:15 +0900 |                 0 | 2019-01-15 18:15:15 +0900 | 2019-01-15 18:15:15 +0900 | 二枚落ち   |                  |                 |                |                 |
# >> | 142 | yuga_jus-Yamada_Taro-20190111_171547      | 2019-01-11 17:15:47 +0900 | ten_min  | [["-7162GI", 599], ["+2726FU", 597], ["-4132KI", 598], ["+6978KI", 590], ["-5354FU", 596], ["+3948GI", 588], ["-6253GI", 595], ["+9796FU", 582], ["-9394FU", 594], ["+7776FU", 568], ["-4344FU", 592], ["+7968GI", 563], ["-5162OU", 589], ["+6877GI", 552], ["-... | TORYO     |           2 |       67 | {:header=>{"先手"=>"yuga_jus 2級", "後手"=>"Yamada_Taro 十段", "開始日時"=>"2019/01/11 17:15:47", "棋戦"=>"将棋ウォーズ(10分切れ負け 指導対局 二枚落ち)", "持ち時間"=>"00:10+00"}, :detail_names=>[[], []], :simple_names=>[[["yuga_jus", "2級"]], [["Yamada_Taro", "十段"]]], :skill_set_hash=>{}}            | 2019-01-15 18:15:15 +0900 |                 0 | 2019-01-15 18:15:15 +0900 | 2019-01-15 18:15:15 +0900 | 二枚落ち   |                  |                 |                |                 |
# >> | 143 | kekkun-Yamada_Taro-20190111_162548        | 2019-01-11 16:25:48 +0900 | ten_min  | [["-7162GI", 599], ["+2726FU", 597], ["-4132KI", 598], ["+6978KI", 590], ["-5354FU", 596], ["+3948GI", 588], ["-6253GI", 595], ["+9796FU", 582], ["-9394FU", 594], ["+7776FU", 568], ["-4344FU", 592], ["+7968GI", 563], ["-5162OU", 589], ["+6877GI", 552], ["-... | TORYO     |           2 |       67 | {:header=>{"先手"=>"kekkun 2級", "後手"=>"Yamada_Taro 十段", "開始日時"=>"2019/01/11 16:25:48", "棋戦"=>"将棋ウォーズ(10分切れ負け 指導対局 二枚落ち)", "持ち時間"=>"00:10+00"}, :detail_names=>[[], []], :simple_names=>[[["kekkun", "2級"]], [["Yamada_Taro", "十段"]]], :skill_set_hash=>{}}                | 2019-01-15 18:15:15 +0900 |                 0 | 2019-01-15 18:15:15 +0900 | 2019-01-15 18:15:15 +0900 | 二枚落ち   |                  |                 |                |                 |
# >> | 144 | Yamada_Taro-akkunn_xx-20190111_130425     | 2019-01-11 13:04:25 +0900 | ten_min  | [["-7162GI", 599], ["+2726FU", 597], ["-4132KI", 598], ["+6978KI", 590], ["-5354FU", 596], ["+3948GI", 588], ["-6253GI", 595], ["+9796FU", 582], ["-9394FU", 594], ["+7776FU", 568], ["-4344FU", 592], ["+7968GI", 563], ["-5162OU", 589], ["+6877GI", 552], ["-... | TORYO     |           9 |       67 | {:header=>{"先手"=>"Yamada_Taro 2級", "後手"=>"akkunn_xx 十段", "開始日時"=>"2019/01/11 13:04:25", "棋戦"=>"将棋ウォーズ(10分切れ負け 指導対局 二枚落ち)", "持ち時間"=>"00:10+00"}, :detail_names=>[[], []], :simple_names=>[[["Yamada_Taro", "2級"]], [["akkunn_xx", "十段"]]], :skill_set_hash=>{}}          | 2019-01-15 18:15:15 +0900 |                 0 | 2019-01-15 18:15:15 +0900 | 2019-01-15 18:15:15 +0900 | 二枚落ち   |                  |                 |                |                 |
# >> | 145 | takayanyanta-Yamada_Taro-20190111_124228  | 2019-01-11 12:42:28 +0900 | ten_min  | [["-7162GI", 599], ["+2726FU", 597], ["-4132KI", 598], ["+6978KI", 590], ["-5354FU", 596], ["+3948GI", 588], ["-6253GI", 595], ["+9796FU", 582], ["-9394FU", 594], ["+7776FU", 568], ["-4344FU", 592], ["+7968GI", 563], ["-5162OU", 589], ["+6877GI", 552], ["-... | TORYO     |           2 |       67 | {:header=>{"先手"=>"takayanyanta 2級", "後手"=>"Yamada_Taro 十段", "開始日時"=>"2019/01/11 12:42:28", "棋戦"=>"将棋ウォーズ(10分切れ負け 指導対局 二枚落ち)", "持ち時間"=>"00:10+00"}, :detail_names=>[[], []], :simple_names=>[[["takayanyanta", "2級"]], [["Yamada_Taro", "十段"]]], :skill_set_hash=>{}}    | 2019-01-15 18:15:16 +0900 |                 0 | 2019-01-15 18:15:16 +0900 | 2019-01-15 18:15:16 +0900 | 二枚落ち   |                  |                 |                |                 |
# >> | 146 | MinoriChihara-Yamada_Taro-20190111_084942 | 2019-01-11 08:49:42 +0900 | ten_min  | [["-7162GI", 599], ["+2726FU", 597], ["-4132KI", 598], ["+6978KI", 590], ["-5354FU", 596], ["+3948GI", 588], ["-6253GI", 595], ["+9796FU", 582], ["-9394FU", 594], ["+7776FU", 568], ["-4344FU", 592], ["+7968GI", 563], ["-5162OU", 589], ["+6877GI", 552], ["-... | TORYO     |           2 |       67 | {:header=>{"先手"=>"MinoriChihara 2級", "後手"=>"Yamada_Taro 十段", "開始日時"=>"2019/01/11 08:49:42", "棋戦"=>"将棋ウォーズ(10分切れ負け 指導対局 二枚落ち)", "持ち時間"=>"00:10+00"}, :detail_names=>[[], []], :simple_names=>[[["MinoriChihara", "2級"]], [["Yamada_Taro", "十段"]]], :skill_set_hash=>{... | 2019-01-15 18:15:16 +0900 |                 0 | 2019-01-15 18:15:16 +0900 | 2019-01-15 18:15:16 +0900 | 二枚落ち   |                  |                 |                |                 |
# >> |-----+-----------------------------------------+---------------------------+----------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------+-------------+----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------+-------------------+---------------------------+---------------------------+------------+------------------+-----------------+----------------+-----------------|
# >> |-------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |                id | 137                                                                                                                                                                                                                                                                                                        |
# >> |               key | devuser1-Yamada_Taro-20190111_230933                                                                                                                                                                                                                                                                    |
# >> |        battled_at | 2019-01-11 23:09:33 +0900                                                                                                                                                                                                                                                                                  |
# >> |          rule_key | ten_min                                                                                                                                                                                                                                                                                                    |
# >> |           csa_seq | [["-7162GI", 599], ["+2726FU", 597], ["-4132KI", 598], ["+6978KI", 590], ["-5354FU", 596], ["+3948GI", 588], ["-6253GI", 595], ["+9796FU", 582], ["-9394FU", 594], ["+7776FU", 568], ["-4344FU", 592], ["+7968GI", 563], ["-5162OU", 589], ["+6877GI", 552], ["-...                                        |
# >> |         final_key | TORYO                                                                                                                                                                                                                                                                                                      |
# >> |       win_user_id | 2                                                                                                                                                                                                                                                                                                          |
# >> |          turn_max | 67                                                                                                                                                                                                                                                                                                         |
# >> |         meta_info | {:header=>{"先手"=>"devuser1 2級", "後手"=>"Yamada_Taro 十段", "開始日時"=>"2019/01/11 23:09:33", "棋戦"=>"将棋ウォーズ(10分切れ負け 指導対局 二枚落ち)", "持ち時間"=>"00:10+00"}, :detail_names=>[[], []], :simple_names=>[[["devuser1", "2級"]], [["Yamada_Taro", "十段"]]], :skill_set_hash=>{... |
# >> |   last_accessd_at | 2019-01-15 18:15:13 +0900                                                                                                                                                                                                                                                                                  |
# >> | access_logs_count | 0                                                                                                                                                                                                                                                                                                          |
# >> |        created_at | 2019-01-15 18:15:13 +0900                                                                                                                                                                                                                                                                                  |
# >> |        updated_at | 2019-01-15 18:15:13 +0900                                                                                                                                                                                                                                                                                  |
# >> |        preset_key | 二枚落ち                                                                                                                                                                                                                                                                                                   |
# >> |  defense_tag_list |                                                                                                                                                                                                                                                                                                            |
# >> |   attack_tag_list |                                                                                                                                                                                                                                                                                                            |
# >> |    other_tag_list |                                                                                                                                                                                                                                                                                                            |
# >> |   secret_tag_list |                                                                                                                                                                                                                                                                                                            |
# >> |-------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |------------------+---------------------------|
# >> |               id | 274                       |
# >> |        battle_id | 137                       |
# >> |          user_id | 2                         |
# >> |         grade_id | 1                         |
# >> |        judge_key | win                       |
# >> |     location_key | white                     |
# >> |         position | 1                         |
# >> |       created_at | 2019-01-15 18:15:14 +0900 |
# >> |       updated_at | 2019-01-15 18:15:14 +0900 |
# >> | defense_tag_list |                           |
# >> |  attack_tag_list |                           |
# >> |------------------+---------------------------|
# >> |----------------------+---------|
# >> | 集計した直近の対局数 | 10      |
# >> |                 勝ち | 8       |
# >> |                 負け | 2       |
# >> |           投了された | 8       |
# >> |             投了した | 2       |
# >> |               投了率 | 100.0 % |
# >> |               切断率 | 0.0 %   |
# >> |----------------------+---------|
