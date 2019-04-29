class CreateEzCrudDoohickeys < ActiveRecord::Migration[5.2]
  def change
    create_table :ez_crud_doohickeys do |t|
      t.string :title
      t.float :weight
      t.integer :amount
      t.boolean :available
      t.text :description

      t.timestamps
    end
  end
end
