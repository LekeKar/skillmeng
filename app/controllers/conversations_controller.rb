class ConversationsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_conversation, except: [:index, :create]
	after_action :read_all_messages, only: [:index] 

	def index
	
		@conversations_inbox = current_user.mailbox.inbox.order('updated_at ASC').page(params[:page]).per_page(8)
		@conversations_trash = current_user.mailbox.trash.order('updated_at ASC').page(params[:page]).per_page(8)
		@conversations_sent = current_user.mailbox.sentbox.order('updated_at ASC').page(params[:page]).per_page(8)
		@conversations_all = current_user.mailbox.conversations.order('updated_at ASC').page(params[:page]).per_page(8)
		
		respond_to do |format|
      format.html
      format.js
    end
	end

	def create
		@recipient = User.find(params[:sender])
		current_user.send_message( @recipient, params[:body], params[:subject])
		flash[:notice] = "Message has been sent!"
		redirect_to :back
	end

	def mark_as_read
		@conversation.mark_as_read(current_user)
		flash[:notice] = "Message has been read!"
		redirect_to :back
	end

	def move_to_inbox
		@conversation.untrash(current_user)
		flash[:notice] = "Message has been moved to inbox!"
		redirect_to :back
	end

	def destroy
		@conversation.move_to_trash(current_user)
		flash[:notice] = "Message has been trashed!"
		redirect_to :back
	end

	def delete_from_trash
	 current_user.mark_as_deleted @conversation
	 flash[:notice] = "Message has been deleted permanently!"
	 redirect_to :back
	end

	private
	
	def set_conversation
		if params[:id]	
    	@conversation = current_user.mailbox.conversations.find(params[:id])
    else
    	@conversation = current_user.mailbox.conversations.find(params[:conversation_id])
	  end	
	end
	
	def read_all_messages
		if params[:type] == "inbox"
			@conversations_inbox.each do |conversation|
				conversation.mark_as_read(current_user)
			end
		end
	end

end 