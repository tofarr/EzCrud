class CreateJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_join_table :categories, :doohickeys do |t|
      t.index [:category_id, :doohickey_id]
      t.index [:doohickey_id, :category_id]
    end
  end
end
