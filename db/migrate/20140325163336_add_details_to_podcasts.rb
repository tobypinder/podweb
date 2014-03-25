class AddDetailsToPodcasts < ActiveRecord::Migration
  def change
    add_column :podcasts, :description, :text
    add_column :podcasts, :title, :string
    add_column :podcasts, :url, :string
    add_column :podcasts, :album_art_url, :string
  end
end
