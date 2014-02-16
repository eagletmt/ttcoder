module ParamAttribute
  extend ActiveSupport::Concern

  module ClassMethods
    def validate_as_param(attr)
      validates attr, uniqueness: true, format: %r{\A[^./]+\z}, exclusion: { in: %w[new edit] }
    end
  end
end
