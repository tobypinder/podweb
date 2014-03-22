class AddRawFeedToPodcasts < ActiveRecord::Migration
  def change
    add_column :podcasts, :raw_feed, :text
  end
end
