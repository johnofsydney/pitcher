class AddStrategyToCustomers < ActiveRecord::Migration[7.0]
  def change
    add_column :customers, :strategy, :string
  end
end
