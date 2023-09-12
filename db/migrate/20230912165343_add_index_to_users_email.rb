class AddIndexToUsersEmail < ActiveRecord::Migration[7.0]
  def change
    # Rails add_index method adds index to email column
    # unique: true option enforces uniqueness
    add_index :users, :email, unique: true
  end
end
