#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

Swars::Battle.user_import(user_key: "devuser1")
Swars::Battle.count             # => 10

Swars::User.find_each do |e|
  e.search_logs.create!
end

puts Swars::Crawler::RegularCrawler.new.run.rows.to_t
puts Swars::Crawler::ExpertCrawler.new.run.rows.to_t
# >> |--------|
# >> | 0 < 10 |
# >> |--------|
# >> |--------|
# >> | 0 < 10 |
# >> |--------|
# >> |--------|
# >> | 0 < 10 |
# >> |--------|
# >> |------------------------------------------------------------------|
# >> | https://shogiwars.heroz.jp/games/history?user_id=devuser1&gtype= |
# >> |------------------------------------------------------------------|
# >> |------------------------------|
# >> | 0ページの新しいレコード数: 0 |
# >> |------------------------------|
# >> |--------------------------------------------------------------------|
# >> | https://shogiwars.heroz.jp/games/history?user_id=devuser1&gtype=sb |
# >> |--------------------------------------------------------------------|
# >> |------------------------------|
# >> | 0ページの新しいレコード数: 0 |
# >> |------------------------------|
# >> |--------------------------------------------------------------------|
# >> | https://shogiwars.heroz.jp/games/history?user_id=devuser1&gtype=s1 |
# >> |--------------------------------------------------------------------|
# >> |------------------------------|
# >> | 0ページの新しいレコード数: 0 |
# >> |------------------------------|
# >> |---------------------+----+------------+------+----+----+------+----------+----------+----------------------------+--------|
# >> | 日時                | ID | ユーザー名 | 段級 | 前 | 後 | 差分 | 検索回数 | 最終検索 | 最終対局                   | エラー |
# >> |---------------------+----+------------+------+----+----+------+----------+----------+----------------------------+--------|
# >> | 2019-04-22 11:10:35 |  1 | devuser1   | 2級  |  1 |  1 |    0 |        8 | 11:10    | 2019-01-11 23:09 (3ヶ月前) |        |
# >> |---------------------+----+------------+------+----+----+------+----------+----------+----------------------------+--------|
# >> |-------------------+------|
# >> |          real_run | true |
# >> | developper_notice | true |
# >> |             sleep | 0    |
# >> |             limit | 1    |
# >> |          page_max | 3    |
# >> |       early_break | true |
# >> |-------------------+------|
# >> |---------------------+----+------------+------+----+----+------+----------+----------+----------------------------+--------|
# >> | 日時                | ID | ユーザー名 | 段級 | 前 | 後 | 差分 | 検索回数 | 最終検索 | 最終対局                   | エラー |
# >> |---------------------+----+------------+------+----+----+------+----------+----------+----------------------------+--------|
# >> | 2019-04-22 11:10:35 |  1 | devuser1   | 2級  |  1 |  1 |    0 |        8 | 11:10    | 2019-01-11 23:09 (3ヶ月前) |        |
# >> |---------------------+----+------------+------+----+----+------+----------+----------+----------------------------+--------|
# >> |---------------------+----+------------+------+----+----+------+----------+----------+----------------------------+--------|
# >> | 日時                | ID | ユーザー名 | 段級 | 前 | 後 | 差分 | 検索回数 | 最終検索 | 最終対局                   | エラー |
# >> |---------------------+----+------------+------+----+----+------+----------+----------+----------------------------+--------|
# >> | 2019-04-22 11:10:35 |  1 | devuser1   | 2級  |  1 |  1 |    0 |        8 | 11:10    | 2019-01-11 23:09 (3ヶ月前) |        |
# >> |---------------------+----+------------+------+----+----+------+----------+----------+----------------------------+--------|
# >> |------------------------------------------------------------------|
# >> | https://shogiwars.heroz.jp/games/history?user_id=devuser1&gtype= |
# >> |------------------------------------------------------------------|
# >> |------------------------------|
# >> | 0ページの新しいレコード数: 0 |
# >> |------------------------------|
# >> |--------------------------------------------------------------------|
# >> | https://shogiwars.heroz.jp/games/history?user_id=devuser1&gtype=sb |
# >> |--------------------------------------------------------------------|
# >> |------------------------------|
# >> | 0ページの新しいレコード数: 0 |
# >> |------------------------------|
# >> |--------------------------------------------------------------------|
# >> | https://shogiwars.heroz.jp/games/history?user_id=devuser1&gtype=s1 |
# >> |--------------------------------------------------------------------|
# >> |------------------------------|
# >> | 0ページの新しいレコード数: 0 |
# >> |------------------------------|
# >> |---------------------+----+------------+------+----+----+------+----------+----------+----------------------------+--------|
# >> | 日時                | ID | ユーザー名 | 段級 | 前 | 後 | 差分 | 検索回数 | 最終検索 | 最終対局                   | エラー |
# >> |---------------------+----+------------+------+----+----+------+----------+----------+----------------------------+--------|
# >> | 2019-04-22 11:10:39 |  1 | devuser1   | 2級  |  1 |  1 |    0 |        8 | 11:10    | 2019-01-11 23:09 (3ヶ月前) |        |
# >> |---------------------+----+------------+------+----+----+------+----------+----------+----------------------------+--------|
# >> |-------------------+--------------|
# >> |          real_run | true         |
# >> | developper_notice | true         |
# >> |             sleep | 0            |
# >> |         user_keys | ["devuser1"] |
# >> |          page_max | 3            |
# >> |       early_break | true         |
# >> |-------------------+--------------|
# >> |---------------------+----+------------+------+----+----+------+----------+----------+----------------------------+--------|
# >> | 日時                | ID | ユーザー名 | 段級 | 前 | 後 | 差分 | 検索回数 | 最終検索 | 最終対局                   | エラー |
# >> |---------------------+----+------------+------+----+----+------+----------+----------+----------------------------+--------|
# >> | 2019-04-22 11:10:39 |  1 | devuser1   | 2級  |  1 |  1 |    0 |        8 | 11:10    | 2019-01-11 23:09 (3ヶ月前) |        |
# >> |---------------------+----+------------+------+----+----+------+----------+----------+----------------------------+--------|
# >> |---------------------+----+------------+------+----+----+------+----------+----------+----------------------------+--------|
# >> | 日時                | ID | ユーザー名 | 段級 | 前 | 後 | 差分 | 検索回数 | 最終検索 | 最終対局                   | エラー |
# >> |---------------------+----+------------+------+----+----+------+----------+----------+----------------------------+--------|
# >> | 2019-04-22 11:10:39 |  1 | devuser1   | 2級  |  1 |  1 |    0 |        8 | 11:10    | 2019-01-11 23:09 (3ヶ月前) |        |
# >> |---------------------+----+------------+------+----+----+------+----------+----------+----------------------------+--------|
