class AttachmentsController < ApplicationController
	before_action :authenticate_user!

	def destroy
		@attachment = Attachment.find(params[:id])
    if current_user.author_of?(@attachment.attachmentable)
    	@attachment.destroy
    end
  end
end