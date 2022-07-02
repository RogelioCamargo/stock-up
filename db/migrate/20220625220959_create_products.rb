class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
			t.string :name, null: false
			t.integer :quantity
			t.integer :status, null: false, default: 0
			t.string :shop_url
			t.integer :category_id 
			t.integer :reorder_amount
			t.string :unit_of_measure
			t.string :delivery_window
			t.integer :reorder_limit

      t.timestamps
    end
		add_index :products, :category_id
  end
end
