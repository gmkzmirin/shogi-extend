# 詰将棋ファイター
#
# entry
#   app/models/backend_script/acns2_sample_script.rb
#
# vue
#   app/javascript/acns2_sample.vue
#
# db
#   db/migrate/20200414142200_create_acns2.rb
#
# test
#   experiment/0850_acns2.rb
#
# model
#   app/models/acns2/membership.rb
#   app/models/acns2/room.rb
#   app/models/acns2.rb
#   app/models/colosseum/user_acns2_mod.rb
#
#   question
#     app/models/acns2/question.rb
#     app/models/acns2/moves_answer.rb
#     app/models/acns2/endpos_answer.rb
#
# channel
#   app/channels/acns2/lobby_channel.rb
#   app/channels/acns2/room_channel.rb
#
# job
#   app/jobs/acns2/lobby_broadcast_job.rb
#   app/jobs/acns2/message_broadcast_job.rb
#
module BackendScript
  class Acns2SampleScript < ::BackendScript::Base
    include AtomicScript::AddJsonLinkMod

    self.script_name = "詰将棋ファイター"
    self.page_title = ""

    def form_parts
      [
        {
          :label   => "画面",
          :key     => :debug_scene,
          :elems   => { "ロビー" => nil, "対戦" => :ready_go, "結果" => :result_show, "編集"  => :edit, },
          :type    => :select,
          :default => current_debug_scene,
        },
      ]
    end

    def script_body
      params = {
        "question" => {
          "init_sfen" => "4k4/9/4GG3/9/9/9/9/9/9 b 2r2b2g4s4n4l18p #{rand(1000000)}",
          "moves_answers_attributes"=>[{"sfen_moves_pack"=>"4c5b"}],
          "time_limit_clock"=>"1999-12-31T15:03:00.000Z",
        },
      }.deep_symbolize_keys

      question = params[:question]
      record = h.current_user.acns2_questions.find_or_initialize_by(id: question[:id])
      record.assign_attributes(question.slice(:init_sfen, :title, :description, :hint_description, :source_desc, :other_twitter_account))

      a = Time.zone.parse(question[:time_limit_clock])
      b = Time.zone.parse("2000-01-01")
      record.time_limit_sec = a - b
      record.save!

      # 削除
      record.moves_answer_ids = question[:moves_answers_attributes].collect { |e| e[:id] }

      # 追加 or 更新
      question[:moves_answers_attributes].each do |e|
        moves_answer = record.moves_answers.find_or_initialize_by(id: e[:id])
        moves_answer.sfen_moves_pack = e[:sfen_moves_pack]
        moves_answer.save!
      end

      # question = h.current_user.acns2_questions.create! do |e|
      #   e.assign_attributes(params[:question])
      #   # e.init_sfen = "4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1"
      #   e.moves_answers.build(sfen_moves_pack: "G*5b")
      #   e.endpos_answers.build(sfen_endpos: "4k4/4G4/4G4/9/9/9/9/9/9 w 2r2b2g4s4n4l18p 2")
      # end

      hash = record.attributes
      hash = hash.merge(moves_answers_attributes: record.moves_answers)
      return hash.as_json

      # Acns2.setup

      if params[:login_required]
        unless h.current_user
          h.session[:return_to] = h.url_for(script_link_path)
          c.redirect_to :new_xuser_session
          return
        end
      end

      out = ""

      # return ActionCable.server.open_connections_statistics
      # .map { |con| con[:subscriptions]
      #   .map { |sub| JSON.parse(sub)["url"] } } # ここのurlを変えれば特定の接続数を取得できるはず
      # .flatten
      # .select { |url| url == 'http:himakannet' } # ここで特定のチャネル一致
      # .size

      if request.format.json?
      end

      # if !current_room
      #   out += Acns2::Room.order(:id).collect { |room|
      #     {
      #       "チャットルーム" => h.link_to(room.id, params.merge(room_id: room.id)),
      #     }
      #   }.to_html
      # end

      if current_room
        #   messages = current_room.messages.order(:id).last(10)
        #   rendered_messages = messages.collect { |message|
        #     ApplicationController.renderer.render partial: 'acns2/messages/message', locals: { message: message }
        #   }
      end

      info = {}

      debug_scene_set(info)

      info[:mode] ||= "lobby"
      info[:put_path] = h.url_for(script_link_path)

      if h.current_user
        info[:current_user] = h.current_user.as_json(only: [:id, :name], methods: [:avatar_path])
      end

      # info[:room] = current_room
      # info[:messages] = rendered_messages
      if request.format.json?
        return info
      end
      #
      out += h.javascript_tag(%(document.addEventListener('DOMContentLoaded', () => { new Vue({}).$mount("#app") })))
      out += %(<div id="app"><acns2_sample :info='#{info.to_json}' /></div>)
      # out += h.tag.br
      # out += h.link_to("ロビー", params.merge(room_id: nil), :class => "button is-small")
      # end

      out
    end

    def put_action
      # Parameters: {"sp_title"=>"", "sp_desc"=>"", "init_sfen"=>"null", "answers"=>"", "id"=>"acns2-sample"}

      # {:sp_title, :sp_desc, :init_sfen, :answers}

      # >> |-----------------------+--------------------------------------------|
      # >> |                    id | 1                                          |
      # >> |               user_id | 14                                         |
      # >> |             init_sfen | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1 |
      # >> |        time_limit_sec |                                            |
      # >> |                 title |                                            |
      # >> |           description |                                            |
      # >> |      hint_description |                                            |
      # >> |           source_desc |                                            |
      # >> | other_twitter_account |                                            |
      # >> |            created_at | 2020-04-19 21:07:35 +0900                  |
      # >> |            updated_at | 2020-04-19 21:07:35 +0900                  |
      # >> |               o_count | 0                                          |
      # >> |               x_count | 0                                          |
      # >> |-----------------------+--------------------------------------------|

      # question = h.current_user.acns2_questions.create! do |e|
      #   e.assign_attributes(params[:question])
      #   # e.init_sfen = "4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1"
      #   e.moves_answers.build(sfen_moves_pack: "G*5b")
      #   e.endpos_answers.build(sfen_endpos: "4k4/4G4/4G4/9/9/9/9/9/9 w 2r2b2g4s4n4l18p 2")
      # end

      # params[:question]

      # {"question"=>{"init_sfen"=>"4k4/9/4GG3/9/9/9/9/9/9 b 2r2b2g4s4n4l18p 1",
      #     "moves_answers_attributes"=>[{"sfen_moves_pack"=>"4c5b"}],
      #     "time_limit_sec"=>"1999-12-31T15:03:00.000Z"},
      #   "id"=>"acns2-sample",
      #   "script"=>{"question"=>{"init_sfen"=>"4k4/9/4GG3/9/9/9/9/9/9 b 2r2b2g4s4n4l18p 1",
      #       "moves_answers_attributes"=>[{"sfen_moves_pack"=>"4c5b"}],
      #       "time_limit_sec"=>"1999-12-31T15:03:00.000Z"}}}

      question = params[:question]
      if id = question[:id]
        record = h.current_user.acns2_questions.find(id)
      end
      record ||= h.current_user.acns2_questions.build
      record.assign_attributes(question.slice())

      # question = h.current_user.acns2_questions.create! do |e|
      #   e.assign_attributes(params[:question])
      #   # e.init_sfen = "4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1"
      #   e.moves_answers.build(sfen_moves_pack: "G*5b")
      #   e.endpos_answers.build(sfen_endpos: "4k4/4G4/4G4/9/9/9/9/9/9 w 2r2b2g4s4n4l18p 2")
      # end

      hash = question.attributes
      hash = hash.merge(moves_answers_attributes: question.moves_answers)
      render json: hash
    end

    def current_room_id
      params[:room_id].presence
    end

    def current_room
      if v = current_room_id
        Acns2::Room.find_by(id: v)
      end
    end

    def current_debug_scene
      if v = params[:debug_scene].presence
        v.to_sym
      end
    end

    def debug_scene_set(info)
      info[:debug_scene] = current_debug_scene

      if current_debug_scene == :ready_go
        c.sysop_login_unless_logout

        user = Colosseum::User.create!
        room = Acns2::Room.create! do |e|
          e.memberships.build(user: h.current_user)
          e.memberships.build(user: user)
        end

        info[:room] = room.as_json(only: [:id], include: { memberships: { only: [:id, :judge_key, :rensho_count, :renpai_count, :quest_index], include: {user: { only: [:id, :name], methods: [:avatar_path] }} } }, methods: [:simple_quest_infos, :final_info])
      end

      if current_debug_scene == :result_show
        c.sysop_login_unless_logout

        user1 = h.current_user
        user2 = Colosseum::User.create!
        room = Acns2::Room.create!(final_key: :disconnect) do |e|
          e.memberships.build(user: user1, judge_key: :win,  quest_index: 1)
          e.memberships.build(user: user2, judge_key: :lose, quest_index: 2)
        end

        info[:room] = room.as_json(only: [:id], include: { memberships: { only: [:id, :judge_key, :rensho_count, :renpai_count, :quest_index], include: {user: { only: [:id, :name], methods: [:avatar_path], include: {acns2_profile: { only: [:id, :rensho_count, :renpai_count, :rating, :rating_max, :rating_last_diff, :rensho_max, :renpai_max] } } }} }}, methods: [:simple_quest_infos, :final_info])
      end

      if current_debug_scene == :edit
        c.sysop_login_unless_logout
      end
    end
  end
end
