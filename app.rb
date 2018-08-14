require 'sinatra'

require 'sinatra/activerecord'
require 'sinatra/reloader'



set :database, {adapter: 'postgresql', database: 'r_mblr'}

get '/' do
    if session[:user_id]
        @status = "signed in"
        erb :signed
      else
        @status = "signed out"
        erb :signed
      end

end