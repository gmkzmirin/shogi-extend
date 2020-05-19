# 詰将棋ファイター
#
# entry
#   app/models/frontend_script/actb_app_script.rb
#
# vue
#   app/javascript/actb_app/index.vue
#
# db
#   db/migrate/20200505135600_create_actb.rb
#
# test
#   experiment/0860_actb.rb
#
# model
#   app/models/actb/membership.rb
#   app/models/actb/room.rb
#   app/models/actb.rb
#   app/models/colosseum/user_actb_mod.rb
#
#   question
#     app/models/actb/question.rb
#     app/models/actb/moves_answer.rb
#     app/models/actb/endpos_answer.rb
#
# channel
#   app/channels/actb/lobby_channel.rb
#   app/channels/actb/room_channel.rb
#
# job
#   app/jobs/actb/lobby_broadcast_job.rb
#   app/jobs/actb/message_broadcast_job.rb
#
module FrontendScript
  class ActbAppScript < ::FrontendScript::Base
    include AtomicScript::AddJsonLinkMod
    include SortMod

    self.script_name = "詰将棋ファイター"
    self.page_title = ""
    self.form_position = :bottom
    self.column_wrapper_enable = false

    delegate :current_user, to: :h

    QUESTIONS_FETCH_PER = 10
    HISTORY_FETCH_MAX = 50
    CLIP_FETCH_MAX = 50

    def form_parts
      if Rails.env.development?
        [
          {
            :label   => "画面",
            :key     => :debug_scene,
            :elems   => {
              "ロビー"         => nil,
              "対戦"           => :room,
              "結果"           => :result,
              "問題作成"       => :builder,
              "問題作成(情報)" => :builder_form,
              "ランキング"     => :ranking,
              "履歴"           => :history,
              "詳細"           => :overlay_record,
            },

            :type    => :select,
            :default => current_debug_scene,
          },
        ]
      end
    end

    def script_body
      if Rails.env.development?
        c.sysop_login_unless_logout
      end

      # http://localhost:3000/script/actb-app.json?questions_fetch=true
      if params[:questions_fetch]
        params[:per] ||= QUESTIONS_FETCH_PER

        s = current_user.actb_questions
        s = page_scope(s)       # page_mod.rb
        s = sort_scope(s)       # sort_mod.rb

        retv = {**page_info(s), **sort_info}
        retv[:questions] = s.as_json(include: [:user, :moves_answers], only: Actb::Question.index_and_form_json_columns, methods: [:display_key2])

        return retv
      end

      # http://localhost:3000/script/actb-app.json?ranking_fetch=true&ranking_key=rating
      if params[:ranking_fetch]
        return { rank_data: Actb::RankingCop.new(params.merge(current_user: current_user)) }
      end

      # http://localhost:3000/script/actb-app.json?seasons_fetch=true
      if params[:seasons_fetch]
        return { seasons: Actb::Season.newest_order.as_json(only: [:id, :generation, :name, :begin_at, :end_at]) }
      end

      if params[:history_records_fetch]
        s = current_user.actb_histories.order(created_at: :desc).limit(HISTORY_FETCH_MAX)
        retv = {}
        retv[:history_records] = s.as_json(only: [:id], include: {:room => {}, :membership => {}, :question => {include: {:user => {only: [:id, :key, :name], methods: [:avatar_path]}}}, :ans_result => {only: :key}}, methods: [:good_p, :bad_p, :clip_p])
        return retv
      end

      if params[:clip_records_fetch]
        s = current_user.actb_clip_marks.order(created_at: :desc).limit(CLIP_FETCH_MAX)
        retv = {}
        retv[:clip_records] = s.as_json(only: [:id], include: {:question => {include: {:user => {only: [:id, :key, :name], methods: [:avatar_path]}}}}, methods: [:good_p, :bad_p, :clip_p])
        return retv
      end

      # 詳細
      if params[:question_single_fetch]
        question = Actb::Question.find(params[:question_id])
        retv = {}
        retv[:question] = question.as_json(include: {:user => {only: [:id, :key, :name], methods: [:avatar_path]}, :moves_answers => {}})
        retv.update(current_user.good_bad_clip_flags_for(question))
        return { overlay_record: retv }
      end

      # params = {
      #   "question" => {
      #     "init_sfen" => "4k4/9/4GG3/9/9/9/9/9/9 b 2r2b2g4s4n4l18p #{rand(1000000)}",
      #     "moves_answers"=>[{"moves_str"=>"4c5b"}],
      #     "time_limit_clock"=>"1999-12-31T15:03:00.000Z",
      #   },
      # }.deep_symbolize_keys
      #
      # question = current_user.actb_questions.find_or_initialize_by(id: params[:question][:id])
      # question.together_with_params_came_from_js_update(params)
      # return question.create_the_parameters_to_be_passed_to_the_js

      # question = current_user.actb_questions.create! do |e|
      #   e.assign_attributes(params[:question])
      #   # e.init_sfen = "4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1"
      #   e.moves_answers.build(moves_str: "G*5b")
      #   e.endpos_answers.build(end_sfen: "4k4/4G4/4G4/9/9/9/9/9/9 w 2r2b2g4s4n4l18p 2")
      # end

      # Actb.setup

      if params[:login_required]
        unless current_user
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
      #   out += Actb::Room.order(:id).collect { |room|
      #     {
      #       "チャットルーム" => h.link_to(room.id, params.merge(room_id: room.id)),
      #     }
      #   }.to_html
      # end

      if current_room
        #   messages = current_room.messages.order(:id).last(10)
        #   rendered_messages = messages.collect { |message|
        #     ApplicationController.renderer.render partial: 'actb/messages/message', locals: { message: message }
        #   }
      end

      info = {}

      debug_scene_set(info)

      info[:mode] ||= "lobby"
      info[:put_path] = h.url_for(script_link_path)
      info[:question_default] = question_default

      if current_user
        info[:current_user] = current_user.as_json(only: [:id, :key, :name], methods: [:avatar_path, :rating])
      end

      # info[:room] = current_room
      # info[:messages] = rendered_messages
      if request.format.json?
        return info
      end
      #
      out += h.javascript_tag(%(document.addEventListener('DOMContentLoaded', () => { new Vue({}).$mount("#app") })))
      out += %(<div id="app"><actb_app :info='#{info.to_json}' /></div>)
      # out += h.tag.br
      # out += h.link_to("ロビー", params.merge(room_id: nil), :class => "button is-small")
      # end

      c.layout_type = :raw

      out
    end

    def put_action
      if params[:vote_handle]
        c.render json: { retval: current_user.vote_handle(params) }
        return
      end

      if params[:clip_handle]
        c.render json: { retval: current_user.clip_handle(params) }
        return
      end

      if params[:save_handle]
        # params = {
        #   "question" => {
        #     "init_sfen" => "4k4/9/4GG3/9/9/9/9/9/9 b 2r2b2g4s4n4l18p #{rand(1000000)}",
        #     "moves_answers"=>[{"moves_str"=>"4c5b"}],
        #     "time_limit_clock"=>"1999-12-31T15:03:00.000Z",
        #   },
        # }.deep_symbolize_keys

        question = current_user.actb_questions.find_or_initialize_by(id: params[:question][:id])
        begin
          question.together_with_params_came_from_js_update(params)
        rescue ActiveRecord::RecordInvalid => error
          c.render json: { form_error_message: error.message }
          return
        end
        c.render json: { question: question.as_json(question_as_json_params) }
        return
      end

    end

    def question_as_json_params
      { include: [:user, :moves_answers], only: Actb::Question.index_and_form_json_columns, methods: [:display_key2] }
    end

    def current_room_id
      params[:room_id].presence
    end

    def current_room
      if v = current_room_id
        Actb::Room.find_by(id: v)
      end
    end

    def sort_column_default
      :updated_at
    end

    def current_debug_scene
      if v = params[:debug_scene].presence
        v.to_sym
      end
    end

    def question_default
      {
        # // init_sfen: "4k4/9/9/9/9/9/9/9/9 b 2r2b4g4s4n4l18p 1",
        # // init_sfen: "4k4/9/4GG3/9/9/9/9/9/9 b 2r2b2g4s4n4l18p 1",
        init_sfen: "7gk/9/7GG/7N1/9/9/9/9/9 b 2r2bg4s3n4l18p 1",
        moves_answers: [
          moves_str: "1c1b",
          end_sfen: "7gk/8G/7G1/7N1/9/9/9/9/9 w 2r2bg4s3n4l18p 2",
        ],
        time_limit_sec: 3 * 60,
        difficulty_level: 1,
        title: "(title)",
        display_key2: "active",
      }
    end

    def debug_scene_set(info)
      info[:debug_scene] = current_debug_scene

      if current_debug_scene == :lobby
        c.sysop_login_unless_logout
      end

      if current_debug_scene == :room
        c.sysop_login_unless_logout

        user = Colosseum::User.create!
        room = Actb::Room.create! do |e|
          e.memberships.build(user: current_user)
          e.memberships.build(user: user)
        end

        info[:room] = room.as_json(only: [:id], include: { memberships: { only: [:id, :judge_key, :rensho_count, :renpai_count, :question_index], include: {user: { only: [:id, :name], methods: [:avatar_path] }} } }, methods: [:best_questions, :final_info])
      end

      if current_debug_scene == :result
        c.sysop_login_unless_logout

        user1 = current_user
        user2 = Colosseum::User.create!
        room = Actb::Room.create!(final_key: :disconnect) do |e|
          e.memberships.build(user: user1, judge_key: :win,  question_index: 1)
          e.memberships.build(user: user2, judge_key: :lose, question_index: 2)
        end

        info[:room] = room.as_json(only: [:id], include: { memberships: { only: [:id, :judge_key, :rensho_count, :renpai_count, :question_index], include: {user: { only: [:id, :name], methods: [:avatar_path], include: {actb_newest_profile: { only: [:id, :rensho_count, :renpai_count, :rating, :rating_max, :rating_last_diff, :rensho_max, :renpai_max] } } }} }}, methods: [:best_questions, :final_info])
      end

      if current_debug_scene == :edit
        c.sysop_login_unless_logout
      end

      if current_debug_scene == :ranking
        c.sysop_login_unless_logout
      end

      if current_debug_scene == :history
        c.sysop_login_unless_logout
      end

      if current_debug_scene == :overlay_record
        c.sysop_login_unless_logout

        # Actb::Question.destroy_all
        # user = Colosseum::User.sysop
        # question = user.actb_questions.create! do |e|
        #   e.init_sfen = "4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l1p 1"
        #   e.moves_answers.build(moves_str: "G*4b")
        #   e.moves_answers.build(moves_str: "G*5b")
        #   e.moves_answers.build(moves_str: "G*6b")
        #   e.time_limit_sec        = 60 * 3
        #   e.difficulty_level      = 5
        #   e.title                 = "(title)"
        #   e.description           = "(description)"
        #   e.hint_description      = "(hint_description)"
        #   e.source_desc           = "(source_desc)"
        #   e.other_twitter_account = "(other_twitter_account)"
        # end

        info[:question_id] = Actb::Question.first&.id
      end
    end
  end
end
