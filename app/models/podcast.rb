class Podcast < ActiveRecord::Base

  has_and_belongs_to_many :users

  validates_presence_of :feed_url

end
