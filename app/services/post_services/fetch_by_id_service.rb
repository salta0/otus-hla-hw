# frozen_string_literal: true

module PostServices
  class FetchByIdService
    def initialize(id)
      @id = id
    end

    def self.call(id)
      new(id).call
    end

    def call
      post = PostQueries.new({ name: :id, value: id.to_i }).find
      { success: true, result: post, error: nil }
    end

    private

    attr_reader :id
  end
end
