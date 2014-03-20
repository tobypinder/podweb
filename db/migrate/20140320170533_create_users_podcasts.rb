class CreateUsersPodcasts < ActiveRecord::Migration
  def change
    create_table :users_podcasts do |t|
      t.belongs_to :user
      t.belongs_to :podcast
    end
  end
end
