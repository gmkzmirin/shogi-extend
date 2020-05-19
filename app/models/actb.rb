module Actb
  extend self

  def table_name_prefix
    name.underscore.gsub("/", "_") + "_"
  end

  def setup(options = {})
    eval Pathname("#{__dir__}/actb/seeds.rb").read, binding
  end

  def models
    [Question, Room, Season, Profile, GoodMark, BadMark, ClipMark, Folder, Kind]
  end

  def destroy_all
    models.each do |e|
      e.destroy_all
      # e.delete_all
    end
  end

  def info
    [Colosseum::User, *models].collect { |e|
      { model: e, count: e.count, "最終ID" => e.order(:id).last&.id }
    }
  end
end
