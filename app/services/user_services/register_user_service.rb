# frozen_string_literal: true

module UserServices
  class RegisterUserService
    class ValidationErrors < StandardError
    end

    PSWD_REGEX = /^(?=.*[a-zA-Z])(?=.*[0-9]).{6,}$/

    def initialize(params)
      @params = params
    end

    def self.call(params)
      new(params).call
    end

    def call
      validate!

      UserQueries.new(build_user_params).insert

      { success: true, result: user_id, error: nil }
    rescue ValidationErrors => e
      { success: false, result: nil, error: e }
    end

    private

    attr_reader :params

    def validate!
      raise ValidationErrors, 'First name is blank' if params[:first_name].to_s.gsub(' ', '').empty?
      raise ValidationErrors, 'Second name is blank' if params[:last_name].to_s.gsub(' ', '').empty?
      raise ValidationErrors, 'Invalid password' unless PSWD_REGEX.match?(params[:password])
    end

    def build_user_params
      profile_info = params.slice(:first_name, :last_name, :birthdate, :biography, :city).reject do |_, v|
        v.to_s.empty?
      end
      id = user_id
      password = BCrypt::Password.create(params[:password])
      profile_info.merge({ id:, password: })
    end

    def user_id
      @user_id ||= SecureRandom.uuid
    end
  end
end
