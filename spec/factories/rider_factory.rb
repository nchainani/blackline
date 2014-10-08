FactoryGirl.define do
  factory :rider do
    first_name "John"
    last_name "Doe"
    email "john.doe@gmail.com"
    password "test_password"
  end

  factory :payment_detail do
    rider
    last4 "************4242"
    token "sdf23423sfsr243rwrwserfsef"
    customer_id "cus_124234234234"
    active true
  end

  factory :pass_plan do
    name "10 tickets for 20.99"
    description "Buy 10 tickets for 20.99"
    amount 2099
    currency "USD"
  end

  factory :pass do
    rider
    payment_detail
    pass_plan
    total_tickets 10
    remaining_tickets 10
    amount 1099
    currency "USD"
    status "confirmed"
    purchase_date Date.today
    expiry_date 1.year.from_now
  end

  factory :favorite_location do
    rider
    name "Braun Alley, Chicago, IL 60606, USA"
    description "Home"
    latitude "41.8871768"
    longitude "-87.6406068"
  end

  factory :ticket do
    rider
    route_run
    amount 599
    currency "USD"
    status "confirmed"
    payment {create(:payment_detail)}
  end

end