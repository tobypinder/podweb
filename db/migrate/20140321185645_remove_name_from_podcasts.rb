class RemoveNameFromPodcasts < ActiveRecord::Migration
  def change
    remove_column :podcasts, :name
  end
end
