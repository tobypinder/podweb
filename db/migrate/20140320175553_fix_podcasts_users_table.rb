class FixPodcastsUsersTable < ActiveRecord::Migration
  def change
    drop_table :users_podcasts

    create_table :podcasts_users do |t|
      t.belongs_to :user
      t.belongs_to :podcast
    end
  end
end