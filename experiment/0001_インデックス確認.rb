#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

ActiveRecord::Base.connection.tables.sort.each do |e|
  puts
  puts e
  tp ActiveRecord::Base.connection.indexes(e).collect(&:to_h)
end
# >> 
# >> ar_internal_metadata
# >> 
# >> battle2_records
# >> |-----------------+--------------------------------------------+--------+-----------------------+---------+--------+-------+------+-------+---------|
# >> | table           | name                                       | unique | columns               | lengths | orders | where | type | using | comment |
# >> |-----------------+--------------------------------------------+--------+-----------------------+---------+--------+-------+------+-------+---------|
# >> | battle2_records | index_battle2_records_on_battle_key        | true   | ["battle_key"]        | {}      |        |       |      | btree |         |
# >> | battle2_records | index_battle2_records_on_battle2_state_key | false  | ["battle2_state_key"] | {}      |        |       |      | btree |         |
# >> |-----------------+--------------------------------------------+--------+-----------------------+---------+--------+-------+------+-------+---------|
# >> 
# >> battle2_ships
# >> |---------------+-----------------------------------------------------------+--------+---------------------------------------+---------+--------+-------+------+-------+---------|
# >> | table         | name                                                      | unique | columns                               | lengths | orders | where | type | using | comment |
# >> |---------------+-----------------------------------------------------------+--------+---------------------------------------+---------+--------+-------+------+-------+---------|
# >> | battle2_ships | index_battle2_ships_on_battle2_record_id_and_location_key | true   | ["battle2_record_id", "location_key"] | {}      |        |       |      | btree |         |
# >> | battle2_ships | index_battle2_ships_on_battle2_record_id                  | false  | ["battle2_record_id"]                 | {}      |        |       |      | btree |         |
# >> | battle2_ships | index_battle2_ships_on_judge_key                          | false  | ["judge_key"]                         | {}      |        |       |      | btree |         |
# >> | battle2_ships | index_battle2_ships_on_location_key                       | false  | ["location_key"]                      | {}      |        |       |      | btree |         |
# >> | battle2_ships | index_battle2_ships_on_position                           | false  | ["position"]                          | {}      |        |       |      | btree |         |
# >> |---------------+-----------------------------------------------------------+--------+---------------------------------------+---------+--------+-------+------+-------+---------|
# >> 
# >> battle2_users
# >> |---------------+-----------------------------+--------+----------+---------+--------+-------+------+-------+---------|
# >> | table         | name                        | unique | columns  | lengths | orders | where | type | using | comment |
# >> |---------------+-----------------------------+--------+----------+---------+--------+-------+------+-------+---------|
# >> | battle2_users | index_battle2_users_on_name | true   | ["name"] | {}      |        |       |      | btree |         |
# >> |---------------+-----------------------------+--------+----------+---------+--------+-------+------+-------+---------|
# >> 
# >> battle_grades
# >> |---------------+-----------------------------------+--------+----------------+---------+--------+-------+------+-------+---------|
# >> | table         | name                              | unique | columns        | lengths | orders | where | type | using | comment |
# >> |---------------+-----------------------------------+--------+----------------+---------+--------+-------+------+-------+---------|
# >> | battle_grades | index_battle_grades_on_unique_key | true   | ["unique_key"] | {}      |        |       |      | btree |         |
# >> | battle_grades | index_battle_grades_on_priority   | false  | ["priority"]   | {}      |        |       |      | btree |         |
# >> |---------------+-----------------------------------+--------+----------------+---------+--------+-------+------+-------+---------|
# >> 
# >> battle_records
# >> |----------------+--------------------------------------------+--------+------------------------+---------+--------+-------+------+-------+---------|
# >> | table          | name                                       | unique | columns                | lengths | orders | where | type | using | comment |
# >> |----------------+--------------------------------------------+--------+------------------------+---------+--------+-------+------+-------+---------|
# >> | battle_records | index_battle_records_on_battle_key         | true   | ["battle_key"]         | {}      |        |       |      | btree |         |
# >> | battle_records | index_battle_records_on_battle_rule_key    | false  | ["battle_rule_key"]    | {}      |        |       |      | btree |         |
# >> | battle_records | index_battle_records_on_battle_state_key   | false  | ["battle_state_key"]   | {}      |        |       |      | btree |         |
# >> | battle_records | index_battle_records_on_win_battle_user_id | false  | ["win_battle_user_id"] | {}      |        |       |      | btree |         |
# >> |----------------+--------------------------------------------+--------+------------------------+---------+--------+-------+------+-------+---------|
# >> 
# >> battle_ships
# >> |--------------+-----------------------------------------------------------+--------+----------------------------------------+---------+--------+-------+------+-------+---------|
# >> | table        | name                                                      | unique | columns                                | lengths | orders | where | type | using | comment |
# >> |--------------+-----------------------------------------------------------+--------+----------------------------------------+---------+--------+-------+------+-------+---------|
# >> | battle_ships | index_battle_ships_on_battle_record_id_and_location_key   | true   | ["battle_record_id", "location_key"]   | {}      |        |       |      | btree |         |
# >> | battle_ships | index_battle_ships_on_battle_record_id_and_battle_user_id | true   | ["battle_record_id", "battle_user_id"] | {}      |        |       |      | btree |         |
# >> | battle_ships | index_battle_ships_on_battle_record_id                    | false  | ["battle_record_id"]                   | {}      |        |       |      | btree |         |
# >> | battle_ships | index_battle_ships_on_battle_user_id                      | false  | ["battle_user_id"]                     | {}      |        |       |      | btree |         |
# >> | battle_ships | index_battle_ships_on_battle_grade_id                     | false  | ["battle_grade_id"]                    | {}      |        |       |      | btree |         |
# >> | battle_ships | index_battle_ships_on_judge_key                           | false  | ["judge_key"]                          | {}      |        |       |      | btree |         |
# >> | battle_ships | index_battle_ships_on_location_key                        | false  | ["location_key"]                       | {}      |        |       |      | btree |         |
# >> | battle_ships | index_battle_ships_on_position                            | false  | ["position"]                           | {}      |        |       |      | btree |         |
# >> |--------------+-----------------------------------------------------------+--------+----------------------------------------+---------+--------+-------+------+-------+---------|
# >> 
# >> battle_user_receptions
# >> |------------------------+------------------------------------------------+--------+--------------------+---------+--------+-------+------+-------+---------|
# >> | table                  | name                                           | unique | columns            | lengths | orders | where | type | using | comment |
# >> |------------------------+------------------------------------------------+--------+--------------------+---------+--------+-------+------+-------+---------|
# >> | battle_user_receptions | index_battle_user_receptions_on_battle_user_id | false  | ["battle_user_id"] | {}      |        |       |      | btree |         |
# >> |------------------------+------------------------------------------------+--------+--------------------+---------+--------+-------+------+-------+---------|
# >> 
# >> battle_users
# >> |--------------+---------------------------------------+--------+---------------------+---------+--------+-------+------+-------+---------|
# >> | table        | name                                  | unique | columns             | lengths | orders | where | type | using | comment |
# >> |--------------+---------------------------------------+--------+---------------------+---------+--------+-------+------+-------+---------|
# >> | battle_users | index_battle_users_on_uid             | true   | ["uid"]             | {}      |        |       |      | btree |         |
# >> | battle_users | index_battle_users_on_battle_grade_id | false  | ["battle_grade_id"] | {}      |        |       |      | btree |         |
# >> |--------------+---------------------------------------+--------+---------------------+---------+--------+-------+------+-------+---------|
# >> 
# >> converted_infos
# >> |-----------------+--------------------------------------------------------------+--------+----------------------------------------+---------+--------+-------+------+-------+---------|
# >> | table           | name                                                         | unique | columns                                | lengths | orders | where | type | using | comment |
# >> |-----------------+--------------------------------------------------------------+--------+----------------------------------------+---------+--------+-------+------+-------+---------|
# >> | converted_infos | index_converted_infos_on_convertable_type_and_convertable_id | false  | ["convertable_type", "convertable_id"] | {}      |        |       |      | btree |         |
# >> | converted_infos | index_converted_infos_on_text_format                         | false  | ["text_format"]                        | {}      |        |       |      | btree |         |
# >> |-----------------+--------------------------------------------------------------+--------+----------------------------------------+---------+--------+-------+------+-------+---------|
# >> 
# >> free_battle_records
# >> |---------------------+-----------------------------------------+--------+----------------+---------+--------+-------+------+-------+---------|
# >> | table               | name                                    | unique | columns        | lengths | orders | where | type | using | comment |
# >> |---------------------+-----------------------------------------+--------+----------------+---------+--------+-------+------+-------+---------|
# >> | free_battle_records | index_free_battle_records_on_unique_key | false  | ["unique_key"] | {}      |        |       |      | btree |         |
# >> |---------------------+-----------------------------------------+--------+----------------+---------+--------+-------+------+-------+---------|
# >> 
# >> schema_migrations
# >> 
# >> taggings
# >> |----------+-------------------------------------------------------------+--------+-----------------------------------------------------------------------------------+---------+--------+-------+------+-------+---------|
# >> | table    | name                                                        | unique | columns                                                                           | lengths | orders | where | type | using | comment |
# >> |----------+-------------------------------------------------------------+--------+-----------------------------------------------------------------------------------+---------+--------+-------+------+-------+---------|
# >> | taggings | taggings_idx                                                | true   | ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"] | {}      |        |       |      | btree |         |
# >> | taggings | index_taggings_on_taggable_id_and_taggable_type_and_context | false  | ["taggable_id", "taggable_type", "context"]                                       | {}      |        |       |      | btree |         |
# >> | taggings | index_taggings_on_tag_id                                    | false  | ["tag_id"]                                                                        | {}      |        |       |      | btree |         |
# >> | taggings | index_taggings_on_taggable_id                               | false  | ["taggable_id"]                                                                   | {}      |        |       |      | btree |         |
# >> | taggings | index_taggings_on_taggable_type                             | false  | ["taggable_type"]                                                                 | {}      |        |       |      | btree |         |
# >> | taggings | index_taggings_on_tagger_id                                 | false  | ["tagger_id"]                                                                     | {}      |        |       |      | btree |         |
# >> | taggings | index_taggings_on_context                                   | false  | ["context"]                                                                       | {}      |        |       |      | btree |         |
# >> | taggings | index_taggings_on_tagger_id_and_tagger_type                 | false  | ["tagger_id", "tagger_type"]                                                      | {}      |        |       |      | btree |         |
# >> | taggings | taggings_idy                                                | false  | ["taggable_id", "taggable_type", "tagger_id", "context"]                          | {}      |        |       |      | btree |         |
# >> |----------+-------------------------------------------------------------+--------+-----------------------------------------------------------------------------------+---------+--------+-------+------+-------+---------|
# >> 
# >> tags
# >> |-------+--------------------+--------+----------+---------+--------+-------+------+-------+---------|
# >> | table | name               | unique | columns  | lengths | orders | where | type | using | comment |
# >> |-------+--------------------+--------+----------+---------+--------+-------+------+-------+---------|
# >> | tags  | index_tags_on_name | true   | ["name"] | {}      |        |       |      | btree |         |
# >> |-------+--------------------+--------+----------+---------+--------+-------+------+-------+---------|
