class HardenOrdersSchema < ActiveRecord::Migration[8.1]
  class MigrationOrder < ActiveRecord::Base
    self.table_name = "orders"
    self.inheritance_column = :_type_disabled
  end

  def change
    change_column_default :orders, :status, "draft"
    change_column_default :orders, :sync_status, "pending"
    change_column_default :orders, :currency, "USD"
    change_column_default :orders, :total_cents, 0

    reversible do |dir|
      dir.up do
        MigrationOrder.reset_column_information

        MigrationOrder.where(status: nil).update_all(status: "draft")
        MigrationOrder.where(sync_status: nil).update_all(sync_status: "pending")
        MigrationOrder.where(currency: nil).update_all(currency: "USD")
        MigrationOrder.where(total_cents: nil).update_all(total_cents: 0)
      end
    end

    change_column_null :orders, :customer_name, false
    change_column_null :orders, :status, false
    change_column_null :orders, :sync_status, false
    change_column_null :orders, :currency, false
    change_column_null :orders, :total_cents, false

    add_index :orders, :sync_status unless index_exists?(:orders, :sync_status)
    add_index :orders, :status unless index_exists?(:orders, :status)

    add_index :orders, :external_id,
              unique: true,
              where: "external_id IS NOT NULL" unless index_exists?(:orders, :external_id)
  end
end
