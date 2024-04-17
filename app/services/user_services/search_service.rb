# frozen_string_literal: true

module UserServices
  class SearchService
    class FirstNameIsBlankError < StandardError
      def message
        'First name is blank'
      end
    end

    class LastNameIsBlankError < StandardError
      def message
        'Last name is blank'
      end
    end

    LIMIT = 100

    def initialize(params)
      @params = params
    end

    def self.call(params)
      new(params).call
    end

    def call
      validate!

      res = UserQueries.new(params.slice(:first_name, :last_name)).search_by_name_prefix(LIMIT)

      { success: true, result: res, error: nil }
    rescue FirstNameIsBlankError, LastNameIsBlankError => e
      { success: false, result: nil, error: e }
    end

    private

    attr_reader :params

    def validate!
      raise FirstNameIsBlankError if params[:first_name].to_s.gsub(' ', '').empty?
      raise LastNameIsBlankError if params[:last_name].to_s.gsub(' ', '').empty?
    end
  end
end
