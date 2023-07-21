class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.datetime :release, null: false

      t.timestamps
    end
  end
end
