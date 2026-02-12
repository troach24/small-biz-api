class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.string :customer_name
      t.string :status
      t.integer :total_cents
      t.string :currency
      t.string :sync_status
      t.string :external_id
      t.datetime :last_synced_at
      t.text :last_sync_error

      t.timestamps
    end
  end
end
