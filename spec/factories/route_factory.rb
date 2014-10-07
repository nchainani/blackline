FactoryGirl.define do
  factory :route do
    name "Lincoln Park Express"
    description "Navy Pier - Lincoln Park"
    number 66
    direction "East"
    polyline "{cu~F`|wuOMsTCIKIU?[Fm@Zo@`@{C~A{ChBaDdBuFfDuBtA_N|HyBlAa@\\O^Ad@XzU@j@qAYmB]y@Qm@Gk@@gALs@PwAj@kAb@}@PiDp@y@TQLm@LeDn@}GfAkEn@}BN_JN}@BeALkDdAQHuMhFoIhDqIlCcHpAwFv@oRbEs@OcB?uB@a@@]HN~A@FDb@h@zFD`@`@vG@zF?tBfA[d@KjAGD?"
    active true
    locations {[create(:location)]}
  end

  factory :location do
    name "355 E Ohio St."
    lat "41.8926246"
    lng "-87.6180863"
    direction "East"
  end

  factory :bus do
    capacity 60
    bus_type "Full Bus"
    owner "R n R Buses"
    registration_number "XY11ZA2"
  end

  factory :route_run do
    route
    bus
    run_datetime 2.hours.from_now
    times "4.30p"
    total_tickets 60
    amount 5.99
    currency "USD"
  end
end