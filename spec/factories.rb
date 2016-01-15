FactoryGirl.define do
  
  factory :client do
    sequence(:name) { |n| "Foo#{n}bar Inc"}
    sequence(:autotask_id) { |n| "#{n}"}  
  end

end