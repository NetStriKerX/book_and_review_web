class AddUserToBooks < ActiveRecord::Migration[7.0]
  def change
    add_reference :books, :user, null: true, foreign_key: true

    user = User.find_or_create_by!(email: 'test1@test.com')

    Book.find_each do |book|
      book.user = user
      book.save!
    end

    change_column_null :books, :user_id, false
  end
end
