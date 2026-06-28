class Api::MessagesController < ApplicationController
  def index
    messages = current_user.received_messages.order(created_at: :desc)
    if params[:is_read].present?
      messages = params[:is_read] == 'true' ? messages.read : messages.unread
    end
    messages = messages.page(pagination_params[:page]).per(pagination_params[:per_page])
    render_paginated(messages, MessageBlueprint)
  end

  def show
    message = current_user.received_messages.find(params[:id])
    message.mark_as_read! unless message.is_read?
    data = MessageBlueprint.render_as_hash(message)
    render_success(data)
  end

  def mark_as_read
    message = current_user.received_messages.find(params[:id])
    message.mark_as_read!
    data = MessageBlueprint.render_as_hash(message)
    render_success(data, '已标记为已读')
  end

  def mark_all_as_read
    current_user.received_messages.unread.update_all(is_read: true)
    render_success(nil, '已全部标记为已读')
  end

  def unread_count
    count = current_user.received_messages.unread.count
    render_success({ count: count })
  end
end
