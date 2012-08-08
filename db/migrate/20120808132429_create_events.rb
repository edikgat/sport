class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.datetime :event_date
      t.integer :members

      t.timestamps
    end
  end
end
