class CreateDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :documents do |t|
      t.string :description
      t.date :expiry_date
      t.string :link
      t.string :key

      t.timestamps
    end
  end
end
