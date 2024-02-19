class FollowRequestsController < ApplicationController
    before_action :authenticate_user!
    before_action :check_profile_existence
    
    #pending requests
    def index 
        @follow_requests = current_user.followers
                                       .where(follow_requests: { status: :pending })
                                       .order('follow_requests.created_at DESC')
        paginate_and_serialize(@follow_requests)
    end

    def create
        profile = Profile.find(params[:profile_id])

        if profile.user == current_user
            render json: { error: 'You cannot send a follow request to yourself.' }, status: :unprocessable_entity
            return
        end

        if profile.public_profile?
            current_user.followings.create(following: profile.user, status: :accepted)
            render json: { message: 'You have started following the user.'},status: :ok
        else
            follow_request = FollowRequest.new(follower: current_user, following: profile.user, status: :pending)
            if follow_request.save
            render json: { message: 'Follow request sent successfully.',
                            follow_request: follow_request,
                            }, status: :created
            else
            render json: { error: "Unable to send follow request.#{follow_request.errors.full_messages.to_sentence}" }, status: :unprocessable_entity
            end
        end
    end
    
   


    def handle_requests
        follow_request = current_user.followers.find(params[:request_id])

        case params[:status]
        when 'accept'
            follow_request.accept!
            render json: { message: 'Follow request accepted successfully.' }, status: :ok
        when 'reject'
            follow_request.reject!
            follow_request.destroy
            render json: { message: 'Follow request rejected.' }, status: :ok
        else
            render json: { error: 'Invalid action type.' }, status: :unprocessable_entity
        end 
    end

    def followers
        @followers = current_user.accepted_followers
        paginate_and_serialize(@followers)
    end
    
    def following
        @following = current_user.accepted_followings
        paginate_and_serialize(@following)
    end

    def unfollow
        profile = Profile.find(params[:profile_id])
      
        follow_relationship = current_user.followings.find_by(following: profile.user)
      
        if follow_relationship
          follow_relationship.destroy
          render json: { message: 'Unfollowed the user successfully.' }, status: :ok
        else
          render json: { error: 'You are Not following the user' }, status: :unprocessable_entity
        end
    end
      

    private

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
          data: paginated_data,
          pagination: pagination_info
        }, status: :ok
    end

    def check_profile_existence
        return if current_user.profile.present?
    
        render json: { message: "Create a profile first" }, status: :unauthorized
    end
end
