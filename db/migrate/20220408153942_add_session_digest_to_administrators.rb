class AddSessionDigestToAdministrators < ActiveRecord::Migration[7.0]
  def change
    add_column(:administrators, :session_digest, :string)
  end
end
