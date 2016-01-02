include RandomData

FactoryGirl.define do
  sequence(:name) { |n| "LabelName#{n}"}

  factory :label do
    name
  end
end
