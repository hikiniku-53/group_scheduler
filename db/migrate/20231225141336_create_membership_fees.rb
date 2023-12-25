class CreateMembershipFees < ActiveRecord::Migration[6.1]
  def change
    create_table :membership_fees do |t|
      t.bigint :member_id, null: false
      t.bigint :fee, null: false
      t.boolean :is_paid
      t.timestamps
    end
  end
end
