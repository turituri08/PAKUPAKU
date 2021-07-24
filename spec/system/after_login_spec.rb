# frozen_string_literal: true

require 'rails_helper'

describe 'ログイン後のテスト' do
  
  before do
    visit new_user_registration_path
    fill_in 'user[name]', with: '田中'
    choose 'user[sex]',  with: '男性'
    fill_in 'user[email]', with: 'hoge@example.com'
    # select 'user[birthday]', from: '1989-01-01'
    fill_in 'user[user_name]', with: 'tanaka'
    choose 'user[child_gender]', with: '男の子'
    select '1歳', from: 'user[child_age]'
    fill_in 'user[password]', with: 'password'
    fill_in 'user[password_confirmation]', with: 'password'
    click_button '登録'
    user = User.last
    token = user.confirmation_token
    visit user_confirmation_path(confirmation_token: token)
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: 'password'
    click_button 'ログイン'
  end 
  
  it do
    user = User.last
    expect(current_path).to eq '/users/' + user.id.to_s
    notifications_link = find('h3.fa-bell')
    expect(notifications_link).to be_present
  end 
 
  
  
    # context 'フッターの表示内容の確認' do
      # it '新規投稿リンクが表示される' do
      # end
      # it 'マイページリンクが表示される' do
      # end
      # it 'ユーザー一覧リンクが表示される' do
      # end
      # it '投稿一覧リンクが表示される' do
      # end
      #   it '通知リンクが表示される' do
      #   end
    # end

end