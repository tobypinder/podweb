class Podcast < ActiveRecord::Base
  validates_presence_of :feed_url

  before_save :save_details
  after_save :save_episodes
  after_find :update_details

  has_many :episodes
  has_and_belongs_to_many :users


  def save_details
    Feedjira::Feed.add_common_feed_element("itunes:image", :value => :href, :as => :album_art_url)

    self.raw_feed = Feedjira::Feed.fetch_raw self.feed_url
    feed = Feedjira::Feed.parse self.raw_feed

    self.album_art_url = feed.album_art_url
    self.title = feed.title
    self.description = feed.description
    self.url = feed.url
    self.updated_at = DateTime.now
  end

  def save_episodes
    Feedjira::Feed.add_common_feed_entry_element("enclosure", :value => :url, :as => :enclosure_url)
    Feedjira::Feed.add_common_feed_entry_element("itunes:image", :value => :href, :as => :image)

    feed = Feedjira::Feed.parse self.raw_feed
    feed.entries.each do |entry|
      episode = self.episodes.find_or_create_by(uid: entry.entry_id)
      episode.uid = entry.entry_id
      episode.title = entry.title
      episode.author = entry.author
      episode.link_url = entry.url
      episode.summary = entry.summary
      episode.content = entry.content
      episode.image_url = entry.image
      if defined? entry.enclosure_url
        episode.media_url = entry.enclosure_url
      elsif defined? entry.image
        episode.media_url = entry.image
      else
        episode.media_url = nil
      end
      episode.publish_date = entry.published
      episode.save
    end
  end

  def update_details
    if self.updated_at < (DateTime.now - 1.hour)
      self.save if self.raw_feed != Feedjira::Feed.fetch_raw(self.feed_url)
    end
  end
end