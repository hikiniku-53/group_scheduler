class CreateAttends < ActiveRecord::Migration[6.1]
  def change
    create_table :attends do |t|

      t.timestamps
    end
  end
end
