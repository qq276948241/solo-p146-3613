class JwtService
  SECRET_KEY = Rails.application.secret_key_base
  ALGORITHM = 'HS256'.freeze
  EXPIRATION_TIME = 7.days.to_i

  def self.encode(payload, exp = EXPIRATION_TIME.from_now.to_i)
    payload[:exp] = exp
    JWT.encode(payload, SECRET_KEY, ALGORITHM)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY, true, algorithm: ALGORITHM)
    HashWithIndifferentAccess.new(decoded.first)
  rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
    nil
  end
end
