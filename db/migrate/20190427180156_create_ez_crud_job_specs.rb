class CreateEzCrudJobSpecs < ActiveRecord::Migration[5.2]
  def change
    create_table :ez_crud_job_specs do |t|
      t.string :type, limit: 50
      t.string :model_type, limit:50
      t.text :search
      t.text :updates

      t.timestamps
    end
  end
end
