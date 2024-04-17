# frozen_string_literal: true

require 'sinatra'
require 'multi_json'

require_relative 'initialize'
require_relative 'services/user_services'

set :show_exceptions, false

before do
  content_type :json

  unless ['/user/register', '/login'].include?(request.path_info)
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

post '/login' do
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
  MultiJson.dump(users.map { |u| u.slice(*%w[id first_name last_name birthdate biography city]) })
end

error StandardError do
  halt 500, MultiJson.dump({ error: 'Some error occured' })
end
