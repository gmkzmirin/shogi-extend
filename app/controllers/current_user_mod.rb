module CurrentUserMod
  extend ActiveSupport::Concern

  included do
    helper_method :js_global
    helper_method :sysop?
    helper_method :editable_record?
    helper_method :current_user
  end

  # FIXME: セキュリティ的にだめ
  def js_global
    @js_global ||= {
      :current_user => current_user && current_user.as_json(only: [:id, :name], methods: [:show_path, :avatar_path]),
    }
  end

  let :sysop? do
    current_user && current_user.sysop?
  end

  def editable_record?(record)
    sysop? || current_user_is_owner_of?(record)
  end

  def current_user_is_owner_of?(record)
    if current_user
      if record
        if record.respond_to?(:user)
          if record.user
            record.user == current_user
          end
        end
      end
    end
  end

  # いろんなものからログインユーザーを作っている
  # cookies.signed[:user_id] は ActionCable の読み出し用なのでここに入れない方がいいかもしれない
  let :current_user do
    id = nil
    user = nil

    if Rails.env.development? || Rails.env.test?
      id ||= params[:_user_id]
    end

    id ||= session[:user_id]
    id ||= cookies.signed[:user_id]
    if id
      user ||= User.find_by(id: id)
    end
    user ||= current_xuser    # from devise

    if user
      if request.format.html? && request.get?
        # rails r "p User.first.cache_key"
        Rails.cache.fetch("#{user.cache_key}/update_tracked_fields!", expires_in: 1.hour) do
          user.user_agent = request.user_agent.to_s
          user.update_tracked_fields!(request)
          true
        end
      end
    end

    unless user
      # ユーザー削除後にそのユーザーと同じでIDでユーザーを作ったとき、
      # セッションに残っているユーザーIDで新しく作ったユーザーにすりかわることができるのを防ぐ
      current_user_clear
    end

    user
  end

  def current_user_set(user)
    unless user.kind_of?(Integer) || user.kind_of?(User)
      raise ArgumentError, user.inspect
    end

    if user.kind_of?(Integer)
      user = User.find_by(id: user)
    end

    unless user.kind_of?(User)
      raise ArgumentError, user.inspect
    end

    session[:user_id] = user.id
    current_user_set_for_action_cable(user)
    sign_in(user, event: :authentication)

    current_user_memoize_variable_clear
  end

  # すでにログインしているユーザーのIDをActionCableで拾えるようにするため
  def current_user_set_for_action_cable(user)
    raise ArgumentError, user.inspect unless user.kind_of?(User)
    cookies.signed[:user_id] = { value: user.id, expires: 1.years.from_now } # for app/channels/application_cable/connection.rb
  end

  def current_user_clear
    session.delete(:user_id)
    cookies.delete(:user_id)
    sign_out(:xuser)

    current_user_memoize_variable_clear
  end

  def sysop_login_unless_logout
    unless current_user
      current_user_set(User.sysop)
    end
  end

  private

  def current_user_memoize_variable_clear
    if instance_variable_defined?(:@current_user)
      remove_instance_variable(:@current_user)
    end
  end
end
