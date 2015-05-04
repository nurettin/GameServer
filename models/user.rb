class User < Sequel::Model
  set_schema do
    primary_key :id
    String :login, unique: true
    String :password_hash
    String :password_salt
    String :role, default: 'user'
    Time :created_at
    Time :updated_at
  end
  create_table?

  one_to_many :plays
  many_to_many :tables, join_table: :plays

  def valid_password?(password)
    password_hash == BCrypt::Engine.hash_secret(password, password_salt)
  end
end
