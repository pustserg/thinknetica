class KarmaObservers < ActiveRecord::Observer

  observe :answer, :vote

  def after_save(record)
    obj = record.is_a?(Answer) ? record : record.voteable
    KarmaCalculator.delay.calculate(obj.user)    
  end

end