class AttachmentSerializer < ActiveModel::Serializer

  attributes :id, :name, :path, :created_at

  def name
    object.file.identifier
  end

  def path
    object.file.url
  end

end
