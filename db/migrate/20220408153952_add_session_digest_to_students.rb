class AddSessionDigestToStudents < ActiveRecord::Migration[7.0]
  def change
    add_column(:students, :session_digest, :string)
  end
end
