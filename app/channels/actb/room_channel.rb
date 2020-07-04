module Actb
  class RoomChannel < BaseChannel
    include ActiveUserNotifyMod

    class << self
      def redis_key
        :room_user_ids
      end
    end

    def subscribed
      raise ArgumentError, params.inspect unless room_id
      reject unless current_user

      stream_from "actb/room_channel/#{room_id}"
      self.class.active_users_add(current_user)
      debug_say "*入室しました"

      if once_run("actb/rooms/#{current_room.id}/first_battle_create")
        battle = current_room.battle_create_with_members!
        debug_say "**最初のバトル作成(id:#{battle.id})"
        # --> app/jobs/actb/battle_broadcast_job.rb --> battle_broadcasted --> app/javascript/actb_app/application_room.js
      end
    end

    def unsubscribed
      self.class.active_users_delete(current_user)

      if current_user
        say "*退室しました"
      end

      # 部屋を閉じたら閉じた時間を end_at に入れておく
      # べつに入れておく必要はないがデバッグしやすいように入れておく
      if current_room.end_at.blank?
        if once_run("actb/rooms/#{current_room.id}/disconnect")
          current_room.update!(end_at: Time.current)
        end
      end
    end

    private

    # def battle_leave_handle2(membership)
    #   membership.user.say(current_room, "*room_unsubscribed")
    #   broadcast(:room_member_disconnect_broadcasted, membership_id: membership.id)
    # end

    def room_id
      params["room_id"]
    end

    def current_room
      Room.find(room_id)
    end

    def broadcast(bc_action, bc_params)
      raise ArgumentError, bc_params.inspect unless bc_params.values.all?
      ActionCable.server.broadcast("actb/room_channel/#{room_id}", {bc_action: bc_action, bc_params: bc_params})
    end

    def say(*args)
      return if Rails.env.test?
      current_user.room_speak(current_room, *args)
    end

    def debug_say(*args)
      if Config[:action_cable_debug]
        say(*args)
      end
    end
  end
end
