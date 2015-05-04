class Game < Sequel::Model
  set_schema do
    primary_key :id
    String :settings, text: true
    Time :created_at
    Time :updated_at
  end
  create_table?

  one_to_many :rooms
end