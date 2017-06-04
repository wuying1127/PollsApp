class Response < ActiveRecord::Base
  validates :respondent, :answer_choice, presence: true

  belongs_to :respondent,
    primary_key: :id,
    foreign_key: :respondent_id,
    class_name: 'User'

  belongs_to :answer_choice
  has_one :question, through: :answer_choice

  validate :author_can_not_respond_to_own_poll
  validate :respondent_has_not_already_answered_question

  def sibling_responses
    self.question.responses.where.not(id: self.id)
  end

  private
  def author_can_not_respond_to_own_poll
    poll = Poll
      .joins(:questions)
      .where(questions: { id: self.question.id })
      .pluck(:author_id)
      .first

    if self.respondent_id == poll
      errors[:respondent_id] << "cannot be poll author"
    end
  end

  def respondent_has_not_already_answered_question
    if sibling_responses.exists?(respondent_id: self.respondent_id)
      errors[:respondent_id] << "cannot vote twice for question"
    end
  end


end
