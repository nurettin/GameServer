require 'sinatra-websocket'
require 'json/ext'

set :players, {}

get '/tictactoe' do
  erb :tictactoe
end

get '/tictactoe_sockets' do
  unless request.websocket?
    halt 400
    return
  end
  request.websocket do |ws|
    ws.onopen do
      if settings.players.count < 2
        (1..2).each do |i|
          if settings.players[i].nil?
            settings.players[i] = ws
            ws.send({action: "joined", player: i}.to_json)
            settings.players.reject{ |k, v| k== i}.each do |k, v|
              v.send({action: "opponent_joined", player: i}.to_json)
            end
            break
          end
        end
      end
    end
    ws.onclose do
      settings.players.reject!{ |_, v| v == ws }
    end
    ws.onmessage do |m|
      player, player_socket = settings.players.find{ |_, v| v== ws }
      if m.type == "move"
        settings.players.reject{ |_, v| v== player_socket }.each do |k, v|
          v.send({action: "move", player: player, index: m.index}.to_json)
        end
      elsif m.type == "chat"
        settings.players.reject{ |_, v| v== player_socket }.each do |k, v|
          v.send({action: "chat", player: player, message: m.message}.to_json)
        end
      end
    end
  end
end

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
