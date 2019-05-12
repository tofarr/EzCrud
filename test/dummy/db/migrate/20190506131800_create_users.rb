class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email
      t.string :homepage
      t.string :password_digest
      t.datetime :dob
      t.string :favorite_color
      t.string :dinner_choice
      t.json :settings

      t.timestamps
    end
  end
end
