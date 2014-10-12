class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :user_id
      t.string :email
      t.string :name
      t.text :message
      t.timestamps
    end
  end
end
