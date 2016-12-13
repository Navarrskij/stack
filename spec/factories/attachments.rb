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

FactoryGirl.define do
  factory :question_attachment, class: 'Attachment' do
    file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', '1.txt')) }
    association :attachmentable, factory: :question
  end
  factory :answer_attachment, class: 'Attachment' do
    file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', '1.txt')) }
    association :attachmentable, factory: :answer
  end
end
