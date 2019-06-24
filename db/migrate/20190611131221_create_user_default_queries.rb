class CreateUserDefaultQueries < ActiveRecord::Migration[5.2]
  def change
    create_table :user_default_queries do |t|
      t.string :query_type
      t.string :query_data
      t.integer :user_id

      t.timestamps
    end
  end
end
