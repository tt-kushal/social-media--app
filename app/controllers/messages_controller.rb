class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_profile_existence


    def create
        receiver = User.find_by(id: message_params[:receiver_id])
        message = Message.create(sender: current_user, receiver: receiver, body: message_params[:body], read: false)
      
        if message.persisted?
            ActionCable.server.broadcast("chat_channel", { message: message.body })
          render json: { message: 'Message sent successfully.', direct_message: message }, status: :ok
        else
          render json: { error: "Unable to send the message. #{message.errors.full_messages.to_sentence}" }, status: :unprocessable_entity
        end
        
    end

    def chat_history
        sender_id = current_user.id
        receiver_id = params[:receiver_id]
    
        messages = Message.includes([sender: :profile]).where(
          "(sender_id = :sender_id AND receiver_id = :receiver_id) OR (sender_id = :receiver_id AND receiver_id = :sender_id)",
          { sender_id: sender_id, receiver_id: receiver_id }
        ).order(created_at: :asc)
    
        # render json: messages.pluck(:id, :body, :sender_id), status: :ok
        render json: MessageSerializer.new(messages), status: :ok
        #  paginate_and_serialize(messages)
    end

    private

    def message_params 
        params.require(:message).permit(:receiver_id, :body) 
    end

    def check_profile_existence
        return if current_user.profile.present?
    
        render json: { message: "Create a profile first" }, status: :unauthorized
    end

    def paginate_and_serialize(data)
        per_page = params[:per_page] || 10
        current_page = params[:current_page] || 1
        paginated_data = data.page(current_page).per(per_page)
    
        pagination_info = {
          current_page: paginated_data.current_page,
          next_page: paginated_data.next_page,
          previous_page: paginated_data.prev_page,
          total_data: paginated_data.total_count
        }
    
        render json: {
          data: MessageSerializer.new(paginated_data),
          pagination: pagination_info
        }, status: :ok
    end
end
