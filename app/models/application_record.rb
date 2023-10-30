class ApplicationRecord < ActiveRecord::Base
  include Discard::Model
  primary_abstract_class

  def discard_necessary_associated_record(record_to_discard)
    record_to_discard.discard if record_to_discard.present?
  end

end
