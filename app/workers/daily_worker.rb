class DailyWorker
  include Sidekiq::Worker

  def perform
    User.send_daily_digest
  end
end