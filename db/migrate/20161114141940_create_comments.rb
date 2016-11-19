class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|

    	t.text :body
    	t.string :commentable_type
    	t.integer :commentable_id
			t.integer :user_id, foreign_key: true
   
      t.timestamps
    end
      add_index :comments, :commentable_id
    	add_index :comments, :commentable_type
  end
end
