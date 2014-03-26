# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :episode do
    url "MyString"
    author "MyString"
    content "MyText"
    summary "MyText"
    image_url "MyString"
    published "2014-03-26 11:04:02"
    podcast_id 1
  end
end
