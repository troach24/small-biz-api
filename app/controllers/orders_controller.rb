class OrdersController < ApplicationController
  def index
    orders = Order.order(created_at: :desc)
    render json: orders
  end

  def show
    render json: order
  end

  def create
    o = Order.new(order_params)
    if o.save
      render json: o, status: :created
    else
      render json: { error: "validation_failed", details: o.errors }, status: :unprocessable_entity
    end
  end

  def update
    if order.update(order_params)
      render json: order
    else
      render json: { error: "validation_failed", details: order.errors }, status: :unprocessable_entity
    end
  end

  # POST /orders/:id/sync
  # Enqueues a Sidekiq job and returns immediately.
  def sync
    order.update!(sync_status: "pending", last_sync_error: nil)
    SyncOrderJob.perform_later(order.id)

    render json: { enqueued: true, order_id: order.id }, status: :accepted
  end

  private

  def order
    @order ||= Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:customer_name, :status, :total_cents, :currency)
  end
end
