ActiveAdmin.register Profile do
    actions :index, :show, :edit, :update, :destroy
    config.sort_order = 'id_asc'
    permit_params :username, :full_name, :phone_number, :date_of_birth, :bio, :address, :privacy_status

    index do
        id_column
        column :username
        column :profile_image do |object|
            if object.profile_image.attached?
                image_tag url_for(object.profile_image), width: 100
            else
              content_tag(:span, "No Image Available")
            end
          end
        column :privacy_status
        column :full_name
        column :phone_number
        column :date_of_birth
        column :bio
        column :age
        column :gender
        column :country
        column :state
        column :address
        column :user
        column :created_at
        actions
    end
 
    show do
        attributes_table do
          row :id
          row :username
          row :profile_image do |object|
            if object.profile_image.attached?
                image_tag url_for(object.profile_image), width: 100
            else
              content_tag(:span, "No Image Available")
            end
          end
          row :full_name
          row :phone_number
          row :date_of_birth
          row :post_count
          row :bio
          row :age
          row :gender
          row :country
          row :state
          row :address
          row :user
          row :privacy_status
        end
    end

    form do |f|
        f.semantic_errors
        f.inputs 'Profile Details' do
          f.input :username
          f.input :full_name
          f.input :phone_number
          f.input :date_of_birth
          f.input :post_count, input_html: { readonly: true }
          f.input :age, input_html: { readonly: true }
          f.input :state, input_html: { readonly: true }
          f.input :bio
          f.input :address
          f.input :privacy_status
        end
        f.actions
    end


    filter :user
    filter :full_name

    scope :all, default: true #to display data in asc or dsc

    controller do
      def scoped_collection
        end_of_association_chain.includes(:user, :profile_image_attachment)
      end
    end
end
