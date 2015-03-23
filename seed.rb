require './env'

if User.count == 0
  user = User.new login: 'admin', role: 'admin'
  user.password_salt = BCrypt::Engine.generate_salt
  user.password_hash = BCrypt::Engine.hash_secret("admin#{Time.now.year}", user.password_salt)
  user.save
  (1..10).each do |number|
    user = User.new login: "player#{number}", role: 'player'
    user.password_salt = BCrypt::Engine.generate_salt
    user.password_hash = BCrypt::Engine.hash_secret("player#{number}", user.password_salt)
  end
end

if Game.count== 0
  game= Game.create settings: '{ name: "backgammon", timeout: 120, global_timeout: 240 }'
  room= Room.create game: game
  Table.create room: room
end
