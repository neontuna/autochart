FactoryGirl.define do  factory :time_entry do
    hours_to_bill "9.99"
date_worked "2016-01-15 19:02:57"
ticket_id 1
autotask_id 1
  end
  factory :issue_type do
    name "MyString"
autotask_id 1
  end
  factory :ticket do
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