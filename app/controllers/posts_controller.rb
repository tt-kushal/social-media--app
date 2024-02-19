class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_profile_existence, only: [:create, :show_my_post, :update, :destroy, :toggle_like]
  before_action :set_post, only: [ :show, :update, :destroy, :get_comments]

    def index
      posts = Post.order('created_at DESC')
     if posts.present?
      paginate_and_serialize(posts)
     else
      render_post_not_found_message
     end
    end


    def create
        profile = set_profile
        create_post(profile)
    end

    def update
      if @post.profile.user == current_user
        if @post.update(post_params)
          render json: { post: PostSerializer.new(post) }, status: :ok
        else
          render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { message: "You are not authorized to update this post" }, status: :unauthorized
      end
    end


    def destroy
      if @post.profile.user == current_user
        if @post.destroy
          render json: { message: "post deleted successfully"}, status: 200 
        else
          render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { message: "You are not authorized to update this post" }, status: :unauthorized
      end
    end

    def show_my_post
      profile = set_profile
      my_post = profile.posts.includes([:comments, :likes, :media_attachments])
      if my_post.present?
        paginate_and_serialize(my_post)
       else
        render_post_not_found_message
       end 
    end

    def show
      if @post.present?
        @post = Post.includes(comments: { user: :profile }).find(params[:id])
        render json: {
          post: PostSerializer.new(@post),
          comments:  CommentSerializer.new(@post.comments)
        },status: 200
      else
        render_post_not_found_message
      end
    end

    def toggle_like
      post_id = params[:post_id]
      @post = Post.find(post_id)
      like = current_user.likes.find_by(post: @post)
  
      if like
        like.destroy
        message = 'Post unliked successfully'
      else
        current_user.likes.create(post: @post)
        message = 'Post liked successfully'
      end
  
      render json: { message: message }
  end
  
    
    private

    def post_params 
       params.require(:post).permit(:caption, media:[]).merge(profile_id: current_user.profile.id, user_id: current_user.id)
    end

    def set_profile
      profile = current_user.profile
    end

    def set_post
      @post = Post.find(params[:id])
    end

    def create_post(profile)
        post = profile.posts.new(post_params)
        if post.save 
          render json: {post: PostSerializer.new(post)}, status: :created
        else
          render json: {message: post.errors.full_messages}, status: :unprocessable_entity
        end
    end
    
    def check_profile_existence
      return if current_user.profile.present?
  
      render json: { message: "Create a profile first" }, status: :unauthorized
    end

    def paginate_and_serialize(posts)
      per_page = params[:per_page] || 10
      current_page = params[:current_page] || 1
      posts = posts.page(current_page).per(per_page)

      pagination_info = {
        current_page: posts.current_page,
        next_page: posts.next_page,
        previous_page: posts.prev_page,
        total_data: posts.total_count
      }
      post_serializers = PostSerializer.new(posts)
      render json: {
        posts: post_serializers,
        pagination: pagination_info
      }, status: :ok
    end

    def render_post_not_found_message
      render json: {message: "no post found"}, status: 404
    end

    def like_params
      params.require(:like).permit(:post_id)
    end
    
    
end


      