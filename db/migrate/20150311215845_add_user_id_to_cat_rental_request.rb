class AddUserIdToCatRentalRequest < ActiveRecord::Migration
  def change
    add_column :cat_rental_requests, :user_id, :integer, null: false, index: true, default: 0
  end
end
