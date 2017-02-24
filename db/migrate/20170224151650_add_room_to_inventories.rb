class AddRoomToInventories < ActiveRecord::Migration[5.0]
  def change
    add_column :inventories, :room, :string
  end
end
