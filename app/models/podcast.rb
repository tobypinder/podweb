class Podcast < ActiveRecord::Base
  serialize :episodes
  validates_presence_of :feed_url

  before_save :save_details
  after_find :update_details
  has_and_belongs_to_many :users


  def save_details
    self.raw_feed = Feedjira::Feed.fetch_raw self.feed_url

    Feedjira::Feed.add_common_feed_element("itunes:image", :value => :href, :as => :album_art_url)
    Feedjira::Feed.add_common_feed_entry_element("enclosure", :value => :url, :as => :enclosure_url)

    feed = Feedjira::Feed.parse self.raw_feed

    self.album_art_url = feed.album_art_url
    self.title = feed.title
    self.description = feed.description
    self.url = feed.url
    self.episodes = feed.entries

    self.updated_at = DateTime.now
  end

  def update_details
    Feedjira::Feed.add_common_feed_entry_element("enclosure", :value => :url, :as => :enclosure_url)
    self.save if self.updated_at < (DateTime.now - 3.hours)
  end
end