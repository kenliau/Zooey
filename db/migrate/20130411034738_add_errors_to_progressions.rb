class AddErrorsToProgressions < ActiveRecord::Migration
  def change
    add_column :progressions, :errors, :text
  end
end
