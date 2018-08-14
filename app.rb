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
  p @info
  erb :sign_in
end

post "/sign-in" do
  @@info = "Welcome!"
  @user = User.find_by(username: params[:username])
  
  if @user && @user.password == params[:password]
    session[:user_id] = @user.id

    @@info = "You have been signed in"

    redirect "/"
    p @info
  else

     @@info = "Your username or password is incorrect"
    p @info
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

get '/profile' do
  @user_id = session[:user_id]
  @profile = User.find_by(id: session[:user_id])
  @users_article = User.find(@user_id).articles
  p @users_article
  p @profile
  erb :profile
end

get '/users/:id/edit' do 
  if session[:user_id] == params[:id]
    @profile = User.find_by(id: params[id])
    
  else
    "<h1>Errorr 404!!</h1>"
  end
end

get '/blog' do
  @article = Article.all
erb :blog
end

get '/blog/edit' do

end


def get_current_user 
  User.find(session[:user_id])
end