class MessagesController < ApplicationController
	before_action :set_conversation, only: [:create]
	before_action :authenticate_user!
	

	# POST /message/create
	def create
		current_user.reply_to_conversation(@conversation, params[:body])
		@conversation.mark_as_read(current_user)
		flash[:notice] = "Reply has been sent!"
		redirect_to :back 
	end

	private
	
	def set_conversation
		@conversation = current_user.mailbox.conversations.find(params[:conversation_id])
	end

end