module PodcastsHelper

  def get_feed(podcast)
    if podcast.updated_at < (DateTime.now - 3.hours) || podcast.raw_feed.blank?
      podcast.raw_feed = Feedjira::Feed.fetch_raw podcast.feed_url
      podcast.save
    end

    return Feedjira::Feed.parse podcast.raw_feed
  end

end