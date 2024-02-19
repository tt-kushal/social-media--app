ActiveAdmin.register User do
  config.sort_order = 'id_asc'
  index do 
    selectable_column
    id_column
    column :email
    column :created_at
    actions 

  end

  filter :email
end
