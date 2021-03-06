require 'codeforces_crawler'

class User < ActiveRecord::Base
  include ParamAttribute
  validate_as_param :name
  validates :poj_user, uniqueness: true, format: /\A\w+\z/
  validates :aoj_user, uniqueness: true, format: /\A\w+\z/
  validates :codeforces_user, uniqueness: true

  has_many :contests, lambda { order(id: :desc) }, foreign_key: :owner_id
  has_one :twitter_user
  accepts_nested_attributes_for :twitter_user

  scope :order_by_name, lambda {
    order("lower(#{connection.quote_column_name(:name)})")
  }

  before_validation(on: :create) do
    self.poj_user = name if poj_user.blank?
    self.aoj_user = name if aoj_user.blank?
    self.codeforces_user = name if codeforces_user.blank?
  end

  after_save :update_standing_cache!
  after_save :fetch_submissions_from_codeforces

  def self.find_or_new_from_omniauth(auth, user_params = {})
    uid = auth.uid
    name = auth.info.nickname
    token = auth.credentials.token
    secret = auth.credentials.secret

    attr_name = :"#{auth.provider}_user"
    klass = attr_name.to_s.camelize.constantize
    transaction do
      provider_user = klass.find_by(uid: uid)
      if provider_user
        Rails.logger.info("[Auth #{auth.provider}] Update #{uid} name=#{name.inspect}")
        provider_user.update!(name: name, token: token, secret: secret)
        provider_user.user
      else
        Rails.logger.info("[Auth #{auth.provider}] New #{uid} name=#{name.inspect}")
        user = new({ name: name }.merge(user_params))
        user.send("build_#{attr_name}", uid: uid, name: name, token: token, secret: secret)
        user
      end
    end
  end

  def self.find_in(site, name)
    find_by(:"#{site}_user" => name)
  end

  def user_in(site)
    send :"#{site}_user"
  end

  def to_param
    name
  end

  def update_standing_cache!
    ActiveRecord::Base.transaction do
      PojSubmission.user(poj_user.downcase).each(&:update_standing_cache!)
      AojSubmission.user(aoj_user.downcase).each(&:update_standing_cache!)
      CodeforcesSubmission.user(codeforces_user.downcase).each(&:update_standing_cache!)
    end
  end

  def fetch_submissions_from_codeforces
    return unless codeforces_user_changed?
    CodeforcesCrawler.new.crawl({ method: 'user.status', handle: codeforces_user })
  end
end
