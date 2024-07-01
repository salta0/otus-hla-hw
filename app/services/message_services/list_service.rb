# frozen_string_literal: true

module MessageServices
  class ListService
    # class AlreadyFriendError < StandardError
    def initialize(from_id:, to_id:, page:, per_page:)
      @from_id = from_id
      @to_id = to_id
      @page = page
      @per_page = per_page 
    end

    def self.call(from_id:, to_id:, page:, per_page:)
      new(from_id:, to_id:, page:, per_page:).call
    end

    def call
      dialog_id = Digest::MD5.hexdigest([from_id, to_id].sort.join('-'))
      limit = per_page
      offset = per_page * (page - 1)
      res = MessageQueries.new(dialog_id: dialog_id, limit: limit, offset: offset).list
      
      { success: true, result: res, error: nil } 
    end

    private

    attr_reader :from_id, :to_id, :page, :per_page

    def calculate_dialog_id(from_id, to_id)
      Digest::MD5.hexdigest([from_id, to_i].sort.join('-'))
    end
  end
end