require 'rails_helper'

describe 'ログイン後のテスト' do

  let(:user) { create(:user) }

  before do
      visit new_user_session_path
      fill_in 'user[email]', with: "hoge@example.com"
      fill_in 'user[password]', with:"password"
      click_button 'ログイン'
  end

  context 'フッターの表示確認' do

    # it '新規投稿リンクが表示される' do
    # end
    # it 'マイページリンクが表示される' do
    # end
    # it 'ユーザー一覧リンクが表示される' do
    # end
    # it '投稿一覧リンクが表示される' do
    # end
    it '通知リンクが表示される' do
      notifications_link = find_all('a')[-1].native.inner_text
      binding.pry
    end
  end

end