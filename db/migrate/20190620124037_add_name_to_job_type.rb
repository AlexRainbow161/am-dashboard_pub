class AddNameToJobType < ActiveRecord::Migration[5.2]
  def change
    add_column :job_types, :name, :string
  end
end
