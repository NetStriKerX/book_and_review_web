class AddUserToReviews < ActiveRecord::Migration[7.0]
  def change
    add_reference :reviews, :user, null: true, foreign_key: true

    user = User.find_or_create_by!(email: 'test1@test.com')

    Review.find_each do |review|
      review.user = user
      review.save!
    end

    change_column_null :reviews, :user_id, false
  end
end
