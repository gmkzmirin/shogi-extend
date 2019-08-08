#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

# XyRuleInfo.clear_all
#
# XyRecord.destroy_all
# XyRecord.create!(xy_rule_key: "xy_rule1", entry_name: "(name1)", spent_msec: 1.123, x_count: 0)
# XyRecord.create!(xy_rule_key: "xy_rule1", entry_name: "(name1)", spent_msec: 2.123, x_count: 0)
# XyRecord.create!(xy_rule_key: "xy_rule1", entry_name: "(name1)", spent_msec: 3.123, x_count: 0)
#
# tp XyRecord.all.collect { |e| {id: e.id, page: e.ranking_page } }
#
# tp XyRuleInfo.rule_list
#
# tp XyRuleInfo[:xy_rule1].xy_records

tp XyRecord

# >> |----+-------------------+------------+---------------------------------------------------------------------+-------------+---------+------------+---------------------------+---------------------------|
# >> | id | colosseum_user_id | entry_name | summary                                                             | xy_rule_key | x_count | spent_msec | created_at                | updated_at                |
# >> |----+-------------------+------------+---------------------------------------------------------------------+-------------+---------+------------+---------------------------+---------------------------|
# >> | 20 |                   | (name1)    |                                                                     | xy_rule1    |       0 |      1.123 | 2019-08-08 17:57:28 +0900 | 2019-08-08 17:57:28 +0900 |
# >> | 21 |                   | (name1)    |                                                                     | xy_rule1    |       0 |      2.123 | 2019-08-08 17:57:28 +0900 | 2019-08-08 17:57:28 +0900 |
# >> | 22 |                   | (name1)    |                                                                     | xy_rule1    |       0 |      3.123 | 2019-08-08 17:57:28 +0900 | 2019-08-08 17:57:28 +0900 |
# >> | 23 |                   | 運営       | ルール: 1問 タイム: 00:01.784 まちがえた数: 0 正解率: 0%            | xy_rule1    |       0 |    1.78402 | 2019-08-08 17:57:37 +0900 | 2019-08-08 17:57:38 +0900 |
# >> | 24 |                   | 運営       | ルール: 1問 タイム: 00:04.789 まちがえた数: 1 正解率: 50%           | xy_rule1    |       1 |     4.7899 | 2019-08-08 17:59:06 +0900 | 2019-08-08 17:59:10 +0900 |
# >> | 25 |                   | 運営       | ルール: 30問 タイム: 00:01.924 まちがえた数: 0 正解率: 0%           | xy_rule30   |       0 |     1.9241 | 2019-08-08 18:13:10 +0900 | 2019-08-08 18:13:11 +0900 |
# >> | 26 |                   | 運営       | ルール: 30問 順位: 1位 タイム: 00:01.299 まちがえた数: 0 正解率: 0% | xy_rule30   |       0 |     1.2999 | 2019-08-08 18:13:14 +0900 | 2019-08-08 18:13:15 +0900 |
# >> | 27 |                 1 | 運営       | ルール: 1問 タイム: 00:01.282 まちがえた数: 0 正解率: 0%            | xy_rule1    |       0 |    1.28273 | 2019-08-08 18:33:40 +0900 | 2019-08-08 18:33:42 +0900 |
# >> |----+-------------------+------------+---------------------------------------------------------------------+-------------+---------+------------+---------------------------+---------------------------|
