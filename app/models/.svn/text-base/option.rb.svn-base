class Option < ActiveRecord::Base

  # Returns the value of a opton when given a name.
  def self.getValue(name)
    value = find_by_name(name) || return
    value = find_by_name(name).value || return
  end


end
