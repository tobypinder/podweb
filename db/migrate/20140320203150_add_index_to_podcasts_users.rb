class AddIndexToPodcastsUsers < ActiveRecord::Migration
  def change
    add_index :podcasts_users, [:podcast_id, :user_id], :unique => true
  end
end
