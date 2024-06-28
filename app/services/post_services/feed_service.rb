# frozen_string_literal: true

module PostServices
  class FeedService
    INIT_ELEMENT = 'init'

    def initialize(user_id:, page:, per_page:)
      @user_id = user_id
      @page = page
      @per_page = per_page
      @key = "feed::#{user_id}"
    end

    def self.call(user_id:, page:, per_page:)
      new(user_id:, page:, per_page:).call
    end

    def call
      return { success: true, result: fetch_cache(key), error: nil } if Red.exists(key) != 0

      posts = PostQueries.new(user_id:).feed.map(&:to_json)
      init_feed_cache(key)
      return { success: true, result: [], error: nil } if posts.empty?

      Red.lpushx(key, posts.reverse)

      { success: true, result: posts, error: nil }
    end

    private

    def init_feed_cache(key)
      Red.lpush(key, INIT_ELEMENT)
      Red.expire(key, 60 * 60 * 24)
    end

    def fetch_cache(key)
      start_i = per_page * (page - 1)
      end_i = (start_i + per_page) - 1
      posts = Red.lrange(key, start_i, end_i) - [INIT_ELEMENT]
      Red.expire(key, 60 * 60 * 24)
      posts
    end

    attr_reader :user_id, :page, :per_page, :key
  end
end
