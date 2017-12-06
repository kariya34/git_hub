class CreateWorkEnds < ActiveRecord::Migration[5.1]
  def change
    create_table :work_ends do |t|
      t.integer :user_id
      t.datetime :pressed_at

      t.timestamps
    end
  end
end
