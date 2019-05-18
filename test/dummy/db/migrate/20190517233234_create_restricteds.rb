class CreateRestricteds < ActiveRecord::Migration[5.2]
  def change
    create_table :restricteds do |t|
      t.timestamps
    end
  end
end
