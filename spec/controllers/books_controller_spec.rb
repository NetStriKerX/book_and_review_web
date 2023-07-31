require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  describe 'GET /index' do
    subject{ get :index }

    let(:user) { create(:user) }
    let!(:books) { create_list(:book, 10) }

    context 'when user sign in' do
      before { sign_in user }

      it 'retruns all books' do
        expect(subject.status).to eq(200)
        expect(assigns(:books)).to match_array(Book.all)
      end
    end

    context 'when user not sign in' do
      it 'returns to sign in page' do
        expect(subject.status).to eq(302)
        expect(subject).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET /show' do
    subject { get :show, params: params }

    let(:user) { create(:user) }
    let!(:book) { create(:book) }
    let(:params) { { id: book.id } }
    let!(:reviews) { create_list(:review, 10, book: book, user: user) }

    before { sign_in user }

    context 'when book exists' do
      it 'returns the book' do
        expect(subject.status).to eq(200)
        expect(assigns(:book)).to eq(Book.find(book.id))
      end
    end

    context 'when book does not exist' do
      let(:params) { { id: -1 } }

      it 'raises ActiveRecord::RecordNotFound' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when book has reviews' do
      it 'return all reviews of this book' do
        subject

        expect(assigns(:book).reviews).to eq(Book.find(book.id).reviews)
      end
    end
  end

  describe 'POST /create' do
    subject { post :create, params: params }

    let(:user) { create(:user) }
    let(:params) { { book: attributes_for(:book) } }

    before { sign_in user }

    it 'creates a new book' do
      expect { subject }.to change(Book, :count).by(1)
    end

    it 'redirects to the book show page' do
      subject
      expect(response).to redirect_to(book_path(assigns(:book)))
    end
  end

  describe 'GET /edit' do
    subject { get :edit, params: params }

    let(:user) { create(:user) }
    let!(:book) { create(:book, user: user) }
    let(:params) { { id: book.id } }

    before { sign_in user }

    it 'renders the edit book form' do
      subject
      expect(response).to render_template('edit')
    end

    it 'assigns the book to @book' do
      subject
      expect(assigns(:book)).to eq(book)
    end
  end

  describe 'PATCH /update' do
    subject { patch :update, params: params }

    let(:user) { create(:user) }
    let!(:book) { create(:book, user: user) }
    let(:params) { { id: book.id, book: { name: 'New Book Name' } } }

    before { sign_in user }

    it 'updates the book' do
      subject
      book.reload
      expect(book.name).to eq('New Book Name')
    end

    it 'redirects to the book show page' do
      subject
      expect(response).to redirect_to(book_path(book))
    end
  end

  describe 'DELETE /destroy' do
    subject { delete :destroy, params: params }

    let(:user) { create(:user) }
    let!(:book) { create(:book, user: user) }
    let(:params) { { id: book.id } }

    before { sign_in user }

    it 'destroys the book' do
      expect { subject }.to change(Book, :count).by(-1)
    end

    it 'redirects to the books index page' do
      subject
      expect(response).to redirect_to(books_path)
    end
  end
end
