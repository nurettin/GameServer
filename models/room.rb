class Room < Sequel::Model
  set_schema do
    primary_key :id
    Integer :game_id
    Time :created_at
    Time :updated_at
  end

  many_to_one :game
  one_to_many :tables

  create_table unless table_exists?
end