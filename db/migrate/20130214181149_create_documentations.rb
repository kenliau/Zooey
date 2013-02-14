class CreateDocumentations < ActiveRecord::Migration
  def change
    create_table :documentations do |t|
      t.string :title
      t.string :content

      t.timestamps
    end
  end
end
