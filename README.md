# GasPal

GasPal is an app to help drivers to track their vehicle's fuel consumption, receipts and services.
At the gas station, the user can take a picture of the receipt to save for the records. User can enter # of miles and gallons and the app calculates and stores the MPG. App supports OCR and can auto-fill information by reading the number of gallons/price from gas receipt, mileage from dashboard picture, drivers info from drivers license picture and vehicle info from VIN number picture.
App will track all receipts and fuel log and present a dashboard with charts and insights.

## User Stories
- [ ] User can use a tar bar to navigate between the screens: dashboard, profile, vehicle, tracking, and service
- [ ] User can see the Dashboard screen displaying the following information:
   - [ ] Last MPG, best MPG, average price paid
   - [ ] Charts for MPG, gas expenses, service expenses per time (Annual, monthly, weekly)
- [ ] User can view Profile screen and enter driver's information
   - [ ] Profile screen should contain full name, drivers license number, home address
   - [ ] User can enter driver's information by scanning drivers license
- [ ] User can enter/edit/view vehicle information
   - [ ] Vehicle screen should contain: make, model, year, VIN
   - [ ] User can enter vehicle information by scanning VIN
- [ ] User can see list of fuel-up entries showing: date, odometer, price, gallons and MPG
   - [ ] User can add a new fuel-up entry at the gas station
      - [ ] The following fields are available: date, current odometer, gallons, price, and gas station location
      - [ ] Vehicle mileage can be populated using a picture of the vehicle dashboard
      - [ ] Gallons and price can be populated by using a picture of the receipt
      - [ ] MPG is calculated as: MPG = (current odometer - last odometer) / gallons
- [ ] User can see list of service logs: date, location, price, description
   - [ ] User can add a new service log
