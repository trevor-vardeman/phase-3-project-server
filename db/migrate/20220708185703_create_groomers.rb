class CreateGroomers < ActiveRecord::Migration[6.1]
  def change
    create_table :groomers do |t|
      t.string :name
      t.timestamps
    end
  end
end