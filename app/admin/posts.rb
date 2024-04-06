ActiveAdmin.register Post do
index do
  id_column
  column :profile
  column :user_name do |post|
     post.profile.username
    end
  column :media do |post|
    if post.media.attached?
      post.media.each do |media_item|
        if media_item.content_type.start_with? 'image/'
          div do
            image_tag url_for(media_item), width: 100
          end
        end
      end
    else
      content_tag(:span, "No Image Available")
    end
  end
  column :caption
  column :likes_count
  column :comments_count
  # column
  
end
  
end


