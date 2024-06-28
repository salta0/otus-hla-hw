# frozen_string_literal: true

require_relative '../services/user_services'
require_relative '../services/post_services'

class AddPostJob
  include Sidekiq::Job
  sidekiq_options queue: 'posts'

  def perform(user_id, post_id)
    post = PostServices::FetchByIdService.call(post_id)[:result]
    friends = UsersFriendQueries.new(friend_id: user_id).list_subscribes
    friends.each do |friend|
      r_key = "feed::#{friend['user_id']}"
      if Red.exists(r_key) != 0
        Red.lpush(r_key, post.to_json)
        Red.ltrim(r_key, 0, 999) if Red.llen(r_key) > 1000
      end
    end
  end
end
