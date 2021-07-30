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

  let(:user) { User.last }

  it 'ログイン後の画面が自身のユーザ詳細ページである'do
    expect(current_path).to eq '/users/' + user.id.to_s
  end
  it 'ログアウトアイコンが存在する' do
    sign_out_icon = find('h5.fa-sign-out-alt')
    expect(sign_out_icon).to be_present
  end
  it 'ログアウトが成功する' do
    find('a[href="/users/sign_out"]').click
    expect(current_path).to eq '/'
  end

  context 'フッターの表示内容の確認' do
    it '通知アイコンが存在する' do
      notifications_icon = find('h3.fa-bell')
      expect(notifications_icon).to be_present
    end
    it 'クリックすると通知ページに遷移する' do
      find('a[href="/notifications"]').click
      expect(current_path).to eq '/notifications'
    end
    it '投稿一覧アイコンが存在する' do
      contents_icon = find('h3.fa-utensil-spoon')
      expect(contents_icon).to be_present
    end
    it 'クリックすると投稿一覧ページに遷移する' do
      find('a[href="/contents"]').click
      expect(current_path).to eq '/contents'
    end
    it 'ユーザー一覧アイコンが存在する' do
      users_icon = find('h3.fa-users')
      expect(users_icon).to be_present
    end
    it 'クリックするとユーザー一覧ページに遷移する' do
      find('a[href="/users"]').click
      expect(current_path).to eq '/users'
    end
    it 'ユーザー詳細アイコンが存在する' do
      home_icon = find('h3.fa-home')
      expect(home_icon).to be_present
    end
    # it 'クリックするとユーザー詳細ページに遷移する' do
    #   find('a[href="/users/#{user.id.to_s}"]').click
    #   expect(current_path).to eq '/users/' + user.id.to_s
    # end
    it '新規投稿アイコンが存在する' do
      contents_new_icon = find('h3.fa-pencil-alt')
      expect(contents_new_icon).to be_present
    end
    it 'クリックすると新規投稿ページに遷移する' do
      find('a[href="/contents/new"]').click
      expect(current_path).to eq '/contents/new'
    end
  end

  context 'ユーザー詳細ページの表示内容の確認' do
    it 'フォローしているユーザー一覧ページへのリンクが存在する' do
      expect(page).to have_link 'フォロー', href: '/users/' + user.id.to_s + '/user_followings'
    end
    it 'フォロワー一覧ページへのリンクが存在する' do
      expect(page).to have_link 'フォロワー', href: '/users/' + user.id.to_s + '/user_followers'
    end
    it '投稿一覧のリンクが存在する' do
      expect(page).to have_link '投稿', href: '/users/' + user.id.to_s
    end
    it 'いいね一覧のリンクが存在する' do
      expect(page).to have_link 'いいね', href: '/users/' + user.id.to_s + '/user_likes'
    end
    it 'お気に入り一覧のリンクが存在する' do
      expect(page).to have_link 'お気に入り', href: '/users/' + user.id.to_s + '/user_favorites'
    end
  end

  context '投稿成功のテスト' do
    before do
      visit new_content_path
      fill_in 'content[body]', with: '本文'
      attach_file "content[content_images_images][]", "app/assets/images/logo.jpg"
      select '1歳', from: 'content[target_age]'
    end

    it 'urlが正しい' do
      expect(current_path).to eq '/contents/new'
    end
    it '投稿が正しく保存される' do
      expect { click_button '投稿' }.to change(user.contents, :count).by(1)
    end
    it 'リダイレクト先のurlが正しい' do
      click_button '投稿'
      expect(current_path).to eq "/contents"
    end
    it '投稿内容が正しく表示されている' do
      click_button '投稿'
      expect(page).to have_text '本文'
      expect(page).to have_selector("img")
      expect(page).to have_text '1歳向けの投稿'
    end
    it '投稿一覧に投稿詳細画面へのurlが存在する' do
      click_button '投稿'
      content = Content.last
      expect(page).to have_link '', href: '/contents/' + content.id.to_s
    end

    context '投稿詳細画面のテスト' do

      before do
        click_button '投稿'
      end

      let(:content) { Content.last }

      it 'urlが正しい' do
        content = Content.last
        expect(page).to have_link '', href: '/contents/' + content.id.to_s
      end

    end
  end

end