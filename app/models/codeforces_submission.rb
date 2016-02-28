class CodeforcesSubmission < ActiveRecord::Base
  include Submission

  self.site = 'codeforces'
  self.status_field = :verdict
  self.submitted_at_field = :submission_time
  self.user_field = :handle
  self.accepted_status_name = 'OK'

  self.status_abbreviations = {
    'FAILED' => 'FAILED',
    'OK' => 'AC',
    'PARTIAL' => 'PARTIAL',
    'COMPILATION_ERROR' => 'CE',
    'RUNTIME_ERROR' => 'RE',
    'WRONG_ANSWER' => 'WA',
    'PRESENTATION_ERROR' => 'PE',
    'TIME_LIMIT_EXCEEDED' => 'TLE',
    'MEMORY_LIMIT_EXCEEDED' => 'MLE',
    'IDLENESS_LIMIT_EXCEEDED' => 'ILE',
    'SECURITY_VIOLATED' => 'SV',
    'CRASHED' => 'CRASHED',
    'INPUT_PREPARATION_CRASHED' => 'IPC',
    'CHALLENGED' => 'CHALLENGED',
    'SKIPPED' => 'SKIPPED',
    'REJECTED' => 'REJECTED',
    '' => 'NA',
  }

  validates user_field, presence: true
  validates submitted_at_field, presence: true
  validates :problem_id, presence: true, format: /\A\d+[A-Z]\d?\z/

  VALID_STATUSES = [
    'FAILED',
    'OK',
    'PARTIAL',
    'COMPILATION_ERROR',
    'RUNTIME_ERROR',
    'WRONG_ANSWER',
    'PRESENTATION_ERROR',
    'TIME_LIMIT_EXCEEDED',
    'MEMORY_LIMIT_EXCEEDED',
    'IDLENESS_LIMIT_EXCEEDED',
    'SECURITY_VIOLATED',
    'CRASHED',
    'INPUT_PREPARATION_CRASHED',
    'CHALLENGED',
    'SKIPPED',
    'REJECTED',
    '',
  ]
  validates :verdict, inclusion: { in: VALID_STATUSES }
  validates :programming_language, presence: true
  validates :time_consumed_millis, presence: true, format: /\A(\d+|-1)\z/
  validates :memory_consumed_bytes, presence: true, format: /\A\d+\z/

  def solved_users(problem_id)
    site2user = make_usermap(User.all)
    StandingCache.where(
      user: site2user.keys,
      problem_id: problem_id,
      problem_type: site,
      status: 'OK',
    ).pluck(:user).map do |user|
      site2user[user]
    end
  end
end
