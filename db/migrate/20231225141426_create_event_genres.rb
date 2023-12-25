class CreateEventGenres < ActiveRecord::Migration[6.1]
  def change
    create_table :event_genres do |t|

      t.timestamps
    end
  end
end
