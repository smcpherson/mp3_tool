# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # Used to add a "missing" class if element does not exist or is empty.
  def missing?(x)
    result = (x.nil? || x == '') ? "missing" : ""
    return result
  end
  
end
