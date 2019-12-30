#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

Swars::Battle.user_import(user_key: "devuser1")

# Swars::Battle.destroy_all
# Swars::Battle.destroy_all
# 
# Swars::Battle.import(:remake)

tp Swars::Battle.all.last(10).collect(&:attributes)

# tp Swars::Battle
# >> |------------------------------------------------------------------|
# >> | https://shogiwars.heroz.jp/games/history?user_id=devuser1&gtype= |
# >> |------------------------------------------------------------------|
# >> |-------------------------------------------------------------------------------|
# >> | http://kif-pona.heroz.jp/games/devuser1-Yamada_Taro-20190111_230933?locale=ja |
# >> |-------------------------------------------------------------------------------|
# >> |----------------------------------------------------------------------------------|
# >> | http://kif-pona.heroz.jp/games/Takechan831-Yamada_Taro-20190111_223848?locale=ja |
# >> |----------------------------------------------------------------------------------|
# >> |------------------------------------------------------------------------------|
# >> | http://kif-pona.heroz.jp/games/kibou36-Yamada_Taro-20190111_222649?locale=ja |
# >> |------------------------------------------------------------------------------|
# >> |-----------------------------------------------------------------------------|
# >> | http://kif-pona.heroz.jp/games/Yamada_Taro-kz0619-20190111_190218?locale=ja |
# >> |-----------------------------------------------------------------------------|
# >> |-------------------------------------------------------------------------------|
# >> | http://kif-pona.heroz.jp/games/SOAREMAN-Yamada_Taro-20190111_181540?locale=ja |
# >> |-------------------------------------------------------------------------------|
# >> |-------------------------------------------------------------------------------|
# >> | http://kif-pona.heroz.jp/games/yuga_jus-Yamada_Taro-20190111_171547?locale=ja |
# >> |-------------------------------------------------------------------------------|
# >> |-----------------------------------------------------------------------------|
# >> | http://kif-pona.heroz.jp/games/kekkun-Yamada_Taro-20190111_162548?locale=ja |
# >> |-----------------------------------------------------------------------------|
# >> |--------------------------------------------------------------------------------|
# >> | http://kif-pona.heroz.jp/games/Yamada_Taro-akkunn_xx-20190111_130425?locale=ja |
# >> |--------------------------------------------------------------------------------|
# >> |-----------------------------------------------------------------------------------|
# >> | http://kif-pona.heroz.jp/games/takayanyanta-Yamada_Taro-20190111_124228?locale=ja |
# >> |-----------------------------------------------------------------------------------|
# >> |------------------------------------------------------------------------------------|
# >> | http://kif-pona.heroz.jp/games/MinoriChihara-Yamada_Taro-20190111_084942?locale=ja |
# >> |------------------------------------------------------------------------------------|
# >> |--------------------------------------------------------------------|
# >> | https://shogiwars.heroz.jp/games/history?user_id=devuser1&gtype=sb |
# >> |--------------------------------------------------------------------|
# >> |--------------------------------------------------------------------|
# >> | https://shogiwars.heroz.jp/games/history?user_id=devuser1&gtype=s1 |
# >> |--------------------------------------------------------------------|
# >> |----+-------------------------------------------+---------------------------+----------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------+-------------+----------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------+-------------------+---------------------------+---------------------------+------------+------------+---------------+------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------+------------------+-----------------+--------------------+---------------+----------------+-----------------+--------------------|
# >> | id | key                                       | battled_at                | rule_key | csa_seq                                                                                                                                                                                                                                                             | final_key | win_user_id | turn_max | meta_info                                                                                                                                                                                                                                                                                                                      | last_accessd_at           | access_logs_count | created_at                | updated_at                | preset_key | start_turn | critical_turn | saturn_key | sfen_body                                                                                                                                                                                                                                                           | image_turn | defense_tag_list | attack_tag_list | technique_tag_list | note_tag_list | other_tag_list | secret_tag_list | kifu_body_for_test |
# >> |----+-------------------------------------------+---------------------------+----------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------+-------------+----------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------+-------------------+---------------------------+---------------------------+------------+------------+---------------+------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------+------------------+-----------------+--------------------+---------------+----------------+-----------------+--------------------|
# >> | 36 | devuser1-Yamada_Taro-20190111_230933      | 2019-01-11 23:09:33 +0900 | ten_min  | [["-7162GI", 599], ["+2726FU", 597], ["-4132KI", 598], ["+6978KI", 590], ["-5354FU", 596], ["+3948GI", 588], ["-6253GI", 595], ["+9796FU", 582], ["-9394FU", 594], ["+7776FU", 568], ["-4344FU", 592], ["+7968GI", 563], ["-5162OU", 589], ["+6877GI", 552], ["-... | TORYO     |           2 |       67 | {:header=>{"先手"=>"devuser1 2級", "後手"=>"Yamada_Taro 十段", "開始日時"=>"2019/01/11 23:09:33", "棋戦"=>"将棋ウォーズ(10分切れ負け 指導対局 二枚落ち)", "場所"=>"http://kif-pona.heroz.jp/games/devuser1-Yamada_Taro-20190111_230933", "持ち時間"=>"00:10+00", "上手の囲い"=>"銀雲雀", "下手の手筋"=>"垂れ歩", "下手の備...  | 2020-01-06 10:56:46 +0900 |                 0 | 2020-01-06 10:56:46 +0900 | 2020-01-06 10:56:46 +0900 | 二枚落ち   |            |            36 | public     | position sfen lnsgkgsnl/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1 moves 7a6b 2g2f 4a3b 6i7h 5c5d 3i4h 6b5c 9g9f 9c9d 7g7f 4c4d 7i6h 5a6b 6h7g 6a7b 6g6f 7c7d 4i5h 3a4b 5h6g 5d5e 4g4f 4b4c 4h4g 4c5d 3g3f 3c3d 2f2e 3b3c 2i3g 1c1d 1g1f 7b7c 4f4e 3d3e 5... |            |                  |                 |                    |               |                |                 |                    |
# >> | 37 | Takechan831-Yamada_Taro-20190111_223848   | 2019-01-11 22:38:48 +0900 | ten_min  | [["-7162GI", 599], ["+2726FU", 597], ["-4132KI", 598], ["+6978KI", 590], ["-5354FU", 596], ["+3948GI", 588], ["-6253GI", 595], ["+9796FU", 582], ["-9394FU", 594], ["+7776FU", 568], ["-4344FU", 592], ["+7968GI", 563], ["-5162OU", 589], ["+6877GI", 552], ["-... | TORYO     |           2 |       67 | {:header=>{"先手"=>"Takechan831 2級", "後手"=>"Yamada_Taro 十段", "開始日時"=>"2019/01/11 22:38:48", "棋戦"=>"将棋ウォーズ(10分切れ負け 指導対局 二枚落ち)", "場所"=>"http://kif-pona.heroz.jp/games/Takechan831-Yamada_Taro-20190111_223848", "持ち時間"=>"00:10+00", "上手の囲い"=>"銀雲雀", "下手の手筋"=>"垂れ歩",...      | 2020-01-06 10:56:46 +0900 |                 0 | 2020-01-06 10:56:46 +0900 | 2020-01-06 10:56:46 +0900 | 二枚落ち   |            |            36 | public     | position sfen lnsgkgsnl/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1 moves 7a6b 2g2f 4a3b 6i7h 5c5d 3i4h 6b5c 9g9f 9c9d 7g7f 4c4d 7i6h 5a6b 6h7g 6a7b 6g6f 7c7d 4i5h 3a4b 5h6g 5d5e 4g4f 4b4c 4h4g 4c5d 3g3f 3c3d 2f2e 3b3c 2i3g 1c1d 1g1f 7b7c 4f4e 3d3e 5... |            |                  |                 |                    |               |                |                 |                    |
# >> | 38 | kibou36-Yamada_Taro-20190111_222649       | 2019-01-11 22:26:49 +0900 | ten_min  | [["-7162GI", 599], ["+2726FU", 597], ["-4132KI", 598], ["+6978KI", 590], ["-5354FU", 596], ["+3948GI", 588], ["-6253GI", 595], ["+9796FU", 582], ["-9394FU", 594], ["+7776FU", 568], ["-4344FU", 592], ["+7968GI", 563], ["-5162OU", 589], ["+6877GI", 552], ["-... | TORYO     |           2 |       67 | {:header=>{"先手"=>"kibou36 2級", "後手"=>"Yamada_Taro 十段", "開始日時"=>"2019/01/11 22:26:49", "棋戦"=>"将棋ウォーズ(10分切れ負け 指導対局 二枚落ち)", "場所"=>"http://kif-pona.heroz.jp/games/kibou36-Yamada_Taro-20190111_222649", "持ち時間"=>"00:10+00", "上手の囲い"=>"銀雲雀", "下手の手筋"=>"垂れ歩", "下手の備考"... | 2020-01-06 10:56:46 +0900 |                 0 | 2020-01-06 10:56:47 +0900 | 2020-01-06 10:56:47 +0900 | 二枚落ち   |            |            36 | public     | position sfen lnsgkgsnl/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1 moves 7a6b 2g2f 4a3b 6i7h 5c5d 3i4h 6b5c 9g9f 9c9d 7g7f 4c4d 7i6h 5a6b 6h7g 6a7b 6g6f 7c7d 4i5h 3a4b 5h6g 5d5e 4g4f 4b4c 4h4g 4c5d 3g3f 3c3d 2f2e 3b3c 2i3g 1c1d 1g1f 7b7c 4f4e 3d3e 5... |            |                  |                 |                    |               |                |                 |                    |
# >> | 39 | Yamada_Taro-kz0619-20190111_190218        | 2019-01-11 19:02:18 +0900 | ten_min  | [["-7162GI", 599], ["+2726FU", 597], ["-4132KI", 598], ["+6978KI", 590], ["-5354FU", 596], ["+3948GI", 588], ["-6253GI", 595], ["+9796FU", 582], ["-9394FU", 594], ["+7776FU", 568], ["-4344FU", 592], ["+7968GI", 563], ["-5162OU", 589], ["+6877GI", 552], ["-... | TORYO     |           5 |       67 | {:header=>{"先手"=>"Yamada_Taro 2級", "後手"=>"kz0619 十段", "開始日時"=>"2019/01/11 19:02:18", "棋戦"=>"将棋ウォーズ(10分切れ負け 指導対局 二枚落ち)", "場所"=>"http://kif-pona.heroz.jp/games/Yamada_Taro-kz0619-20190111_190218", "持ち時間"=>"00:10+00", "上手の囲い"=>"銀雲雀", "下手の手筋"=>"垂れ歩", "下手の備考"=>... | 2020-01-06 10:56:47 +0900 |                 0 | 2020-01-06 10:56:47 +0900 | 2020-01-06 10:56:47 +0900 | 二枚落ち   |            |            36 | public     | position sfen lnsgkgsnl/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1 moves 7a6b 2g2f 4a3b 6i7h 5c5d 3i4h 6b5c 9g9f 9c9d 7g7f 4c4d 7i6h 5a6b 6h7g 6a7b 6g6f 7c7d 4i5h 3a4b 5h6g 5d5e 4g4f 4b4c 4h4g 4c5d 3g3f 3c3d 2f2e 3b3c 2i3g 1c1d 1g1f 7b7c 4f4e 3d3e 5... |            |                  |                 |                    |               |                |                 |                    |
# >> | 40 | SOAREMAN-Yamada_Taro-20190111_181540      | 2019-01-11 18:15:40 +0900 | ten_min  | [["-7162GI", 599], ["+2726FU", 597], ["-4132KI", 598], ["+6978KI", 590], ["-5354FU", 596], ["+3948GI", 588], ["-6253GI", 595], ["+9796FU", 582], ["-9394FU", 594], ["+7776FU", 568], ["-4344FU", 592], ["+7968GI", 563], ["-5162OU", 589], ["+6877GI", 552], ["-... | TORYO     |           2 |       67 | {:header=>{"先手"=>"SOAREMAN 2級", "後手"=>"Yamada_Taro 十段", "開始日時"=>"2019/01/11 18:15:40", "棋戦"=>"将棋ウォーズ(10分切れ負け 指導対局 二枚落ち)", "場所"=>"http://kif-pona.heroz.jp/games/SOAREMAN-Yamada_Taro-20190111_181540", "持ち時間"=>"00:10+00", "上手の囲い"=>"銀雲雀", "下手の手筋"=>"垂れ歩", "下手の備...  | 2020-01-06 10:56:47 +0900 |                 0 | 2020-01-06 10:56:47 +0900 | 2020-01-06 10:56:47 +0900 | 二枚落ち   |            |            36 | public     | position sfen lnsgkgsnl/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1 moves 7a6b 2g2f 4a3b 6i7h 5c5d 3i4h 6b5c 9g9f 9c9d 7g7f 4c4d 7i6h 5a6b 6h7g 6a7b 6g6f 7c7d 4i5h 3a4b 5h6g 5d5e 4g4f 4b4c 4h4g 4c5d 3g3f 3c3d 2f2e 3b3c 2i3g 1c1d 1g1f 7b7c 4f4e 3d3e 5... |            |                  |                 |                    |               |                |                 |                    |
# >> | 41 | yuga_jus-Yamada_Taro-20190111_171547      | 2019-01-11 17:15:47 +0900 | ten_min  | [["-7162GI", 599], ["+2726FU", 597], ["-4132KI", 598], ["+6978KI", 590], ["-5354FU", 596], ["+3948GI", 588], ["-6253GI", 595], ["+9796FU", 582], ["-9394FU", 594], ["+7776FU", 568], ["-4344FU", 592], ["+7968GI", 563], ["-5162OU", 589], ["+6877GI", 552], ["-... | TORYO     |           2 |       67 | {:header=>{"先手"=>"yuga_jus 2級", "後手"=>"Yamada_Taro 十段", "開始日時"=>"2019/01/11 17:15:47", "棋戦"=>"将棋ウォーズ(10分切れ負け 指導対局 二枚落ち)", "場所"=>"http://kif-pona.heroz.jp/games/yuga_jus-Yamada_Taro-20190111_171547", "持ち時間"=>"00:10+00", "上手の囲い"=>"銀雲雀", "下手の手筋"=>"垂れ歩", "下手の備...  | 2020-01-06 10:56:47 +0900 |                 0 | 2020-01-06 10:56:47 +0900 | 2020-01-06 10:56:47 +0900 | 二枚落ち   |            |            36 | public     | position sfen lnsgkgsnl/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1 moves 7a6b 2g2f 4a3b 6i7h 5c5d 3i4h 6b5c 9g9f 9c9d 7g7f 4c4d 7i6h 5a6b 6h7g 6a7b 6g6f 7c7d 4i5h 3a4b 5h6g 5d5e 4g4f 4b4c 4h4g 4c5d 3g3f 3c3d 2f2e 3b3c 2i3g 1c1d 1g1f 7b7c 4f4e 3d3e 5... |            |                  |                 |                    |               |                |                 |                    |
# >> | 42 | kekkun-Yamada_Taro-20190111_162548        | 2019-01-11 16:25:48 +0900 | ten_min  | [["-7162GI", 599], ["+2726FU", 597], ["-4132KI", 598], ["+6978KI", 590], ["-5354FU", 596], ["+3948GI", 588], ["-6253GI", 595], ["+9796FU", 582], ["-9394FU", 594], ["+7776FU", 568], ["-4344FU", 592], ["+7968GI", 563], ["-5162OU", 589], ["+6877GI", 552], ["-... | TORYO     |           2 |       67 | {:header=>{"先手"=>"kekkun 2級", "後手"=>"Yamada_Taro 十段", "開始日時"=>"2019/01/11 16:25:48", "棋戦"=>"将棋ウォーズ(10分切れ負け 指導対局 二枚落ち)", "場所"=>"http://kif-pona.heroz.jp/games/kekkun-Yamada_Taro-20190111_162548", "持ち時間"=>"00:10+00", "上手の囲い"=>"銀雲雀", "下手の手筋"=>"垂れ歩", "下手の備考"=>... | 2020-01-06 10:56:47 +0900 |                 0 | 2020-01-06 10:56:47 +0900 | 2020-01-06 10:56:47 +0900 | 二枚落ち   |            |            36 | public     | position sfen lnsgkgsnl/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1 moves 7a6b 2g2f 4a3b 6i7h 5c5d 3i4h 6b5c 9g9f 9c9d 7g7f 4c4d 7i6h 5a6b 6h7g 6a7b 6g6f 7c7d 4i5h 3a4b 5h6g 5d5e 4g4f 4b4c 4h4g 4c5d 3g3f 3c3d 2f2e 3b3c 2i3g 1c1d 1g1f 7b7c 4f4e 3d3e 5... |            |                  |                 |                    |               |                |                 |                    |
# >> | 43 | Yamada_Taro-akkunn_xx-20190111_130425     | 2019-01-11 13:04:25 +0900 | ten_min  | [["-7162GI", 599], ["+2726FU", 597], ["-4132KI", 598], ["+6978KI", 590], ["-5354FU", 596], ["+3948GI", 588], ["-6253GI", 595], ["+9796FU", 582], ["-9394FU", 594], ["+7776FU", 568], ["-4344FU", 592], ["+7968GI", 563], ["-5162OU", 589], ["+6877GI", 552], ["-... | TORYO     |           9 |       67 | {:header=>{"先手"=>"Yamada_Taro 2級", "後手"=>"akkunn_xx 十段", "開始日時"=>"2019/01/11 13:04:25", "棋戦"=>"将棋ウォーズ(10分切れ負け 指導対局 二枚落ち)", "場所"=>"http://kif-pona.heroz.jp/games/Yamada_Taro-akkunn_xx-20190111_130425", "持ち時間"=>"00:10+00", "上手の囲い"=>"銀雲雀", "下手の手筋"=>"垂れ歩", "下手...    | 2020-01-06 10:56:48 +0900 |                 0 | 2020-01-06 10:56:48 +0900 | 2020-01-06 10:56:48 +0900 | 二枚落ち   |            |            36 | public     | position sfen lnsgkgsnl/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1 moves 7a6b 2g2f 4a3b 6i7h 5c5d 3i4h 6b5c 9g9f 9c9d 7g7f 4c4d 7i6h 5a6b 6h7g 6a7b 6g6f 7c7d 4i5h 3a4b 5h6g 5d5e 4g4f 4b4c 4h4g 4c5d 3g3f 3c3d 2f2e 3b3c 2i3g 1c1d 1g1f 7b7c 4f4e 3d3e 5... |            |                  |                 |                    |               |                |                 |                    |
# >> | 44 | takayanyanta-Yamada_Taro-20190111_124228  | 2019-01-11 12:42:28 +0900 | ten_min  | [["-7162GI", 599], ["+2726FU", 597], ["-4132KI", 598], ["+6978KI", 590], ["-5354FU", 596], ["+3948GI", 588], ["-6253GI", 595], ["+9796FU", 582], ["-9394FU", 594], ["+7776FU", 568], ["-4344FU", 592], ["+7968GI", 563], ["-5162OU", 589], ["+6877GI", 552], ["-... | TORYO     |           2 |       67 | {:header=>{"先手"=>"takayanyanta 2級", "後手"=>"Yamada_Taro 十段", "開始日時"=>"2019/01/11 12:42:28", "棋戦"=>"将棋ウォーズ(10分切れ負け 指導対局 二枚落ち)", "場所"=>"http://kif-pona.heroz.jp/games/takayanyanta-Yamada_Taro-20190111_124228", "持ち時間"=>"00:10+00", "上手の囲い"=>"銀雲雀", "下手の手筋"=>"垂れ歩...      | 2020-01-06 10:56:48 +0900 |                 0 | 2020-01-06 10:56:48 +0900 | 2020-01-06 10:56:48 +0900 | 二枚落ち   |            |            36 | public     | position sfen lnsgkgsnl/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1 moves 7a6b 2g2f 4a3b 6i7h 5c5d 3i4h 6b5c 9g9f 9c9d 7g7f 4c4d 7i6h 5a6b 6h7g 6a7b 6g6f 7c7d 4i5h 3a4b 5h6g 5d5e 4g4f 4b4c 4h4g 4c5d 3g3f 3c3d 2f2e 3b3c 2i3g 1c1d 1g1f 7b7c 4f4e 3d3e 5... |            |                  |                 |                    |               |                |                 |                    |
# >> | 45 | MinoriChihara-Yamada_Taro-20190111_084942 | 2019-01-11 08:49:42 +0900 | ten_min  | [["-7162GI", 599], ["+2726FU", 597], ["-4132KI", 598], ["+6978KI", 590], ["-5354FU", 596], ["+3948GI", 588], ["-6253GI", 595], ["+9796FU", 582], ["-9394FU", 594], ["+7776FU", 568], ["-4344FU", 592], ["+7968GI", 563], ["-5162OU", 589], ["+6877GI", 552], ["-... | TORYO     |           2 |       67 | {:header=>{"先手"=>"MinoriChihara 2級", "後手"=>"Yamada_Taro 十段", "開始日時"=>"2019/01/11 08:49:42", "棋戦"=>"将棋ウォーズ(10分切れ負け 指導対局 二枚落ち)", "場所"=>"http://kif-pona.heroz.jp/games/MinoriChihara-Yamada_Taro-20190111_084942", "持ち時間"=>"00:10+00", "上手の囲い"=>"銀雲雀", "下手の手筋"=>"垂...        | 2020-01-06 10:56:48 +0900 |                 0 | 2020-01-06 10:56:48 +0900 | 2020-01-06 10:56:48 +0900 | 二枚落ち   |            |            36 | public     | position sfen lnsgkgsnl/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1 moves 7a6b 2g2f 4a3b 6i7h 5c5d 3i4h 6b5c 9g9f 9c9d 7g7f 4c4d 7i6h 5a6b 6h7g 6a7b 6g6f 7c7d 4i5h 3a4b 5h6g 5d5e 4g4f 4b4c 4h4g 4c5d 3g3f 3c3d 2f2e 3b3c 2i3g 1c1d 1g1f 7b7c 4f4e 3d3e 5... |            |                  |                 |                    |               |                |                 |                    |
# >> |----+-------------------------------------------+---------------------------+----------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------+-------------+----------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------+-------------------+---------------------------+---------------------------+------------+------------+---------------+------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------+------------------+-----------------+--------------------+---------------+----------------+-----------------+--------------------|
