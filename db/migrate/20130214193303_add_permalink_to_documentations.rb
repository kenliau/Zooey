class AddPermalinkToDocumentations < ActiveRecord::Migration
  def change
    add_column :documentations, :permalink, :string
  end
end
