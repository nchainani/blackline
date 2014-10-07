route = FactoryGirl.create(:route)

first_location = FactoryGirl.create(:location, name: "500 E Ohio St.", lat: "41.892682", lng: "-87.614672", direction: "East")

second_location = FactoryGirl.create(:location, name: "E Lake shore drive", lat: "41.900814", lng: "-87.623762", direction: "North")

destination = FactoryGirl.create(:location, name: "Lincoln Park", lat: "41.924738", lng: "-87.635814", direction: "West")

#route.locations.destroy_all

route.locations << first_location
route.locations << second_location
route.locations << destination

bus = FactoryGirl.create(:bus)

route.route_runs.create!(bus: bus, run_datetime: 2.hours.from_now, times: "5:15p,5:30p,5:45p,6:00p", amount: 2.99)
route.route_runs.create!(bus: bus, run_datetime: 4.hours.from_now, times: "7:15p,7:30p,7:45p,8:00p", amount: 2.99)
route.route_runs.create!(bus: bus, run_datetime: 6.hours.from_now, times: "9:15p,9:30p,9:45p,10:00p", amount: 2.99)
route.route_runs.create!(bus: bus, run_datetime: 7.hours.from_now, times: "10:15p,10:30p,10:45p,11:00p", amount: 2.99)

