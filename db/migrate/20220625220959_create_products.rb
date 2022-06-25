class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
			t.string :name, null: false
			t.integer :quantity
			t.integer :status, null: false, default: 0
			t.string :image_url
			t.string :shop_url
			t.integer :category_id 

      t.timestamps
    end
  end
end
