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

# get '/users/:id/edit' do 
#   if session[:user_id] == params[:id]
#     @profile = User.find_by(id: params[id])
    
#   else
#     "<h1>Errorr 404!!</h1>"
#   end
# end
get '/profile/:id/edit' do
@current_user = User.find(params[:id])
erb :profile_edit
end

put '/profile/:id' do 
  @current_user= User.find(params[:id])
  @current_user.update(name: params[:name], last_name: params[:lastname], username: params[:username], password: params[:password], email: params[:email], birthday: params[:birthday], image: params[:image])
 
  redirect '/profile'
end

get '/profile/delete/:id' do
  user_id= params[:id]
  @user = User.find(user_id)
  @user.destroy
  session[:user_id] = nil
 redirect '/'
end

get '/blog' do
  @article = Article.all
erb :blog
end

get '/blog/:id/edit' do
  @current_article= Article.find(params[:id])
  erb :blog_edit
end
put '/blog/:id' do 
  @current_article= Article.find(params[:id])
  @current_article.update(title: params[:title], image: params[:image], text_content: params[:text_content], user_id: session[:user_id], article_date: params[:article_date])
  redirect '/profile'
end
# get '/blog/:id/delete' do
#   @current_article= Article.find(params[:id])
  
# end
get '/blog/delete/:id' do 
  # @current_article = Article.find(params[:id])
  # @current_darticle.destroy
  article_id= params[:id]
   Article.delete(article_id)
  redirect '/profile'
end


get '/blog/new' do 
  erb :blog_new
end

post '/profile' do 
  Article.create(title: params[:title], image: params[:image], text_content: params[:text_content], user_id: session[:user_id], article_date: params[:article_date])
  redirect '/profile'
end

def get_current_user 
  User.find(session[:user_id])
end