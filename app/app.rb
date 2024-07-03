# frozen_string_literal: true

require 'sinatra'
require 'multi_json'

require_relative 'initialize'
require_relative 'services/user_services'
require_relative 'services/post_services'
require_relative 'services/message_services'
require_relative 'services/thread_services'

set :show_exceptions, false

before do
  content_type :json

  unless ['/user/register', '/login'].include?(request.path_info)
    halt 401, MultiJson.dump({ error: 'Unathorized' }) unless env.key?('HTTP_AUTHORIZATION')

    token = env.fetch('HTTP_AUTHORIZATION').to_s.split(' ').last
    res = UserServices::AuthByTokenService.call(token)
    halt 401, MultiJson.dump({ error: 'Unathorized' }) unless res[:success]

    @current_user = res[:result]
  end
end

post '/user/register' do
  user_params = MultiJson.load request.body.read, symbolize_keys: true
  res = UserServices::RegisterUserService.call(user_params)
  halt 400, MultiJson.dump({ error: res[:error].message }) unless res[:success]

  status 201
  MultiJson.dump({ id: res[:result] })
end

post '/user/login' do
  user_params = MultiJson.load request.body.read, symbolize_keys: true
  res = UserServices::LoginUserService.call(user_params[:id], user_params[:password])
  halt 401, MultiJson.dump({ error: res[:error].message }) unless res[:success]

  MultiJson.dump({ access_token: res[:result] })
end

get '/user/get/:id' do
  res = UserServices::FetchByIdService.call(params[:id])
  halt 400, MultiJson.dump({ error: res[:error].message }) unless res[:success]

  user = res[:result]
  halt 404, MultiJson.dump({ error: 'Not found' }) if user.nil?

  MultiJson.dump(user.slice(*%w[id first_name last_name birthdate biography city]))
end

get '/user/search' do
  res = UserServices::SearchService.call(params)
  halt 400, MultiJson.dump({ error: res[:error].message }) unless res[:success]

  users = res[:result]
  MultiJson.dump(users)
end

post '/friend/:id/add' do
  user = @current_user
  res = UserServices::FetchByIdService.call(params[:id])
  halt 400, MultiJson.dump({ error: res[:error].message }) unless res[:success]

  friend = res[:result]
  halt 404, MultiJson.dump({ error: 'Not found' }) if user.nil?

  res = UserServices::AddFriendService.call(user:, friend:)
  halt 400, MultiJson.dump({ error: res[:error].message }) unless res[:success]

  status 200
end

delete '/friend/:id' do
  user = @current_user
  res = UserServices::FetchByIdService.call(params[:id])
  halt 400, MultiJson.dump({ error: res[:error].message }) unless res[:success]

  friend = res[:result]
  halt 404, MultiJson.dump({ error: 'Not found' }) if user.nil?

  UserServices::RemoveFriendService.call(user:, friend:)
  status 200
end

get '/friends' do
  user = @current_user
  res = UserServices::FetchFriendsService.call(user['id'])
  friends = res[:result]

  MultiJson.dump(friends)
end

post '/posts' do
  user = @current_user
  post_params = MultiJson.load request.body.read, symbolize_keys: true
  res = PostServices::AddService.call(user:, body: post_params[:body])
  halt 400, MultiJson.dump({ error: res[:error].message }) unless res[:success]

  MultiJson.dump({ post: res[:result] })
end

get '/posts' do
  user = @current_user
  res = PostServices::ListService.call(user:)

  MultiJson.dump({ post: res[:result] })
end

get '/posts/:id' do
  res = PostServices::FetchByIdService.call(params[:id])
  post = res[:result]
  halt 404 if post.nil?

  MultiJson.dump({ post: res[:result] })
end

put '/posts/:id' do
  user = @current_user
  post_params = MultiJson.load request.body.read, symbolize_keys: true

  res = PostServices::FetchByIdService.call(params[:id])
  post = res[:result]
  halt 404 if post.nil?

  res = PostServices::UpdateService.call(user:, body: post_params[:body], post:)
  halt 400, MultiJson.dump({ error: res[:error].message }) unless res[:success]

  MultiJson.dump({ post: res[:result] })
end

delete '/posts/:id' do
  user = @current_user

  res = PostServices::FetchByIdService.call(params[:id])
  post = res[:result]
  halt 404 if post.nil?

  res = PostServices::DeleteService.call(user:, post:)
  halt 400, MultiJson.dump({ error: res[:error].message }) unless res[:success]

  MultiJson.dump({ post: res[:result] })
end

get '/feed' do
  user = @current_user

  res = PostServices::FeedService.call(user_id: user['id'],
                                       page: params[:page].to_i,
                                       per_page: params[:per_page].to_i)
  posts = res[:result]

  MultiJson.dump(posts.map { |r| MultiJson.load(r) })
end

post '/dialog/:user_id/send' do
  res = UserServices::FetchByIdService.call(params[:user_id])
  halt 400, MultiJson.dump({ error: res[:error].message }) unless res[:success]

  user = res[:result]
  halt 404, MultiJson.dump({ error: 'Not found' }) if user.nil?

  message_params = MultiJson.load request.body.read, symbolize_keys: true
  thread_id = if message_params[:thread_id].nil?
                res = ThreadServices::FetchService.new(from_id: @current_user['id'], to_id: user['id']).call
                if res[:result].nil?
                  res = ThreadServices::CreateService.new(from_id: @current_user['id'], to_id: user['id']).call
                  halt 400, MultiJson.dump({ error: res[:error].message }) unless res[:success]
                end
                res[:result]['id']
              else
                message_params[:thread_id]
              end

  res = MessageServices::SendService.call(from_id: @current_user['id'],
                                          to_id: user['id'],
                                          thread_id:,
                                          body: message_params[:body])
  halt 400, MultiJson.dump({ error: res[:error].message }) unless res[:success]

  MultiJson.dump({ message: res[:result] })
end

get '/dialog/:user_id' do
  res = UserServices::FetchByIdService.call(params[:user_id])
  halt 400, MultiJson.dump({ error: res[:error].message }) unless res[:success]

  user = res[:result]
  halt 404, MultiJson.dump({ error: 'Not found' }) if user.nil?

  thread_id = begin
    if params[:thread_id].nil?
      res = ThreadServices::FetchService.new(from_id: @current_user['id'], to_id: user['id']).call
      res[:result]['id']
    else
      message_params[:thread_id]
    end
  rescue StandardError
    nil
  end

  return MultiJson.dump([]) if thread_id.nil?

  res = MessageServices::ListService.call(thread_id:,
                                          page: params[:page].to_i,
                                          per_page: params[:per_page].to_i)

  MultiJson.dump(res[:result])
end

error StandardError do
  halt 500, MultiJson.dump({ error: 'Some error occured' })
end
