class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :name
      t.string :preview_url
      t.integer :track_number
      t.string :spotify_id
      t.references :album, index: true

      t.timestamps null: false
    end
    add_foreign_key :songs, :albums
  end
end
