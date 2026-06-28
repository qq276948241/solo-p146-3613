module ErrorResponses
  extend ActiveSupport::Concern

  ERROR_CODES = {
    unauthorized: { code: 401001, message: '未授权或登录已过期' },
    invalid_token: { code: 401002, message: '无效的token' },
    login_failed: { code: 401003, message: '手机号或密码错误' },
    forbidden: { code: 403001, message: '没有权限执行该操作' },
    not_found: { code: 404001, message: '资源不存在' },
    validation_error: { code: 422001, message: '参数验证失败' },
    duplicate_application: { code: 422002, message: '您已提交过该宠物的领养申请' },
    pet_not_listed: { code: 422003, message: '该宠物当前不可领养' },
    cannot_apply_own_pet: { code: 422004, message: '不能申请自己登记的宠物' },
    application_not_pending: { code: 422005, message: '该申请状态不允许此操作' },
    phone_taken: { code: 422006, message: '该手机号已被注册' },
    internal_error: { code: 500001, message: '服务器内部错误' }
  }.freeze

  def render_error(error_key, detail: nil, status: :unprocessable_entity)
    error = ERROR_CODES[error_key] || ERROR_CODES[:internal_error]
    response = {
      code: error[:code],
      message: error[:message],
      data: nil
    }
    response[:detail] = detail if detail.present?
    render json: response, status: status
  end

  def render_validation_error(record)
    errors = record.errors.messages.transform_values { |v| v.join(', ') }
    render json: {
      code: ERROR_CODES[:validation_error][:code],
      message: ERROR_CODES[:validation_error][:message],
      errors: errors,
      data: nil
    }, status: :unprocessable_entity
  end
end
