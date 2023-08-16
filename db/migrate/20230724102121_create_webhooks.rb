class CreateWebhooks < ActiveRecord::Migration[7.0]
  def change
    create_table :webhooks do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :document, null: false, foreign_key: true
      t.text :token

      t.timestamps
    end
  end
end
