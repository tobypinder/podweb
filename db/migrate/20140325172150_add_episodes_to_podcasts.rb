class AddEpisodesToPodcasts < ActiveRecord::Migration
  def change
    add_column :podcasts, :episodes, :text
  end
end
