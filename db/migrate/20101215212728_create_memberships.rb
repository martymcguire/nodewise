class CreateMemberships < ActiveRecord::Migration
  def self.up
    create_table :memberships do |t|
      t.integer :user_id, :null => false
      t.string :status, :null => false
      t.decimal :monthly_fee, :null => false
      t.datetime :next_payment_due, :null => false
      t.datetime :member_since, :null => false

      t.timestamps
    end

    add_index :memberships, :user_id, :unique => true
  end

  def self.down
    drop_table :memberships
  end
end
