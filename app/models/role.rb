class Role < ActiveRecord::Base
  def readonly?
    true
  end
end
