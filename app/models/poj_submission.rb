class PojSubmission < ActiveRecord::Base
  include Submission
  self.site = 'poj'
  self.status_field = :result
  self.submitted_at_field = :submitted_at
  self.user_field = :user
  self.accepted_status_name = 'Accepted'
  self.status_abbreviations = {
    'Accepted' => 'AC',
    'Wrong Answer' => 'WA',
    'Time Limit Exceeded' => 'TLE',
    'Memory Limit Exceeded' => 'MLE',
    'Runtime Error' => 'RE',
    'Presentation Error' => 'PE',
    'Output Limit Exceeded' => 'OLE',
    'Compile Error' => 'CE',
    'System Error' => 'SE',
    'Validator Error' => 'VE',
  }

  validates user_field, presence: true, format: /\A\w+\z/
  validates submitted_at_field, presence: true
  validates :problem_id, presence: true, format: /\A\d+\z/

  VALID_RESULTS = [
    'Accepted',
    'Wrong Answer',
    'Time Limit Exceeded',
    'Memory Limit Exceeded',
    'Runtime Error',
    'Presentation Error',
    'Output Limit Exceeded',
    'Compile Error',
    'System Error',
    'Validator Error',
  ]
  validates :result, presence: true, inclusion: { in: VALID_RESULTS }
  validates_each :memory, :time do |record, attr, value|
    if record.result == 'Accepted'
      if value.nil?
        record.errors.add attr, :blank
      end
    else
      unless value.blank?
        record.errors.add attr, :invalid
      end
    end
  end
  VALID_LANGUAGES = %w[G++ GCC Java Pascal C++ C Fortran]
  validates :language, presence: true, inclusion: { in: VALID_LANGUAGES }
  validates :length, presence: true

  KNOWN_INVALID_RESULTS = [
    'Compiling',
    'Running & Judging',
    'Waiting',
  ]
  def ignorable_error?(attr, _msg)
    attr == :result && KNOWN_INVALID_RESULTS.include?(self[attr.to_s])
  end
end
