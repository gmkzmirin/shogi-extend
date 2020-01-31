#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

tp ActiveStorage::Attachment
tp ActiveStorage::Blob
puts `tree ../storage`

# >> |----+--------------------------+--------------------------------------+--------------+----------------------------------------------------------------------+-----------+--------------------------+---------------------------|
# >> | id | key                      | filename                             | content_type | metadata                                                             | byte_size | checksum                 | created_at                |
# >> |----+--------------------------+--------------------------------------+--------------+----------------------------------------------------------------------+-----------+--------------------------+---------------------------|
# >> | 19 | BiiDAJK61GHQwCvc2LHgZUm7 | 9cec557aa3cec8fea4dcfcf0fc0d7472.png | image/png    | {"identified"=>true, "width"=>1200, "height"=>630, "analyzed"=>true} |     29671 | DQutetmTo9yLWGoJJi+z8w== | 2020-01-31 22:15:39 +0900 |
# >> |----+--------------------------+--------------------------------------+--------------+----------------------------------------------------------------------+-----------+--------------------------+---------------------------|
# >> ../storage
# >> └── Bi
# >>     └── iD
# >>         └── BiiDAJK61GHQwCvc2LHgZUm7
# >> 
# >> 2 directories, 1 file
