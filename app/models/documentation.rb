class Documentation < ActiveRecord::Base
  attr_accessible :content, :title, :permalink
  validates_uniqueness_of :permalink, :case_sensitive => false
end
