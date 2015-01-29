locations = ["3206 North Halsted Street, Chicago, IL", "2800 North Halsted Street, Chicago, IL", "2384 N Lincoln Ave, Chicago, IL", "2012 North Larrabee Street, Chicago, IL 60614,", "1600 North Larrabee Street, Chicago, IL 60614, USA", "800 North Larrabee Street, Chicago, IL 60654"]

CreateRoute.new.perform(locations)

route.polyline = "cm~~F`_~uOrIIxCIjGEnJQhJIrHGlBElEE~CGrHIjJQnDsF~BoDz@qAjGwJjAoBd@?fIMdUSlOUlQObDAjEKtYU~ECrEI`MOjOKNEjCI"

Bus.create!(capacity: 38, bus_type: "bus", owner: "M and M", registration_number: "234234")
route.route_runs.create!(bus_id: 1, run_datetime: Time.parse "2015-01-05 13:30:00", amount: 199, currency: :USD, times: "7:30,7:33,7:37,7:44,7:48,7:55")



start = Time.parse "2015-01-25 15:30:00"

30.times.each do |index|
  time = start + index.day
  time1 = start + index.day - 2.hours

  puts time
  puts time1
  puts "******"
  
  route.route_runs.create!(bus_id: 1,
    run_datetime: time1,
    times: "7:30,7:33,7:37,7:44,7:48,7:55", total_tickets: 38, amount: 199, currency: "USD")

  route.route_runs.create!(bus_id: 1,
    run_datetime: time,
    times: "9:30,9:33,9:37,9:44,9:48,9:55", total_tickets: 38, amount: 199, currency: "USD")
end