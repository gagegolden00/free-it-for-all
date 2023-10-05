class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  default_scope -> { where(discarded_at: nil) }
end
