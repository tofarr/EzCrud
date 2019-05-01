class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.text :message
      t.references :doohickey, index: true, foreign_key: true

      t.timestamps
    end
  end
end
