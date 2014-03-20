class User < ActiveRecord::Base
  validates_presence_of :email
  has_and_belongs_to_many :podcasts

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
