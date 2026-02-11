class JobsController < ApplicationController
  def ping
    msg = params[:message] || "hello from api"
    PingJob.perform_later(msg)
    render json: { enqueued: true, message: msg }
  end
end
