require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'valid factory' do
    subject(:factory) { build(:user) }

      it { is_expected.to be_valid }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email)}
    it { is_expected.to validate_presence_of(:password)}
    it { is_expected.to validate_length_of(:password).is_at_least(6)}
  end

  describe 'associations' do
    it { is_expected.to have_many(:books) }
    it { is_expected.to have_many(:reviews) }
  end
end
