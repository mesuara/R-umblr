require 'sinatra'

require 'sinatra/activerecord'
require 'sinatra/reloader'
require './models/user'
require './models/article_tag'
require './models/article'
require './models/tag'




set :database, {adapter: 'postgresql', database: 'r_mblr'}
enable :sessions
get '/' do
    if session[:user_id]
        @status = "signed in"
        erb :signed
      else
        @status = "signed out"
        erb :signed
      end

end

get "/sign-in" do
  erb :sign_in
end

post "/sign-in" do
  @info = "Welcome!"
  @user = User.find_by(username: params[:username])
  
  if @user && @user.password == params[:password]
    session[:user_id] = @user.id

    @info = "You have been signed in"

    redirect "/"
  else

     @info = "Your username or password is incorrect"

    redirect "/sign-in"
  end
end


get "/sign-up" do
  erb :sign_up
end

post "/sign-up" do
  @user = User.create(
    username: params[:username],
    password: params[:password],
    name: params[:name],
    last_name: params[:lastname],
    birthday: params[:birthday],
    email: params[:email]
  )

  
  session[:user_id] = @user.id

  redirect "/"
end



get "/sign-out" do

  session[:user_id] = nil
  
  redirect "/"
end


get '/users/:id/edit' do 
  if session[:user_id] == params[:id]
    #Access thier user profile edit page
  else
    #Redirect them and tell them they do not have access to edit other peoples profile pages
  end
end

get '/blog' do
erb :blog
end