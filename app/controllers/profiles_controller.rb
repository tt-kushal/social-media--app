class ProfilesController < ApplicationController
    before_action :authenticate_user!

    def show
        profile = Profile.find(params[:id])
        if profile.present?
            render json: {profile: ProfileSerializer.new(profile) }
        end
    end
    
    def show_my_profile
        profile = current_user.profile
        if profile.present?
            render json: {profile: ProfileSerializer.new(profile) }, status: :ok
        else
            render_not_found_message
        end
    end

    def create
        current_user.profile.present? ? profile_exist : create_profile
    end

    def update       
        begin
            profile = current_user.profile
            if profile.present?
                if profile.update(profile_params)
                    render json: {
                        message: "succefully updated",
                        profile: ProfileSerializer.new(profile)
                    },status: 200
                else
                    render json: {message: "profile could not be  updated, #{profile.errors.full_messages}"}, status: 422
                end
            else
                render_not_found_message
            end
        rescue  ArgumentError => e
            render json: { error:"invalid privacy_status include 'private_profile' or 'public_profile'" }, status: :unprocessable_entity   
        end
        
    end
    
    def destroy
        profile = current_user.profile
        if profile.present?
           if profile.destroy
            render json: {
                message: "succefully deleted"
            },status: 200
           else
            render json: {message: "profile could not be  deleted, #{profile.errors.full_messages}"}, status: 200
           end
        else
            render_not_found_message
        end
    end

    def dsiplay_profile_with_posts
        profile = Profile.find(params[:profile_id])
        current_user_follows = current_user.accepted_followings.exists?(profile.user.id)# if current_user
        profile_owner = current_user == profile.user
        if profile.present?
            if profile.public_profile? || current_user_follows || profile_owner 
              posts = profile.posts.includes([:media_attachments, :likes, :comments])
              paginated_posts = posts.page(params[:page]).per(params[:per] || 4)

                render json: {
                    profile: ProfileSerializer.new(profile),
                    posts: PostSerializer.new(paginated_posts)
                    }, status: :ok
            else
                render json: { error: 'Private profile - follow to see the posts' }, status: :unauthorized
            end
        end 
    end



    private

    def profile_params
        params.require(:profile).permit(:username, :full_name, :phone_number, :date_of_birth, :bio, :age, :gender, :country, :state, :address, :profile_image, :privacy_status)
    end
    
    def create_profile 

        begin
            @profile = Profile.new(profile_params)
            @profile.user_id = current_user.id
            if @profile.save
                render json: {
                    message: "Profile create successfully",
                    profile: @profile
                }, status: 201
            else
                render json: {
                    message: "Profile could not created",
                    error: @profile.errors.full_messages
                }, status: 422  
            end 
        rescue  ArgumentError => e
            render json: { error:"invalid privacy_status include 'private_profile' or 'public_profile'" }, status: :unprocessable_entity   
        end
        
    end
    
    def profile_exist
        render json: {message: "profile has already been created" }, status: 200
    end  

    def render_not_found_message
        render json: {message: "profile not found"}, status: 404
    end
    
end
