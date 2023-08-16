class CreateCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :url
      t.string :endpoint
      t.string :bucket

      t.timestamps
    end
  end
end
