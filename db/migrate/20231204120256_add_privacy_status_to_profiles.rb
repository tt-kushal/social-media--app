class AddPrivacyStatusToProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :privacy_status, :integer, default: 0
  end
end
