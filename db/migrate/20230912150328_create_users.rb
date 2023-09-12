class CreateUsers < ActiveRecord::Migration[7.0]
  # change method determines the change to be made in the DB
  def change
    # Rails method - create_table
    create_table :users do |t|
      t.string :name
      t.string :email

      t.timestamps # creates two columns - "created_at" and "updated_at" that are automatically updated
    end
  end
end
