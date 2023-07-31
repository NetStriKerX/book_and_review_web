require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  shared_context 'when user not sign in' do
    it 'returns to sign in page' do
      expect(subject.status).to eq(302)
      expect(subject).to redirect_to(new_user_session_path)
    end
  end

  shared_context 'when input invalid' do
    it 'cannot create review' do
      expect(book.reviews.first).to eq(nil)
      expect(subject.status).to eq(302)
      expect(subject).to redirect_to(book_path(book))
    end
  end

  shared_context 'when update with invalid input' do
    it 'does not update the review' do
      subject
      review.reload
      expect(review.comment).to eq('Old Comment')
      expect(review.star).to eq(7)
    end
  end

  describe 'POST /create' do
    subject{ post :create, params: params}

    let(:user) { create(:user) }
    let(:book) { create(:book) }
    let(:params) { { book_id: book.id, review: { comment: 'This is a review', star: 5 } } }

    context 'when user sign in' do
      before { sign_in user }

      it 'creates a new review' do
        expect(subject).to redirect_to(book_path(book))
        expect(book.reviews.first.comment).to eq('This is a review')
        expect(book.reviews.first.star).to eq(5)
      end

      context 'when comment is blank' do
        let(:params) { { book_id: book.id, review: { comment: '', star: 5 } } }

        include_context 'when input invalid'
      end

      context 'when star is blank' do
        let(:params) { { book_id: book.id, review: { comment: 'This is a review', star: nil } } }

        include_context 'when input invalid'
      end

      context 'when star is less than zero' do
        let(:params) { { book_id: book.id, review: { comment: 'This is a review', star: -1 } } }

        include_context 'when input invalid'
      end

      context 'when star is more than ten' do
        let(:params) { { book_id: book.id, review: { comment: 'This is a review', star: 10.5 } } }

        include_context 'when input invalid'
      end
    end

    include_context 'when user not sign in'
  end

  describe 'GET /edit' do
    subject{ get :edit, params: params}

    let(:user) { create(:user) }
    let(:book) { create(:book) }
    let(:review) { create(:review, user: user, book: book) }
    let(:params) { { id: review.id, book_id: book.id } }

    context 'when user sign in' do
      before { sign_in user }

      it 'renders the edit review form' do
        subject
        expect(response).to render_template('edit')
      end

      it 'assigns the review to @review' do
        subject
        expect(assigns(:review)).to eq(review)
      end
    end

    include_context 'when user not sign in'
  end

  describe 'PUT /update' do
    subject { put :update, params: params }

    let(:user) { create(:user) }
    let(:book) { create(:book) }
    let!(:review) { create(:review, user: user, book: book, comment: 'Old Comment', star: 7) }
    let(:params) { { id: review.id,book_id: book.id, review: { comment: 'New Comment', star: 5 } } }

    context 'when user sign in' do
      before { sign_in user }

      it 'updates the review' do
        subject
        review.reload
        expect(review.comment).to eq('New Comment')
        expect(review.star).to eq(5)
      end

      it 'redirects to the book show page' do
        expect(subject).to redirect_to(book_path(review.book))
      end

      context 'when comment is null' do
        let(:params) { { id: review.id, book_id: book.id, review: { comment: '', star: 4 } } }

        include_context 'when update with invalid input'

        it 'redirects to the review edit page with error messages' do
          subject
          expect(response).to redirect_to(edit_book_review_path(review,book_id: book.id, error: ['Comment can\'t be blank']))
        end
      end

      context 'when star is null' do
        let(:params) { { id: review.id, book_id: book.id, review: { comment: 'New Comment', star: nil } } }

        include_context 'when update with invalid input'

        it 'redirects to the review edit page with error messages' do
          subject
          expect(response).to redirect_to(edit_book_review_path(review,book_id: book.id, error: ['Star can\'t be blank', 'Star is not a number']))
        end
      end

      context 'when star is less than zero' do
        let(:params) { { id: review.id, book_id: book.id, review: { comment: 'New Comment', star: -1 } } }

        include_context 'when update with invalid input'

        it 'redirects to the review edit page with error messages' do
          subject
          expect(response).to redirect_to(edit_book_review_path(review,book_id: book.id, error: ['Star must be greater than or equal to 0']))
        end
      end

      context 'when star is more than ten' do
        let(:params) { { id: review.id, book_id: book.id, review: { comment: 'New Comment', star: 11.7 } } }

        include_context 'when update with invalid input'

        it 'redirects to the review edit page with error messages' do
          subject
          expect(response).to redirect_to(edit_book_review_path(review,book_id: book.id, error: ['Star must be less than or equal to 10']))
        end
      end
    end

    context 'when user is not the owner of the review' do
      let(:other_user) { create(:user) }

      before { sign_in other_user }

      it 'raises a Pundit::NotAuthorizedError' do
        expect { subject }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    include_context 'when user not sign in'
  end

  describe 'DELETE /destroy' do
    subject { delete :destroy, params: params }

    let(:user) { create(:user) }
    let(:book) { create(:book) }
    let!(:review) { create(:review, user: user, book: book) }
    let(:params) { { id: review.id, book_id: book.id } }

    context 'when user is the owner of the review' do
      before { sign_in user }

      it 'destroys the review' do
        expect { subject }.to change(Review, :count).by(-1)
      end

      it 'redirects to the book show page' do
        subject
        expect(subject).to redirect_to(book_path(book))
      end
    end

    context 'when user is not the owner of the review' do
      let(:other_user) { create(:user) }

      before { sign_in other_user }

      it 'raises a Pundit::NotAuthorizedError' do
        expect { subject }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    include_context 'when user not sign in'
  end
end
