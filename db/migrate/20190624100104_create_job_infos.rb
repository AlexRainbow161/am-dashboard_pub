class CreateJobInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :job_infos do |t|
      t.integer :job_id

      t.timestamps
    end
  end
end
