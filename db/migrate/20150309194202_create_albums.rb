class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :title
      t.string :artist
      t.string :release_date
      t.string :thumb
      t.string :spotify_id
      t.string :price
      t.string :condition

      t.timestamps null: false
    end
  end
end
