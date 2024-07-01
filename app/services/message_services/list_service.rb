# frozen_string_literal: true

module MessageServices
  class ListService
    def initialize(thread_id:, page:, per_page:)
      @thread_id = thread_id
      @page = page
      @per_page = per_page
    end

    def self.call(thread_id:, page:, per_page:)
      new(thread_id:, page:, per_page:).call
    end

    def call
      limit = per_page
      offset = per_page * (page - 1)
      res = MessageQueries.new(thread_id:, limit:, offset:).list

      { success: true, result: res, error: nil }
    end

    private

    attr_reader :thread_id, :page, :per_page
  end
end
