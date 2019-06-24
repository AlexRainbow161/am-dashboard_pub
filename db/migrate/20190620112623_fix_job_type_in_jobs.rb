class FixJobTypeInJobs < ActiveRecord::Migration[5.2]
  def change
    change_column :jobs, :job_type, :integer
    rename_column :jobs, :job_type, :job_type_id
  end
end
