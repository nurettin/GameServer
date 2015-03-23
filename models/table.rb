class Table < Sequel::Model
  set_schema do
    primary_key :id
    Integer :room_id
    Time :closed_at
    Time :created_at
    Time :updated_at
  end

  one_to_many :plays
  many_to_many :users
  many_to_one :room

  create_table unless table_exists?

  def join(user)
    plays.create user: user
  end
end
