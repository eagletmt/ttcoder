class AojSubmission < ActiveRecord::Base
  include Submission
  self.site = 'aoj'
  self.status_field = :status
  self.submitted_at_field = :submission_date
  self.user_field = :user_id
  self.accepted_status_name = 'Accepted'
  self.status_abbreviations = {
    'Accepted' => 'AC',
    'Wrong Answer' => 'WA',
    'Time Limit Exceeded' => 'TLE',
    'Memory Limit Exceeded' => 'MLE',
    'Runtime Error' => 'RE',
    'WA: Presentation Error' => 'PE',
    'Output Limit Exceeded' => 'OLE',
    'Compile Error' => 'CE',
    '' => 'NA',
  }

  validates user_field, presence: true, format: /\A\w+\z/
  validates submitted_at_field, presence: true
  validates :problem_id, presence: true, format: /\A\d+\z/

  validates :run_id, presence: true, uniqueness: true, format: /\A\d+\z/
  VALID_STATUSES = [
    'Accepted',
    'Wrong Answer',
    'Time Limit Exceeded',
    'Memory Limit Exceeded',
    'Runtime Error',
    'WA: Presentation Error',
    'Output Limit Exceeded',
    'Compile Error',
    '', # Judge Not Available
  ]
  validates :status, inclusion: { in: VALID_STATUSES }
  VALID_LANGUAGES = [
    'C',
    'C++',
    'JAVA',
    'C++11',
    'C#',
    'D',
    'Ruby',
    'Python',
    'PHP',
    'JavaScript',
  ]
  validates :language, presence: true, inclusion: { in: VALID_LANGUAGES }
  validates :cputime, presence: true, format: /\A(\d+|-1)\z/
  validates :memory, presence: true, format: /\A\d+\z/
  validates :code_size, presence: true, format: /\A\d+\z/
end
