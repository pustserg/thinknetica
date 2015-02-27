class KarmaCalculator

  def self.calculate(user)
    # when user creates answer he gets +1 karma
    # when user's question get vote +, user gets +2 karma
    # when user's answer get vote +, user gets +1 karma
    # when user's question gets vote -, user gets -2 karma
    # when user's answer gets vote -, user gets -1 karma
    # when user's answer marked as best, user gets +3 karma
    # if user's answer is the first, he gets +1 karma
    # if user's answer is the first and answer is for user's question, he gets +3 karma
    # if user answers for his question, but not first, he gets +2 karma
    
    likes_sum = 0
    # likes_sum += user.answers.count
    likes_sum += 2 * user.likes[:question].count
    likes_sum += user.likes[:answer].count
    
    user.answers.each do |answer|
      likes_sum += 3 if answer.best?
      likes_sum += 1 if answer.question.first_answer == answer && answer.question.user != user
      likes_sum += 3 if answer.question.user == user && answer.question.first_answer == answer
      likes_sum += 2 if answer.question.user == user && answer.question.first_answer != answer
      likes_sum += 1 if answer.question.user != user
    end

    dislikes_sum = 0
    dislikes_sum += 2 * user.dislikes[:question].count
    dislikes_sum += user.dislikes[:answer].count

    user.update!(karma: likes_sum - dislikes_sum)
  end

end