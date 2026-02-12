# app/services/external/order_syncer.rb
require "securerandom"

module External
  class OrderSyncer
    def initialize(order)
      @order = order
    end

    def call
      # Simulate a real integration call.
      # Flip this env var to test failure paths:
      # SYNC_FAIL=1 bundle exec sidekiq ...
      raise "Simulated external sync failure" if ENV["SYNC_FAIL"] == "1"

      sleep 0.2

      {
        external_id: @order.external_id.presence || "ext_#{SecureRandom.hex(8)}"
      }
    end
  end
end
