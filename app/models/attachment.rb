# == Schema Information
#
# Table name: attachments
#
#  id                  :integer          not null, primary key
#  file                :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  attachmentable_id   :integer
#  attachmentable_type :string
#

class Attachment < ApplicationRecord
	belongs_to :attachmentable, polymorphic: true, optional: true, touch: true
	mount_uploader :file, FileUploader

end
