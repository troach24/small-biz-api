class SyncOrderJob < ApplicationJob
  queue_as :integrations

  def perform(order_id)
    order = Order.find(order_id)
    
    return if order.sync_status == "synced"
    
    Rails.logger.info "Syncing Order ##{order.id}"

    order.update!(
      sync_status: "syncing",
      last_sync_error: nil
    )

    result = External::OrderSyncer.new(order).call

    order.update!(
      sync_status: "synced",
      external_id: result.fetch(:external_id),
      last_synced_at: Time.current
    )
  rescue => e
    # keep it simple for now; Sidekiq retries automatically
    Order.where(id: order_id).update_all(
      sync_status: "failed",
      last_sync_error: "#{e.class}: #{e.message}"
    )
    raise
  end
end
