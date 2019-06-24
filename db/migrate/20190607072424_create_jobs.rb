class CreateJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :jobs do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.integer :store_id
      t.integer :user_id

      t.timestamps
    end
  end
end
