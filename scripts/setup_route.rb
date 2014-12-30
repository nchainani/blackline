# route 1 - Lincoln Park Express
route = FactoryGirl.create(:route)

first_location = FactoryGirl.create(:location, name: "500 E Ohio St.", lat: "41.892682", lng: "-87.614672", direction: "East")

second_location = FactoryGirl.create(:location, name: "E Lake shore drive", lat: "41.900814", lng: "-87.623762", direction: "North")

destination = FactoryGirl.create(:location, name: "Lincoln Park", lat: "41.924738", lng: "-87.635814", direction: "West")

#route.locations.destroy_all

route.locations << first_location
route.locations << second_location
route.locations << destination

bus = FactoryGirl.create(:bus)

route.route_runs.create!(bus: bus, run_datetime: 2.hours.from_now, times: "5:15p,5:30p,5:45p,6:00p", amount: 299)
route.route_runs.create!(bus: bus, run_datetime: 4.hours.from_now, times: "7:15p,7:30p,7:45p,8:00p", amount: 299)
route.route_runs.create!(bus: bus, run_datetime: 6.hours.from_now, times: "9:15p,9:30p,9:45p,10:00p", amount: 299)
route.route_runs.create!(bus: bus, run_datetime: 7.hours.from_now, times: "10:15p,10:30p,10:45p,11:00p", amount: 299)

#FactoryGirl.create(:rider)

FactoryGirl.create(:pass_plan, name: "10 tickets for $20.99", description: "Buy 10 tickets for $20.99", amount: 2099, total_tickets: 10)
FactoryGirl.create(:pass_plan, name: "20 tickets for $35.99", description: "Buy 20 tickets for $35.99", amount: 3599, total_tickets: 20)
FactoryGirl.create(:pass_plan, name: "40 tickets for $65.99", description: "Buy 40 tickets for $65.99", amount: 6599, total_tickets: 40)
FactoryGirl.create(:pass_plan, name: "100 tickets for $120.99", description: "Buy 100 tickets for $120.99", amount: 12099, total_tickets: 100)


# route 2 - Willis Tower express

first_location = FactoryGirl.create(:location, name: "O'Hare, Chicago, IL", lat: "41.977217", lng: "-87.8366751", direction: "East")

#second_location = FactoryGirl.create(:location, name: "E Lake shore drive", lat: "41.900814", lng: "-87.623762", direction: "North")

destination = FactoryGirl.create(:location, name: "Willis Tower, S Wacker Drive, Chicago", lat: "41.8780876", lng: "-87.635881", direction: "East")

polyline = "ste_GfrbwOMsWEcOEqDEuNMwNmCSsCQ_TwAyDWGuIM{@Gm@EkAA{CBkBHiCGULsAh@}DXkBf@{Cv@kFRsBRuCNsFEqYIkj@Mgu@G}^?eGBmBFoAT}B`@aCZsAZ_AvAeDnH{OpCiGfSsb@bTcd@vA{Dd@{AlAqFRcAz@_GhAqE^oAnAiDpBkEnH}OXm@lG{MzAwCpDsGhCoEtAyCr@sB`A}DjAwFTs@`@}@`AsB~@cBv@iA~BsDdByCh@_ATSxDiHfGkM|A_D~EgKxFwMbBmDv@gBHS`CmFbA}BtJoSzIeRhDeHlBmEh@aBbAaDh@sA\\q@~@sA`BcBt@c@|@i@jIyDtB}@zBoAfA}@bBiBrA_Ct@eBr@}Bd@}Bh@qD`@kCl@mD^{A`@qA|AkDpBcEtAuCTi@fE{IdFaKxBoEr@_BnGgM`BkDjGaMbCyErGuMvAiDl@eBnByFbCgGrAoCbCcFlK_UzByEfAyB|IiR|CwGvFqLdNuYfBcDvAuB~@mAhCsCbB{AdAu@z@m@x@c@b@UPKpKqF|FyCnBkAh@[\\SrAs@jCkBp@o@dGkHjAkAz@q@jAs@z@a@x@Yz@SlAQbAGrA@jERpBFjB?|AIzAQ|B_@`Cu@`Bm@nBq@nGuBdBs@\\QbB}@h@]nAeA`B_BxAcBl@_AxBaEBELSvAcCjCcExBwD|A{ChAwBjCkEnAyBxAwCZi@|AgCd@q@fAiApCqC@ATUjC_BDCxAw@n@YbAWpCc@bBIrCEbAEdDAzACnAI|BCZALN@?x@FtAJv@Hh@JNMJAtCExAAhDLj@?A_@?S?g@AiAKef@E}LCeE"

route = FactoryGirl.create(:route, number: 101, name: "Willis Tower Express", description: "Ohare Airport (ORD) - Willis Tower", locations: [first_location, destination], polyline: polyline)



PassPlan.create!(offer_type: '3_free_tickets', amount: 0, currency: "USD", total_tickets: 3, offer: true, name: "new user - 3 free tickets", description: "new user - 3 free tickets")