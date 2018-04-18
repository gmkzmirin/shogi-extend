# モデルに保存する版
class ChatRoomChannel < ApplicationCable::Channel
  def subscribed
    # ChatMembership.destroy_all

    Rails.logger.debug(["#{__FILE__}:#{__LINE__}", __method__, "subscribed", params])

    # stream_from "chat_#{params[:room]}"
    # Rails.logger.debug(["#{__FILE__}:#{__LINE__}", __method__, params[:chat_room_id]])

    # stream_from [:chat_room_channel, params[:chat_room_id]].join
    stream_from "chat_room_channel_#{params[:chat_room_id]}"

    # post = Post.find(params[:id])
    # stream_for post
    # ChatRoomChannel.broadcast_to(@post, @comment)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    Rails.logger.debug(["#{__FILE__}:#{__LINE__}", __method__])
  end

  # /Users/ikeda/src/shogi_web/app/javascript/packs/chat_room.js の App.chat_room.send({kifu_body_sfen: response.data.sfen}) で呼ばれる
  def receive(data)
    Rails.logger.debug(["#{__FILE__}:#{__LINE__}", __method__])
    # if data["kifu_body_sfen"]
    #   Rails.logger.debug(current_chat_user)
    #   ActionCable.server.broadcast("chat_room_channel_#{params[:chat_room_id]}", data)
    # end
  end

  ################################################################################

  # モデルに保存して非同期でブロードキャストする
  def chat_say(data)
    if false
      ChatArticle.create!(body: data["chat_article_body"])
    else
      chat_user = ChatUser.find(data["sayed_chat_user_id"])
      chat_room = ChatRoom.find(data["chat_room_id"])
      chat_article = chat_user.chat_articles.create!(chat_room: chat_room, body: data["chat_article_body"])
      # chat_article = ChatArticle.create!(body: data["chat_article_body"])

      # body = data["chat_article_body"]
      # chat_article = ChatArticle.new {body: body, created_at: Time.current}
      # コントローラーを経由せずに直接ビューを利用してHTMLを作れる
      # html = ApplicationController.renderer.render(partial: "resource_ns1/chat_rooms/chat_article", locals: {chat_article: chat_article})

      # それを全員に通知
      # 各自の chat_room.js の received メソッドに引数が渡る
      attributes = chat_article.attributes.merge(chat_user: chat_article.chat_user.attributes, chat_room: chat_article.chat_room.attributes)
      ActionCable.server.broadcast("chat_room_channel_#{params[:chat_room_id]}", chat_article: attributes)
    end
  end

  # わざわざ ruby 側に戻してブロードキャストする意味がない気がする
  # JavaScript 側でそのまま自分以外にブロードキャストできればそれにこしたことはない → たぶん方法はある
  def kifu_body_sfen_broadcast(data)
    # Rails.logger.debug(["#{__FILE__}:#{__LINE__}", __method__, data["current_chat_user"]["id"]])
    # Rails.logger.debug(["#{__FILE__}:#{__LINE__}", __method__, current_chat_user.id])
    # if data["current_chat_user"]["id"] == current_chat_user.id
    #   # 駒音が重複するため自分にはブロードキャストしない
    # else
    # end
    ActionCable.server.broadcast("chat_room_channel_#{params[:chat_room_id]}", data)
  end

  def room_name_changed(data)
    chat_room = ChatRoom.find(params[:chat_room_id])
    chat_room.update!(name: data["room_name"])
    ActionCable.server.broadcast("chat_room_channel_#{params[:chat_room_id]}", data)
  end

  def room_in(data)
    chat_room = ChatRoom.find(data["chat_room"]["id"])
    chat_user = ChatUser.find(data["current_chat_user"]["id"])
    unless chat_room.chat_users.include?(chat_user)
      chat_room.chat_users << chat_user
    end
    ActionCable.server.broadcast("chat_room_channel_#{params[:chat_room_id]}", online_chat_users: chat_room.chat_users)
  end

  def room_out(data)
    chat_room = ChatRoom.find(data["chat_room"]["id"])
    chat_user = ChatUser.find(data["current_chat_user"]["id"])
    # chat_room.chat_users.destroy(alice)

    ActionCable.server.broadcast("chat_room_channel_#{params[:chat_room_id]}", online_chat_users: chat_room.chat_users)
  end
end
