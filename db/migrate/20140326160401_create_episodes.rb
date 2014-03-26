class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.string :uid
      t.string :title
      t.string :author
      t.string :link_url
      t.text :summary
      t.text :content
      t.string :image_url
      t.string :media_url
      t.datetime :publish_date
      t.integer :podcast_id

      t.timestamps
    end
  end
end
