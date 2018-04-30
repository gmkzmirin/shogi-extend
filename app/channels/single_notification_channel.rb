class SingleNotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "single_notification_#{current_chat_user.id}"
  end

  def message_send_to(data)
    ActionCable.server.broadcast("single_notification_#{data['to']['id']}", data)
  end

  # def goto_chat_room(data)
  #   ActionCable.server.broadcast("single_notification_#{data['to']['id']}", data)
  # end
end
