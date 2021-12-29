class CreateUsersActivities < ActiveRecord::Migration[7.0]
  def change
    create_table :users_activities do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :session, null: true, foreign_key: {to_table: "users_sessions"}
      t.string :action, null: false
      t.text :metadata
      t.datetime :created_at
      t.string :referrer
      t.string :user_agent
      t.string :ip
      t.string :country
      t.string :region
      t.string :city
    end
    add_index :users_activities, :action
    add_index :users_activities, :ip
  end
end
