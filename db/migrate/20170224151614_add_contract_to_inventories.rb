class AddContractToInventories < ActiveRecord::Migration[5.0]
  def change
    add_column :inventories, :contract, :string
  end
end
