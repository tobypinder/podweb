class CreateWatchedEpisodes < ActiveRecord::Migration
  def change
    create_table :watched_episodes do |t|
      t.belongs_to :user
      t.belongs_to :episode
      t.integer :seconds_seen
      t.boolean :watched, default: false

      t.timestamps
    end

    add_index :watched_episodes, [:user_id, :episode_id], :unique => true
  end
end
