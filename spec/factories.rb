FactoryGirl.define do  factory :ticket do
    title "MyString"
issue_type_id 1
client_id 1
autotask_id 1
  end

  
  factory :client do
    sequence(:name) { |n| "Foo#{n}bar Inc"}
    sequence(:autotask_id) { |n| "#{n}"}  
  end

end