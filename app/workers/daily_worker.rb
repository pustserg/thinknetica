class DailyWorker
  include Sidekiq::Worker
  include Sidetiq::Shedulable

  recurrence { daily(1) }

  def perform
    User.send_daily_digest
  end
end