class User < ActiveRecord::Base
  has_many :watched_episodes
  has_and_belongs_to_many :podcasts
  accepts_nested_attributes_for :podcasts

  validates_presence_of :email

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      if auth['info']
         user.email = auth['info']['email'] || ""
      end
    end
  end

end