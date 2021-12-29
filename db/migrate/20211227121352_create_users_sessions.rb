class CreateUsersSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :users_sessions do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :token, null: false
      t.datetime :accessed_at
      t.datetime :revoked_at

      t.timestamps
    end
    add_index :users_sessions, :token, unique: true
    add_index :users_sessions, :accessed_at
    add_index :users_sessions, :revoked_at
  end
end
