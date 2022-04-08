class CreateStudents < ActiveRecord::Migration[7.0]
  def change
    create_table(:students) do |t|
      t.string(:email)
      t.string(:given_name)
      t.string(:middle_name)
      t.string(:family_name)

      t.index(:email, unique: true)

      t.timestamps()
    end
  end
end
