class CreateLabelings < ActiveRecord::Migration
  def change
    create_table :labelings do |t|
      t.integer :label_id
      t.integer :topic_id
      t.references :label, index: true
      t.references :topic, index: true
      t.references :post, index: true
      t.references :labelable, polymorphic: true, index: true

      t.timestamps null: false
    end

    add_foreign_key :labelings, :labels
    add_foreign_key :labelings, :topics
    add_foreign_key :labelings, :posts
  end
end
