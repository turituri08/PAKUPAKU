# frozen_string_literal: true

require 'rails_helper'

feature 'Sign up' do
  background do
    ActionMailer::Base.deliveries.clear
  end

  describe 'ログイン前のテスト' do
    describe 'top画面のテスト' do
      before do
        visit root_path
      end

      context '表示内容の確認' do
        it 'urlが正しい' do
          expect(current_path).to eq '/'
        end
        it 'アカウント作成のリンクが表示されている' do
          sign_up = find_all('a')[0].native.inner_text
          expect(page).to have_link sign_up, href: '/users/sign_up'
        end
        it 'ログインのリンクが表示されている' do
          sign_in = find_all('a')[1].native.inner_text
          expect(page).to have_link sign_in, href: '/users/sign_in'
        end
      end
    end

    describe 'ユーザー新規登録のテスト' do
      before do
        visit new_user_registration_path
      end

      # birthdayのtestの書き方がわからない(f.date_select)
      context '表示内容の確認' do
        it 'urlが正しい' do
          expect(current_path).to eq '/users/sign_up'
        end
        it 'nameフォームがある' do
          expect(page).to have_field 'user[name]'
        end
        it 'sexフォームがある' do
          expect(page).to have_field 'user[sex]'
        end
        # it 'birthdayフォームがある' do
        #   expect(page).to have_field 'user[birthday]'
        # end
        it 'user_nameフォームがある' do
          expect(page).to have_field 'user[user_name]'
        end
        it 'emailフォームがある' do
          expect(page).to have_field 'user[email]'
        end
        it 'child_genderフォームがある' do
          expect(page).to have_field 'user[child_gender]'
        end
        it 'child_ageフォームがある' do
          expect(page).to have_field 'user[child_age]'
        end
        it 'passwordフォームがある' do
          expect(page).to have_field 'user[password]'
        end
        it 'password_confirmationフォームがある' do
          expect(page).to have_field 'user[password_confirmation]'
        end
        it '登録ボタンが表示される' do
          expect(page).to have_button '登録'
        end
        it '戻るボタンが表示される' do
          rollback_btn = find_all('a')[1].native.inner_text
          expect(page).to have_link rollback_btn, href: '/'
        end
      end

      context '新規登録のテスト' do
        before do
          fill_in 'user[name]', with: '田中'
          choose 'user[sex]', with: '男性'
          fill_in 'user[email]', with: 'hoge@example.com'
          # select 'user[birthday]', from: '1989-01-01'
          fill_in 'user[user_name]', with: 'tanaka'
          choose 'user[child_gender]', with: '男の子'
          select '1歳', from: 'user[child_age]'
          fill_in 'user[password]', with: 'password'
          fill_in 'user[password_confirmation]', with: 'password'
        end
        it '登録ボタンをクリックするとtop画面に遷移する' do
          click_button '登録'
          expect(current_path).to eq '/'
          expect(page).to have_content '本人確認用のメールを送信しました。メール内のリンクからアカウントを有効化させてください。'
        end
        it '登録ボタンをクリックすると認証メールが送信され、メール内のリンクをクリックするとログインページに行き、ログインするとユーザー詳細ページへ' do
          expect { click_button '登録' }.to change { ActionMailer::Base.deliveries.size }.by(1)
          user = User.last
          token = user.confirmation_token
          visit user_confirmation_path(confirmation_token: token)
          expect(User.count == 1)
          expect(current_path).to eq '/users/sign_in'
          expect(page).to have_content 'アカウントを登録しました。'
          visit new_user_session_path
          fill_in 'user[email]', with: user.email
          fill_in 'user[password]', with: 'password'
          click_button 'ログイン'
          expect(current_path).to eq '/users/' + user.id.to_s
        end
      end
    end

    describe 'ユーザーログインのテスト' do
      before do
        visit new_user_session_path
      end

      context '表示内容の確認' do
        it 'urlが正しい' do
          expect(current_path).to eq '/users/sign_in'
        end
        it 'emailフォームがある' do
          expect(page).to have_field 'user[email]'
        end
        it 'passwordフォームがある' do
          expect(page).to have_field 'user[password]'
        end
        it 'ログインボタンが表示される' do
          expect(page).to have_button 'ログイン'
        end
        it 'ログインボタンが表示される' do
          expect(page).to have_button 'ログイン'
        end
        it 'パスワードをお忘れですかボタンが表示される' do
          forget_password_btn = find_all('a')[0].native.inner_text
          expect(page).to have_link forget_password_btn, href: '/users/password/new'
        end
        it '戻るボタンが表示される' do
          rollback_btn = find_all('a')[2].native.inner_text
          expect(page).to have_link rollback_btn, href: '/'
        end
      end

      context 'ログイン失敗のテスト' do
        before do
          fill_in 'user[email]', with: ''
          fill_in 'user[password]', with: ''
          click_button 'ログイン'
        end

        it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
          expect(current_path).to eq '/users/sign_in'
        end
      end
    end
  end
end
