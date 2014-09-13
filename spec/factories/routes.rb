FactoryGirl.define do
  factory :route_template do
    name "66 West Express"
    description "66 West Express"
    number 66
    direction "East"
    polyline "{at~Fxh|uOjAAAj@@tT@|L?bE_B@MIC?o@@kBDcAByBBgAB}B?]F_EBqEHY?U?yAC_EDgEFMEEAuDAy@Bg@@?q@?q@C{GGuN"
    active true
  end

  factory :location do
    name "Braun Alley, Chicago, IL 60606, USA"
    latitude "41.8871768"
    longitude "-87.6406068"
    direction "East"
  end

  factory :bus do
    capacity 60
    type "Full Bus"
    owner "R n R Buses"
    registation_number "XY11ZA2"
  end

  factory :route_templates_locations do
    route_template
    location
  end
end