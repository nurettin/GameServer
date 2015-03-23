get '/user/register' do
  erb :user_register
end

post '/user/register' do
  User.create params[:user]
  current_user = user
  redirect '/games'
end

get '/user/login' do
  erb :user_login
end

post '/user/login' do
  user = User[login: params[:login]]
  if user.nil?
    halt 403
    return
  end
  unless user.valid_password? params[:password]
    halt 403
    return
  end
  current_user = user
  redirect '/games'
end

get '/user/logout' do
  current_user = nil
  redirect '/user/login'
end

get '/room' do
  protect! '/user/login'
  erb :room
end

get '/table/:id' do
  protect! '/user/login'
  return erb :table unless request.websocket?
  if request.websocket?
    request.websocket do |ws|
      ws.onopen do |ws|
        settings.socks[current_user.id] = ws
      end
      ws.onmessage do |ws|

      end
      ws.onclose do |ws|
        settings.socks.delete current_user.id
      end
    end
  end
end
