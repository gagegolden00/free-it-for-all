class ApplicationRecord < ActiveRecord::Base
  include Discard::Model
  primary_abstract_class
  default_scope -> { where(discarded_at: nil) }
  
end
