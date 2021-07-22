FactoryBot.define do
  factory :user do
    name { "田中" }
    sex {"男性"}
    email {"hoge@example.com"}
    user_name { "tanaka" }
    child_gender {"男の子"}
    child_age {"1歳"}
    password {"password"}
  end
end


