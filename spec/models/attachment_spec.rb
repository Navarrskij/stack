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

require 'rails_helper'

RSpec.describe Attachment, type: :model do
	it {should belong_to(:attachmentable)}
end
