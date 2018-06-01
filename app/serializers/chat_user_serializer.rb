class ChatUserSerializer < ApplicationSerializer
  attributes *[
    :id,
    :name,
    :avatar_url,

    :online_at,
    :fighting_now_at,
    :matching_at,
    :lifetime_key,
    :ps_preset_key,
    :po_preset_key,
  ]

  belongs_to :current_chat_room
end
