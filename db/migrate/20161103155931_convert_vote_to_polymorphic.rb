class ConvertVoteToPolymorphic < ActiveRecord::Migration[5.0]
  def change
  	add_column :votes, :votable_id, :integer
  	add_column :votes, :votable_type, :string
  	add_column :votes, :value, :integer
  	add_column :votes, :user_id, :integer
  	add_index :votes, [:votable_id, :votable_type]
  	add_index :votes, :user_id
  end
end
