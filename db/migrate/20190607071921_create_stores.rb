class CreateStores < ActiveRecord::Migration[5.2]
  def change
    create_table :stores do |t|
      t.string :code
      t.string :name
      t.string :baseidd
      t.string :region
      t.string :idd
      t.string :time_start
      t.string :time_end
      t.string :opening_date
      t.string :zone
      t.string :s_stat
      t.string :phone
      t.string :phoneext
      t.string :email
      t.string :addr

      t.timestamps
    end
  end
end
