class Game < Sequel::Model
  set_schema do
    primary_key :id
    String :settings, text: true
    Time :created_at
    Time :updated_at
  end

  one_to_many :rooms

  create_table unless table_exists?
end