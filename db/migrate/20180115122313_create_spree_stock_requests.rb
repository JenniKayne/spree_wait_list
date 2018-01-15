class CreateSpreeStockRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :spree_stock_requests do |t|
      t.string :email
      t.integer :variant_id
      t.string :status, default: 'new'
      t.boolean :in_progress, default: false
      t.datetime :sent_at
      t.timestamps
    end

    add_index :spree_stock_requests, :variant_id
  end
end
