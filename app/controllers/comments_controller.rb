class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_profile_existence, only: [:create, :update , :destroy]


  def create
    post = Post.find(params[:comment][:post_id])
    
    if authorized_user_to_comment?(post)
      comment = current_user.comments.new(comments_params)
      if comment.save
          render json: {
              message: "commented successfully",
              comment: comment
          },status: 200
      else
        render_unprocessable_entity(comment)
      end
    else
      render_unauthorized
    end
    
  end

  def update
    comment =  Comment.find(params[:id])
    if authorized_user?(comment) && comment.update(comments_params)
      render json: {
        message: "comment updated",
        comment: comment
      }, status: 200
    elsif !authorized_user?(comment)
      render_unauthorized
    else
      render_unprocessable_entity(comment)
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    if authorized_user?(comment) && comment.destroy
      render json: {
        message: "comment deleted",
      }
    elsif !authorized_user?(comment)
      render_unauthorized
    else
      render_unprocessable_entity(comment)
    end
  end


  private

  def comments_params
    params.require(:comment).permit(:content, :post_id, :user_id )
  end


  def check_profile_existence
    return if current_user.profile.present?

    render json: { message: "Create a profile first" }, status: :unauthorized
  end

  def authorized_user?(comment)
     comment.user == current_user || comment.post.user == current_user
  end

  def authorized_user_to_comment?(post)
      profile = post.profile
      current_user_follows = current_user.accepted_followings.exists?(profile.user.id)# if current_user
      profile_owner = current_user == profile.user
  
      return profile.public_profile? || current_user_follows || profile_owner 
  end

  
  def render_unauthorized
    render json: {
      message: "You are not authorized for this action"
    }, status: :unauthorized
  end
  
  def render_unprocessable_entity(comment)
    render json: {
      errors: comment.errors.full_messages
    }, status: :unprocessable_entity
  end
end
