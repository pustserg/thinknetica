class KarmaObservers < ActiveRecord::Observer

  observe :question, :answer, :vote

  def after_create(question)
    question.user.delay.calculate_karma
  end

  def after_create(answer)
    answer.user.delay.calculate_karma
  end

  def after_create(vote)
    vote.votable.user.delay.calculate_karma
  end

end