FactoryGirl.define do
  factory :route do
    name "66 West Express"
    description "66 West Express"
    number 66
    direction "East"
    polyline "{at~Fxh|uOjAAAj@@tT@|L?bE_B@MIC?o@@kBDcAByBBgAB}B?]F_EBqEHY?U?yAC_EDgEFMEEAuDAy@Bg@@?q@?q@C{GGuN"
    active true
    locations {[create(:location)]}
  end

  factory :location do
    name "Braun Alley, Chicago, IL 60606, USA"
    lat "41.8871768"
    lng "-87.6406068"
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
  end
end