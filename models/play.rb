class Play < Sequel::Model
  set_schema do
    primary_key :id
    Integer :table_id
    Integer :user_id
    Time :created_at
    Time :updated_at
  end
  create_table?

  one_to_one :table
  one_to_one :user
end