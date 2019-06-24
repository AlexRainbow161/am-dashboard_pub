class AddTypeAndStoreCodeToJobs < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :job_type, :string
    add_column :jobs, :store_code, :string
    remove_column :jobs, :store_id
  end
end
