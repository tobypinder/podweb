class Episode < ActiveRecord::Base
  belongs_to :podcast
  has_many :watched_episodes
end
