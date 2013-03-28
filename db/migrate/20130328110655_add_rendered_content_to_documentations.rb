class AddRenderedContentToDocumentations < ActiveRecord::Migration
  def change
    add_column :documentations, :rendered_content, :text
  end
end
