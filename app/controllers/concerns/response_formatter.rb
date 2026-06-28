module ResponseFormatter
  extend ActiveSupport::Concern

  def render_success(data = nil, message = '操作成功', meta: nil)
    response = {
      code: 0,
      message: message,
      data: data
    }
    response[:meta] = meta if meta.present?
    render json: response
  end

  def render_paginated(collection, blueprint, view: :default, blueprint_options: {})
    meta = {
      current_page: collection.current_page,
      total_pages: collection.total_pages,
      total_count: collection.total_count,
      per_page: collection.limit_value
    }
    data = blueprint.render_as_hash(collection, view: view, **blueprint_options)
    render_success(data, '获取成功', meta: meta)
  end

  def pagination_params
    page = params[:page].to_i
    per_page = params[:per_page].to_i
    page = 1 if page <= 0
    per_page = [per_page, 1].max
    per_page = [per_page, 100].min
    { page: page, per_page: per_page }
  end
end
