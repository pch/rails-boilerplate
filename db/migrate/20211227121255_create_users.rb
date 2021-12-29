class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :role
      t.datetime :email_confirmed_at
      t.datetime :terms_accepted_at

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
