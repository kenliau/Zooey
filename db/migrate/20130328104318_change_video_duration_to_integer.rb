class ChangeVideoDurationToInteger < ActiveRecord::Migration
  def up
    change_table :videos do |t|
      t.remove :duration
      t.column :duration, :integer, default: 0
    end
  end

  def down
    change_table :videos do |t|
      t.remove :duration
      t.column :duration, :time
    end
  end
end
