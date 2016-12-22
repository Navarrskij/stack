ThinkingSphinx::Index.define :user, with: :active_record do
  #fileds
  indexes email, as: :author, sortable: true

  # attributes
  has created_at, updated_at
end