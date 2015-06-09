class CreateCalendars < ActiveRecord::Migration
  def change
    create_table :calendars do |t|
      t.string :title
      t.text :description
      t.date :date
      t.time :time

      t.timestamps null: false
    end
  end
end
