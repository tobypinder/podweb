module PodcastsHelper

  def get_feed(podcast)
    if podcast.updated_at < (DateTime.now - 3.hours) || podcast.raw_feed.blank?
      podcast.raw_feed = Feedjira::Feed.fetch_raw podcast.feed_url
      podcast.updated_at = DateTime.now
      podcast.save
    end

    Feedjira::Feed.add_common_feed_entry_element("enclosure", :value => :url, :as => :enclosure_url)
    return Feedjira::Feed.parse podcast.raw_feed
  end

end