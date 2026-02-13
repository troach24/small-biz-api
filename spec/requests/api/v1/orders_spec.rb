require "rails_helper"

RSpec.describe "API V1 Orders", type: :request do
  describe "POST /api/v1/orders" do
    it "creates an order" do
      post "/api/v1/orders", params: {
        order: {
          customer_name: "Test User",
          total_cents: 1000
        }
      }

      expect(response).to have_http_status(:created)

      body = JSON.parse(response.body)
      expect(body["customer_name"]).to eq("Test User")
      expect(body["sync_status"]).to eq("pending")
    end
  end

  describe "POST /api/v1/orders/:id/sync" do
    let!(:order) do
      Order.create!(
        customer_name: "Sync Test",
        total_cents: 2000
      )
    end

    it "enqueues a SyncOrderJob" do
      expect {
        post "/api/v1/orders/#{order.id}/sync"
      }.to have_enqueued_job(SyncOrderJob)

      expect(response).to have_http_status(:accepted)

      body = JSON.parse(response.body)
      expect(body["enqueued"]).to eq(true)
    end

    it "does not enqueue if already synced" do
      order.update!(sync_status: "synced")

      expect {
        post "/api/v1/orders/#{order.id}/sync"
      }.not_to have_enqueued_job(SyncOrderJob)

      expect(response).to have_http_status(:ok)
    end

    it "performs the sync job and updates the order" do
      perform_enqueued_jobs do
        post "/api/v1/orders/#{order.id}/sync"
        expect(response).to have_http_status(:accepted)
      end

      order.reload
      expect(order.sync_status).to eq("synced")
      expect(order.external_id).to be_present
      expect(order.last_synced_at).to be_present
      expect(order.last_sync_error).to be_nil
    end
  end
end
