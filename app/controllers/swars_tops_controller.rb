class SwarsTopsController < ApplicationController
  def show
    if Rails.env.development?
      # BattleUser.destroy_all
      # BattleRecord.destroy_all
    end

    if current_battle_user_key
      before_count = 0
      if battle_user = BattleUser.find_by(battle_user_key: current_battle_user_key)
        before_count = battle_user.battle_records.count
      end

      Rails.cache.fetch("import_all_#{current_battle_user_key}", expires_in: Rails.env.production? ? 30.seconds : 5.seconds) do
        BattleRecord.import_all(battle_user_key: current_battle_user_key)
        Time.current
      end

      @battle_user = BattleUser.find_by(battle_user_key: current_battle_user_key)
      if @battle_user
        count_diff = @battle_user.battle_records.count - before_count
        if count_diff.zero?
        else
          flash.now[:info] = "#{count_diff}件新しく見つかりました"
        end
      else
        flash.now[:warning] = "#{current_battle_user_key} さんのデータは見つかりませんでした"
      end
    end

    if @battle_user
      @battle_records = @battle_user.battle_records
    else
      @battle_records = BattleRecord.all
    end
    @battle_records = @battle_records.order(battled_at: :desc).page(params[:page]).per(params[:per])

    @rows = @battle_records.collect do |battle_record|
      {}.tap do |row|
        if @battle_user
          current_user_ship = battle_record.current_user_ship(@battle_user)
          reverse_user_ship = battle_record.reverse_user_ship(@battle_user)
          row["対象プレイヤー"] = battle_record.win_lose_str(current_user_ship.battle_user).html_safe + " " + h.link_to(current_user_ship.name_with_rank, current_user_ship.battle_user)
          row["対戦相手"]       = battle_record.win_lose_str(reverse_user_ship.battle_user).html_safe + " " + h.link_to(reverse_user_ship.name_with_rank, reverse_user_ship.battle_user)
          # if !Rails.env.production? || params[:debug].present?
          #   row["棋神"] = battle_record.kishin_tsukatta?(reverse_user_ship) ? "降臨" : ""
          # end
          # row["段級"] = reverse_user_ship.battle_rank.name
        else
          # row["勝ち"] = "○".html_safe + " " + battle_user_link(battle_record, true)
          # row["負け"] = "●".html_safe + " " + battle_user_link(battle_record, false)

          if battle_record.win_battle_user
            row["勝ち"] = Fa.fa_i(:circle_o) + battle_user_link(battle_record, :win)
            row["負け"] = Fa.fa_i(:circle) + battle_user_link(battle_record, :lose)
          else
            row["勝ち"] = Fa.fa_i(:minus, :class => "icon_hidden") + battle_user_link2(battle_record.battle_ships.black)
            row["負け"] = Fa.fa_i(:minus, :class => "icon_hidden") + battle_user_link2(battle_record.battle_ships.white)
          end
        end
        row["判定"] = battle_state_info_decorate(battle_record)
        row["手数"] = battle_record.turn_max
        row["種類"] = battle_record.battle_group_info.name
        row["日時"] = battled_at_decorate(battle_record)
        row[""] = row_links(battle_record)
      end
    end
  end

  def row_links(current_record)
    list = []
    list << h.link_to("詳細", [:name_space1, current_record], "class": "btn btn-default btn-sm")
    if Rails.env.development?
      list << h.link_to("山脈(remote:false)", [:name_space1, current_record, sanmyaku: true, fallback_location: url_for([:s])], "class": "btn btn-default btn-sm", remote: false)
    end
    list << h.link_to("山脈", [:name_space1, current_record, sanmyaku: true], "class": "btn btn-default btn-sm", remote: true)
    list << h.link_to("コピー".html_safe, "#", "class": "btn btn-primary btn-sm kif_clipboard_copy_button", data: {kif_direct_access_path: url_for([:name_space1, current_record, format: "kif"])})
    list << h.link_to(h.image_tag("piyo_link.png", "class": "row_piyo_link"), piyo_link_url(full_url_for([:name_space1, current_record, format: "kif"])))

    # list << h.link_to("KIF", [:name_space1, current_record, format: "kif"], "class": "btn btn-default btn-sm")
    # list << h.link_to("KI2", [:name_space1, current_record, format: "ki2"], "class": "btn btn-default btn-sm")
    # list << h.link_to("CSA", [:name_space1, current_record, format: "csa"], "class": "btn btn-default btn-sm")

    # list << h.link_to("ウォ", swars_board_url(current_record), "class": "btn btn-default btn-sm")

    list.compact.join(" ").html_safe
  end

  def battle_user_link(battle_record, win_lose_key)
    if battle_ship = battle_record.battle_ships.win_lose_key_eq(win_lose_key).take
      battle_user_link2(battle_ship)
      # if !Rails.env.production? || params[:debug].present?
      #   if battle_record.kishin_tsukatta?(battle_ship)
      #     s += "&#x2757;".html_safe
      #   end
      # end
    end
  end

  def battle_user_link2(battle_ship)
    h.link_to(battle_ship.name_with_rank, battle_ship.battle_user)
  end

  def battled_at_decorate(battle_record)
    # if battle_record.battled_at < 1.months.ago
    #   h.time_ago_in_words(battle_record.battled_at) + "前"
    # else
    # end
    battle_record.battled_at.to_s(:battle_ymd)
  end

  def battle_state_info_decorate(battle_record)
    str = battle_record.battle_state_info.name
    battle_state_info = battle_record.battle_state_info
    if v = battle_state_info.label_key
      str = h.tag.span(str, "class": "label label-#{v}")
    end
    if v = battle_state_info.icon_key
      str = h.fa_i(v) + str
    end
    str
  end

  def current_battle_user_key
    # if Rails.env.development?
    #   params[:battle_user_key] = "hanairobiyori"
    # end

    if e = [:battle_user_key, :key, :player, :user].find { |e| params[e].present? }
      s = params[e].to_s.gsub(/\p{blank}/, " ").strip

      # https://shogiwars.heroz.jp/users/history/xxx?gtype=&locale=ja -> xxx
      if true
        if url = URI::Parser.new.extract(s).first
          if md = URI(url).path.match(%r{history/(.*)})
            s = md.captures.first
          end
        end
      end

      s.presence
    end
  end

  def h
    @h ||= view_context
  end

  rescue_from "Mechanize::ResponseCodeError" do |exception|
    notify_airbrake(exception)
    flash.now[:warning] = "該当のユーザーが見つかりません"
    if Rails.env.development?
      flash.now[:alert] = "#{exception.class.name}: #{exception.message}"
    end
    render :show
  end
end
