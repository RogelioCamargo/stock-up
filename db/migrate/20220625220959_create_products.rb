class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
			t.string :name, null: false
			t.integer :quantity
			t.integer :status, null: false, default: 0
			t.string :shop_url
			t.integer :category_id 
			t.integer :user_id
			t.integer :reorder_amount
			t.integer :unit_of_measure
			t.integer :delivery_window 

      t.timestamps
    end
		add_index :products, :category_id
		add_index :products, :user_id
  end
end
