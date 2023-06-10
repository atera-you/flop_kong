class CreateSpans < ActiveRecord::Migration[6.0]
  def change
    create_table :spans do |t|
      t.string :name
      t.text :span, default: [], array: true
      t.string :high_pair 
      t.string :low_pair  
      t.text :high_suit ,array:true
      t.text :low_suit  ,array:true
      t.text :high_offsuit  ,array:true
      t.text :low_offsuit ,array:true

      t.timestamps
    end
  end
end
