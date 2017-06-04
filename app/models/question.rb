class Question < ActiveRecord::Base
  validates :poll, :text, presence: true

  belongs_to :poll
  has_many :answer_choices,
    primary_key: :id,
    foreign_key: :question_id,
    class_name: 'AnswerChoice'

  has_many :responses, through: :answer_choices

  def n_plus_one_results
    all_choices = self.answer_choices

    results = {}
    all_choices.each do |choice|
      results[choice.text] = choice.responses.count
    end

    results
  end

  def results_2_queries
    all_choices = self.answer_choices.includes(:responses)

    results = {}
    all_choices.each do |choice|
      results[choice.text] = choice.responses.length
    end

    results
  end

  def results_1_query_sql
    all_choices =
      AnswerChoice
        .select("answer_choices.text, COUNT(responses.id) AS num_response")
        .joins("LEFT OUTER JOIN responses
          ON answer_choices.id = responses.answer_choice_id")
        .where(answer_choices: { question_id: self.id })
        .group("answer_choices.id")

    results = {}
    all_choices.each do |ac|
      results[ac.text] = ac.num_response
    end

    results
  end

  def results
    all_choices = self.answer_choices
      .select("answer_choices.text, COUNT(responses.id) AS num_response")
      .joins("LEFT OUTER JOIN responses
        ON answer_choices.id = responses.answer_choice_id")
      .group("answer_choices.id")

    results = {}
    all_choices.each do |ac|
      results[ac.text] = ac.num_response
    end

    results
  end
end
