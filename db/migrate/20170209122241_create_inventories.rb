class CreateInventories < ActiveRecord::Migration[5.0]
  def change
    create_table :inventories do |t|
      t.string :AssetTag
      t.string :Model
      t.string :Serial
      t.text :Description
      t.string :Location
      t.string :POC
      t.text :Disposition
      t.string :Win7
      t.string :Office
      t.string :Access
      t.string :Visio
      t.string :Project

      t.timestamps
    end
  end
end
