class Item < ActiveRecord::Base
  has_many   :tag
  belongs_to :folder
end
