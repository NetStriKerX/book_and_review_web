class ReviewPolicy < ApplicationPolicy
  def update?
    user == record.user # Allow updating a book if the user is the owner of the book
  end

  def destroy?
    user == record.user # Allow deleting a book if the user is the owner of the book
  end
end
