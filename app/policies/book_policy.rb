class BookPolicy < ApplicationPolicy
  def update?
    owner?
  end

  def destroy?
    owner?
  end
end
