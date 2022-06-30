class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
			t.string :name, null: false
			t.integer :quantity
			t.integer :status, null: false, default: 0
			t.string :shop_url
			t.integer :category_id 
			t.integer :user_id
			t.integer :trigger_alert_amount 
			t.integer :trigger_warning_amout
			t.integer :reorder_amount

      t.timestamps
    end
  end
end
