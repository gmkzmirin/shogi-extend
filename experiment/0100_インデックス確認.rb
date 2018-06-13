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
# >> converted_infos
# >> |-----------------+--------------------------------------------------------------+--------+----------------------------------------+---------+--------+-------+------+-------+---------|
# >> | table           | name                                                         | unique | columns                                | lengths | orders | where | type | using | comment |
# >> |-----------------+--------------------------------------------------------------+--------+----------------------------------------+---------+--------+-------+------+-------+---------|
# >> | converted_infos | index_converted_infos_on_convertable_type_and_convertable_id | false  | ["convertable_type", "convertable_id"] | {}      |        |       |      | btree |         |
# >> | converted_infos | index_converted_infos_on_text_format                         | false  | ["text_format"]                        | {}      |        |       |      | btree |         |
# >> |-----------------+--------------------------------------------------------------+--------+----------------------------------------+---------+--------+-------+------+-------+---------|
# >> 
# >> free_battles
# >> |---------------------------+-----------------------------------------------+--------+----------------+---------+--------+-------+------+-------+---------|
# >> | table                     | name                                          | unique | columns        | lengths | orders | where | type | using | comment |
# >> |---------------------------+-----------------------------------------------+--------+----------------+---------+--------+-------+------+-------+---------|
# >> | free_battles | index_free_battles_on_unique_key | false  | ["unique_key"] | {}      |        |       |      | btree |         |
# >> |---------------------------+-----------------------------------------------+--------+----------------+---------+--------+-------+------+-------+---------|
# >> 
# >> general_battles
# >> |------------------------+---------------------------------------------------+--------+-----------------------+---------+--------+-------+------+-------+---------|
# >> | table                  | name                                              | unique | columns               | lengths | orders | where | type | using | comment |
# >> |------------------------+---------------------------------------------------+--------+-----------------------+---------+--------+-------+------+-------+---------|
# >> | general_battles | index_general_battles_on_battle_key        | true   | ["battle_key"]        | {}      |        |       |      | btree |         |
# >> | general_battles | index_general_battles_on_general_battle_state_key | false  | ["general_battle_state_key"] | {}      |        |       |      | btree |         |
# >> |------------------------+---------------------------------------------------+--------+-----------------------+---------+--------+-------+------+-------+---------|
# >> 
# >> general_memberships
# >> |----------------------+--------------------------------------------------------+--------+----------------------------------------------+---------+--------+-------+------+-------+---------|
# >> | table                | name                                                   | unique | columns                                      | lengths | orders | where | type | using | comment |
# >> |----------------------+--------------------------------------------------------+--------+----------------------------------------------+---------+--------+-------+------+-------+---------|
# >> | general_memberships | general_memberships_gbri_lk                           | true   | ["general_battle_id", "location_key"] | {}      |        |       |      | btree |         |
# >> | general_memberships | index_general_memberships_on_general_battle_id | false  | ["general_battle_id"]                 | {}      |        |       |      | btree |         |
# >> | general_memberships | index_general_memberships_on_judge_key                | false  | ["judge_key"]                                | {}      |        |       |      | btree |         |
# >> | general_memberships | index_general_memberships_on_location_key             | false  | ["location_key"]                             | {}      |        |       |      | btree |         |
# >> | general_memberships | index_general_memberships_on_position                 | false  | ["position"]                                 | {}      |        |       |      | btree |         |
# >> |----------------------+--------------------------------------------------------+--------+----------------------------------------------+---------+--------+-------+------+-------+---------|
# >> 
# >> general_users
# >> |----------------------+------------------------------------+--------+----------+---------+--------+-------+------+-------+---------|
# >> | table                | name                               | unique | columns  | lengths | orders | where | type | using | comment |
# >> |----------------------+------------------------------------+--------+----------+---------+--------+-------+------+-------+---------|
# >> | general_users | index_general_users_on_name | true   | ["name"] | {}      |        |       |      | btree |         |
# >> |----------------------+------------------------------------+--------+----------+---------+--------+-------+------+-------+---------|
# >> 
# >> schema_migrations
# >> 
# >> grades
# >> |---------------------+-----------------------------------------+--------+----------------+---------+--------+-------+------+-------+---------|
# >> | table               | name                                    | unique | columns        | lengths | orders | where | type | using | comment |
# >> |---------------------+-----------------------------------------+--------+----------------+---------+--------+-------+------+-------+---------|
# >> | grades | index_grades_on_unique_key | true   | ["unique_key"] | {}      |        |       |      | btree |         |
# >> | grades | index_grades_on_priority   | false  | ["priority"]   | {}      |        |       |      | btree |         |
# >> |---------------------+-----------------------------------------+--------+----------------+---------+--------+-------+------+-------+---------|
# >> 
# >> battles
# >> |----------------------+--------------------------------------------------------+--------+------------------------------+---------+--------+-------+------+-------+---------|
# >> | table                | name                                                   | unique | columns                      | lengths | orders | where | type | using | comment |
# >> |----------------------+--------------------------------------------------------+--------+------------------------------+---------+--------+-------+------+-------+---------|
# >> | battles | index_battles_on_battle_key               | true   | ["battle_key"]               | {}      |        |       |      | btree |         |
# >> | battles | index_battles_on_rule_key          | false  | ["rule_key"]          | {}      |        |       |      | btree |         |
# >> | battles | index_battles_on_battle_state_key         | false  | ["battle_state_key"]         | {}      |        |       |      | btree |         |
# >> | battles | index_battles_on_win_user_id | false  | ["win_user_id"] | {}      |        |       |      | btree |         |
# >> |----------------------+--------------------------------------------------------+--------+------------------------------+---------+--------+-------+------+-------+---------|
# >> 
# >> memberships
# >> |--------------------+----------------------------------------------------+--------+----------------------------------------------------+---------+--------+-------+------+-------+---------|
# >> | table              | name                                               | unique | columns                                            | lengths | orders | where | type | using | comment |
# >> |--------------------+----------------------------------------------------+--------+----------------------------------------------------+---------+--------+-------+------+-------+---------|
# >> | memberships | memberships_sbri_lk                         | true   | ["battle_id", "location_key"]         | {}      |        |       |      | btree |         |
# >> | memberships | memberships_sbri_sbui                       | true   | ["battle_id", "user_id"] | {}      |        |       |      | btree |         |
# >> | memberships | index_memberships_on_battle_id | false  | ["battle_id"]                         | {}      |        |       |      | btree |         |
# >> | memberships | index_memberships_on_user_id   | false  | ["user_id"]                           | {}      |        |       |      | btree |         |
# >> | memberships | index_memberships_on_grade_id  | false  | ["grade_id"]                          | {}      |        |       |      | btree |         |
# >> | memberships | index_memberships_on_judge_key              | false  | ["judge_key"]                                      | {}      |        |       |      | btree |         |
# >> | memberships | index_memberships_on_location_key           | false  | ["location_key"]                                   | {}      |        |       |      | btree |         |
# >> | memberships | index_memberships_on_position               | false  | ["position"]                                       | {}      |        |       |      | btree |         |
# >> |--------------------+----------------------------------------------------+--------+----------------------------------------------------+---------+--------+-------+------+-------+---------|
# >> 
# >> users
# >> |--------------------+---------------------------------------------------+--------+---------------------------+---------+--------+-------+------+-------+---------|
# >> | table              | name                                              | unique | columns                   | lengths | orders | where | type | using | comment |
# >> |--------------------+---------------------------------------------------+--------+---------------------------+---------+--------+-------+------+-------+---------|
# >> | users | index_users_on_user_key                   | true   | ["user_key"]                   | {}      |        |       |      | btree |         |
# >> | users | index_users_on_grade_id | false  | ["grade_id"] | {}      |        |       |      | btree |         |
# >> |--------------------+---------------------------------------------------+--------+---------------------------+---------+--------+-------+------+-------+---------|
# >> 
# >> search_logs
# >> |------------------------------------+------------------------------------------------------------------+--------+--------------------------+---------+--------+-------+------+-------+---------|
# >> | table                              | name                                                             | unique | columns                  | lengths | orders | where | type | using | comment |
# >> |------------------------------------+------------------------------------------------------------------+--------+--------------------------+---------+--------+-------+------+-------+---------|
# >> | search_logs | index_search_logs_on_user_id | false  | ["user_id"] | {}      |        |       |      | btree |         |
# >> |------------------------------------+------------------------------------------------------------------+--------+--------------------------+---------+--------+-------+------+-------+---------|
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
