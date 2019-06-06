//
//  ResponseForTesting.swift
//  AERTRIP
//
//  Created by apple on 29/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

/* https://aertrip.com/api/v1/itinerary/get-payment-methods?it_id=5c9de61e9e795e17a67e6fa7 */

// {"success":true,"errors":[],"data":{"payment_modes":{"razorpay":{"id":"979","is_display":true,"label":"Razorpay","category":"online","method_type":"","types":[],"validation":{"max_amt":500000},"convenience_fees":0,"convenience_fees_wallet":0,"pg_id":"4"},"wallet":{"id":"8","is_display":true,"label":"Wallet","category":"online","method_type":"","types":[],"validation":[],"convenience_fees":0,"convenience_fees_wallet":0,"pg_id":"0"}},"bank_master":["The Financial Co-Operative Bank Ltd","Assciates Co-Operative Bank","J & K Bank","American Express","Allahabad Bank","Andhra Bank","Axis Bank","Bandhan Bank","Bank of Baroda","Bank of India","Bank of Maharashtra","Canara Bank","Catholic Syrian Bank","Central Bank of India","Citi Bank","City Union Bank","Corporation Bank","DBS Bank","DCB Bank","Dena Bank","Deutsche Bank","Dhanlaxmi Bank","Federal Bank","HDFC Bank","HSBC Bank","ICICI Bank","IDBI Bank","IDFC Bank","Indian Bank","Indian Overseas Bank","IndusInd Bank","Jammu and Kashmir Bank","Karnataka Bank","Karur Vysya Bank","Kotak Mahindra Bank","Lakshmi Vilas Bank","Nainital Bank","Oriental Bank of Commerce","Punjab & Sindh Bank","Punjab National Bank","RBL Bank","South Indian Bank","Standard Chartered Bank","State Bank of India","Syndicate Bank","Tamilnad Mercantile Bank","UCO Bank","Union Bank of India","United Bank of India","Vijaya Bank","YES Bank","Airtel Payments Bank","Fino Payment Bank","India Post Payments Bank","Paytm Payments Bank","A U Small Finance Bank","Capital Small Finance Bank","Coastal Local Area Bank Limited","Equitas Small Finance Bank","ESAF Small Finance Bank","Fincare Small Finance Bank","Janalakshmi Small Finance Bank","Krishna Bhima Samruddhi Local Area Bank Limited","Subhadra Local Area Bank Limited","Suryoday Small Finance Bank","Ujjivan Small Finance Bank","Utkarsh Small Finance Bank","Abhyudaya Co-Operative Bank","Adhyapaka Urban Co-Operative Bank","Ahmedabad Mercantile Co-Operative Bank","Akhand Anand Co-Operative Bank","Akola Janata Commercial Co-Operative Bank","Akola Urban Co-Operative Bank","Andhra Pradesh Mahesh Co-Operative Urban Bank","Apna Sahakari Co-Operative Bank Limited","Bassein Catholic Co-Operative Bank","Bharat Co-Operative Bank (Mumbai)","Bharati Sahakari Bank","Bombay Mercantile Co-Operative Bank","Chartered Mercantile M.B. Limited","Citizencredit Co-Operative Bank","Dakshin Barasat Service Co-Operative Society Private Limited","Dombivli Nagari Sahakari Bank Limited","Eenadu Urban Co-Operative Bank","Goa Urban Co-Operative Bank","Gopinath Patil Parsik Janata Sahakari Bank","Greater Bombay Co-Operative Bank","Indian Mercantile Co-Operative Bank","Jalgaon Janata Sahakari Bank","Janakalyan Sahakari Bank","Janalaxmi Co-Operative Bank","Janata Sahakari Bank","Junagadh Commercial Co-Operative Bank","Kallappanna Awade Ichalkaranji Janata Sahakari Bank","Kalupur Commercial Coop Bank","Kalyan Janata Sahakari Bank","Karad Urban Co-Operative Bank","Khamgaon Urban Co-Operative Bank","LIC Of India Staff Co-Operative Bank H.O. Pattom Thiruvananthapuram","Mahanagar Co-Operative Bank","Mapusa Urban Co-Operative Bankof Goa","Mehsana Urban Co-Operative Bank","Muneshwraswamy Bank","Nagar Urban Co-Operative Bank","Nagpur Nagrik Sahakari Bank","Nasik Merchant's Co-Operative Bank","New India Co-Operative Bank","NKGSB Co-Operative Bank","Nutan Nagarik Sahakari Bank","Pravara Sahakari Bank","Punjab & Maharashtra Co-Operative Bank","Rajdhani Nagar Sahkari Bank","Rajkot Nagrik Sahakari Bank","Rohit Kataria Co-Operative Bank","Rupee Co-Operative Bank","Sangli District Primary Teachers Bank Limited","Sangli Urban Co-Operative Bank","Saraswat Co-Operative Bank","Sardar Bhiladwala Pardi Peoples Coop Bank","Shamrao Vithal Co-Operative Bank","Shikshak Sahakari Bank","Shivalik Mercantile Co-Operative Bank","Solapur Janata Sahakari Bank","Surat Peoples Coop Bank","Thane Bharat Sahakari Bank","The Bardoli Nagarik Sahakari Bank Limited","The City Co-Operative Bank Limited","The Kapole Co-Operative Bank","The Surat District Co-Operative Bank Limited","The Surtex Co-Operative Bank Limited","TJSB Sahakari Bank","Varchha Co-op Bank","Zoroastrian Co-Operative Bank","Andamanand Nicobar State Co-Operative Bank","Andhra Pradesh State Co-Operative Bank","Arunachal Pradesh State Co-Operative Apex Bank","Assam Co-Operative Apex Bank","Bihar State Co-Operative Bank","Chandigarh State Co-Operative Bank","Chhattisgarh Rajya Sahakari Bank Maryadit","Delhi State Co-Operative Bank","Goa State Co-Operative Bank","Gujarat State Co-Operative Bank","Haryana State Co-Operative Apex Bank","Himachal Pradesh State Co-Operative Bank","Jammuand Kashmir State Co-Operative Bank","Jharkhand State Co-Operative Bank","Karnataka State Co-Operative Apex Bank Bangalore","Kerala State Co-Operative Bank","Madhya Pradesh Rajya Sahakari Bank Maryadit","Maharashtra State Co-Operative Bank","Manipur State Co-Operative Bank","Meghalaya Co-Operative Apex Bank","Mizoram Co-Operative Apex Bank","Nagaland State Co-Operative Bank","Odisha State Co-Operative Bank","Pondichery State Co-Operative Bank","Punjab State Co-Operative Bank","Rajasthan State Co-Operative Bank","Sikkim State Co-Operative Bank","Telangana State Co-Operative Apex Bank Limited","The Tamil Nadu State Apex Co-Operative Bank","Tripura State Co-Operative Bank","Uttar Pradesh Co-Operative Bank","Uttarakhand State Co-Operative Bank","West Bengal State Co-Operative Bank"],"payment_details":{"net_amount":6858,"allow_part_payment":0,"allow_point_usage":0,"min_amount":0,"wallet":0,"points":0}}}

/* https://aertrip.com/api/v1/hotels/itinerary?action=traveller&it_id=5c9de61e9e795e17a67e6fa7 */

// {"success":true,"errors":[],"data":{"itinerary":{"id":"5c9de61e9e795e17a67e6fa7","currency_pref":"INR","gross_amount":"6858","net_amount":"6858","price_change":"0","coupons":[]},"vcode":"gn"}}

// confirmation api Response

//Giving rajan  for pod file



// Response for Booking Product= hotel Info

/*
{"success":true,"errors":[],"data":{"id":"9929","booking_number":"B\/19-20\/6","booking_date":"2019-04-03 16:40:16","communication_number":"???????? +91 9716218","depart":"","billing_info":{"email":"rahulTest@yopmail.com","communication_number":"???????? +91 9716218","billing_name":"Rahul Singh","gst":null,"address":{"address_line1":"106","address_line2":"Gandhi Colony","city":"Ghaziabad","state":null,"postal_code":"201009","country":"AS"}},"product":"hotel","category":"domestic","trip_type":"single","special_fares":"0","bdetails":{"booking_hotel_id":"3792","hotel_address":"70(0) Central Avenue Road, Near Ambedkar Garden, Chembur East 400071, Mumbai, Maharashtra, Mumbai, India Pin - 400 071","country":"IN","is_refundable":false,"rooms":1,"room_details":[{"rid":"4017","room_type":"Executive Room","includes":{"Inclusions":["Room Only"],"Notes":["For any reservation, a WI-Fi coupon will be available for guest at the lobby area.,Please note that any changes in tax structure due to government policies will result in revised taxes, which will be applicable to all reservations and will be charged additionally during check out.","Children 2-4 - Must use an extra bed","Infants 0-0- Stay for free if using existing bedding","Note, if you need a cot there may be an extracharge"]},"status":"pending","room_img":"","guests":[{"gender":"male","name":"Harsh Singh","salutation":"Mr","dob":"","age":""}],"amount_paid":31748,"cancellation_charges":0,"net_refund":"","voucher":""}],"pax":["Harsh Singh"],"latitude":"18.9756224","longitude":"72.8347005","cancellation":{"cancellation_penalty":{"is_refundable":"0","penalty_description":["Non Refundable, cancellation not allowed."]},"cancellation_charges":[]},"hotel_phone":"+91 98693 60956","hotel_email":"","hotel_name":"Hotel Plaza","city":"Mumbai","hotel_img":"https:\/\/cdn.grnconnect.com\/hotels\/images\/e7\/bd\/e7bd31558b4b12618ca132e27f0fe595bd36e595.jpg","hotel_star_rating":"4.0","ta_rating":"0.0","ta_review_count":"0","hotel_id":"144284","nights":9,"check_in":"2019-08-07 00:00:00","check_out":"2019-08-16 00:00:00","note":"","event_start_date":"2019-08-07 00:00:00","event_end_date":"2019-08-16 00:00:00"},"itinerary_id":"","cases":[],"receipt":{"vouchers":[{"basic":{"event":"Receipt","type":"Receipt","type_slug":"receipt","voucher_no":"RT\/19-20\/2765","transaction_datetime":"2019-04-03 16:40:15","transaction_id":12956},"transactions":[{"amount":"-31748.00","ledger_name":"RazorPay"}],"paymentinfo":{"order_id":"order_CFA0Y7rYyzzsEn","pg_fee":"64962","pg_tax":"9910","trans_date":"2019-04-03 16:39:56","payment_id":"pay_CFA0i1FgFEHp3r","method":"netbanking","bank_name":"ICIC"}},{"basic":{"id":"2","voucher_type":"sales","name":"Sales","event":"Booking","type":"Sales","type_slug":"sales","pattern":"S\/{fyear}\/","last_number":"8252","is_active":"1","voucher_no":"S\/19-20\/7725","transaction_datetime":"2019-04-03 16:40:16","transaction_id":"12957"},"transactions":{"Taxes and Fees":{"codes":{"79":{"ledger_name":"Round Off","amount":0.03}},"total":0.03},"Net Fare":{"amount":31748},"Grand Total":{"amount":31748},"Total Payable Now":{"amount":31748},"Total":{"amount":31748}}}],"total_amount_due":0,"total_amount_paid":31748},"total_amount_paid":31748,"vcode":"gn","bstatus":"pending","documents":[],"addon_request_allowed":false,"cancellation_request_allowed":false,"reschedule_request_allowed":false,"special_request_allowed":true,"user":{"pax_id":23401,"email":"rahulTest@yopmail.com","billing_name":"Rahul Singh","mobile":"9716218822","credit_type":"B","isd":"+91","points":0,"account_data":{"bill":{"total_overdue":{"amount":139720,"number":92},"total_outstanding":205900,"recent_charges":66180},"credit":{"credit_limit":"200000.00","current_balance":205900,"available_credit":-5900}},"profile_name":"Rahu fdfasd","profile_img":""}}}
*/

// Response for Booking Product= flight Info

/*
{"success":true,"errors":[],"data":{"id":"10496","booking_number":"B\/19-20\/517","booking_date":"2019-05-29 11:21:11","communication_number":"+91 9716218820","depart":"","billing_info":{"email":"rahulTest@yopmail.com","communication_number":"+91 9716218820","billing_name":"Rahul Singh","gst":null,"address":{"address_line1":"Noida Sector 52 Metro Station, Sector 52","address_line2":"","city":"Noida","state":"Uttar Pradesh","postal_code":"201301","country":"IN"}},"product":"flight","category":"international","trip_type":"multi","special_fares":"1","bdetails":{"trip_cities":["DEL","LHR","DXB","DEL","SIN"],"travelled_cities":"","disconnected":true,"routes":[["DEL","LHR"],["DXB","DEL","SIN"]],"leg":[{"leg_id":"6906","origin":"DEL","destination":"LHR","ttl":"Delhi - London","stops":0,"refundable":1,"reschedulable":1,"fare_name":"","flights":[{"flight_id":"10410","departure":"DEL","departure_airport":"Indira Gandhi International Airport","departure_terminal":"T-3","departure_country":"India","departure_country_code":"IN","depart_city":"Delhi","depart_date":"2019-06-09","departure_time":"12:30","arrival":"LHR","arrival_airport":"London Heathrow Airport","arrival_terminal":"T-3","arrival_country":"United Kingdom","arrival_city":"London","arrival_country_code":"GB","arrival_date":"2019-06-09","arrival_time":"17:35","flight_time":"34500","carrier":"Virgin Atlantic Airways ","carrier_code":"VS","flight_number":"301","equipment":"346","quality":0,"cabin_class":"Economy","operated_by":"","baggage":{"bg":{"ADT":"2 Pcs","notes":"Most Airlines typically allow 23 Kgs per piece"},"cbg":{"ADT":{"weight":"10 Kgs","piece":null,"dimension":{"cm":{"width":36,"height":56,"depth":23}}}}},"lcc":0,"origin_weather":{"max_temperature":48,"min_temperature":38,"weather":"Clear sky","weather_icon":"800-clear-sky"},"dest_weather":{"max_temperature":20,"min_temperature":12,"weather":"Broken clouds","weather_icon":"803-broken-clouds"},"layover_time":"0","change_of_plane":0,"booking_class":"L","fbn":"Economy Classic"}],"halts":"","pax":[{"pax_id":"18613","upid":"23475","salutation":"Mrs","first_name":"Hema","last_name":"Bhabhi","pax_name":"Hema Bhabhi","pax_type":"ADT","status":"pending","amount_paid":60706.33,"cancellation_charge":"","reschedule_charge":"","ticket":"","pnr":"","addons":[],"in_process":true},{"pax_id":"18614","upid":"28139","salutation":"Mr","first_name":"Sarthak Gupta","last_name":"Gupta","pax_name":"Sarthak Gupta Gupta","pax_type":"ADT","status":"pending","amount_paid":60706.33,"cancellation_charge":"","reschedule_charge":"","ticket":"","pnr":"","addons":[],"in_process":false}],"completed":0,"leg_status":"","apc":""},{"leg_id":"6907","origin":"DXB","destination":"DEL","ttl":"Dubai - Delhi","stops":0,"refundable":1,"reschedulable":1,"fare_name":"","flights":[{"flight_id":"10411","departure":"DXB","departure_airport":"Dubai Airport","departure_terminal":"T-1","departure_country":"United Arab Emirates","departure_country_code":"AE","depart_city":"Dubai","depart_date":"2019-06-12","departure_time":"00:05","arrival":"DEL","arrival_airport":"Indira Gandhi International Airport","arrival_terminal":"T-3","arrival_country":"India","arrival_city":"Delhi","arrival_country_code":"IN","arrival_date":"2019-06-12","arrival_time":"05:00","flight_time":"12300","carrier":"Air India ","carrier_code":"AI","flight_number":"996","equipment":"788","quality":0,"cabin_class":"Economy","operated_by":"","baggage":{"bg":{"ADT":"2 Pcs","notes":"Most Airlines typically allow 23 Kgs per piece"},"cbg":{"ADT":{"weight":"8 Kgs","piece":null,"dimension":{"cm":{"width":35,"height":55,"depth":25}}}}},"lcc":0,"origin_weather":{"max_temperature":35,"min_temperature":34,"weather":"Clear sky","weather_icon":"800-clear-sky"},"dest_weather":{"max_temperature":46,"min_temperature":38,"weather":"Clear sky","weather_icon":"800-clear-sky"},"layover_time":"0","change_of_plane":0,"booking_class":"Q","fbn":""}],"halts":"","pax":[{"pax_id":"18615","upid":"23475","salutation":"Mrs","first_name":"Hema","last_name":"Bhabhi","pax_name":"Hema Bhabhi","pax_type":"ADT","status":"pending","amount_paid":60706.33,"cancellation_charge":"","reschedule_charge":"","ticket":"","pnr":"","addons":[],"in_process":false},{"pax_id":"18616","upid":"28139","salutation":"Mr","first_name":"Sarthak Gupta","last_name":"Gupta","pax_name":"Sarthak Gupta Gupta","pax_type":"ADT","status":"pending","amount_paid":60706.33,"cancellation_charge":"","reschedule_charge":"","ticket":"","pnr":"","addons":[],"in_process":false}],"completed":0,"leg_status":"","apc":""},{"leg_id":"6908","origin":"DEL","destination":"SIN","ttl":"Delhi - Singapore","stops":0,"refundable":1,"reschedulable":1,"fare_name":"","flights":[{"flight_id":"10412","departure":"DEL","departure_airport":"Indira Gandhi International Airport","departure_terminal":"T-3","departure_country":"India","departure_country_code":"IN","depart_city":"Delhi","depart_date":"2019-06-21","departure_time":"09:00","arrival":"SIN","arrival_airport":"Changi International Airport","arrival_terminal":"","arrival_country":"Singapore","arrival_city":"Singapore","arrival_country_code":"SG","arrival_date":"2019-06-21","arrival_time":"17:25","flight_time":"21300","carrier":"Singapore Airlines ","carrier_code":"SQ","flight_number":"401","equipment":"787","quality":0,"cabin_class":"Economy","operated_by":"","baggage":{"bg":{"ADT":"35 Kgs","notes":null},"cbg":{"ADT":{"weight":"7 Kgs","piece":null,"dimension":{"cm":{"width":40,"height":55,"depth":20}}}}},"lcc":0,"origin_weather":[],"dest_weather":[],"layover_time":"0","change_of_plane":0,"booking_class":"Y","fbn":""}],"halts":"","pax":[{"pax_id":"18617","upid":"23475","salutation":"Mrs","first_name":"Hema","last_name":"Bhabhi","pax_name":"Hema Bhabhi","pax_type":"ADT","status":"pending","amount_paid":60706.33,"cancellation_charge":"","reschedule_charge":"","ticket":"","pnr":"","addons":[],"in_process":false},{"pax_id":"18618","upid":"28139","salutation":"Mr","first_name":"Sarthak Gupta","last_name":"Gupta","pax_name":"Sarthak Gupta Gupta","pax_type":"ADT","status":"pending","amount_paid":60706.33,"cancellation_charge":"","reschedule_charge":"","ticket":"","pnr":"","addons":[],"in_process":false}],"completed":0,"leg_status":"","apc":""}],"journey_completed":0,"pax":["Hema Bhabhi","Sarthak Gupta Gupta"],"note":"","event_start_date":"2019-06-09 09:00:00","event_end_date":"2019-06-21 17:25:00"},"itinerary_id":"","cases":[{"id":"7400","case_id":"CS\/19-20\/641","case_type":"Add-on Request","type_slug":"addon_request","case_name":"DEL (3)","case_status":"Open","resolution_status_id":"2","resolution_status":"Payment Pending","request_date":"2019-06-03 15:59:46","csr_name":"","resolution_date":null,"closed_date":null,"flag":"0","note":null}],"receipt":{"vouchers":[{"basic":{"event":"Receipt","type":"Receipt","type_slug":"receipt","voucher_no":"RT\/19-20\/2790","transaction_datetime":"2019-05-29 11:21:09","transaction_id":14467},"transactions":[{"amount":"-364238.00","ledger_name":"RazorPay"}],"paymentinfo":{"order_id":"order_CbEUO18ghXeLxR","pg_fee":"745275","pg_tax":"113686","trans_date":"2019-05-29 11:21:04","payment_id":"pay_CbEUcM24k8zerW","method":"netbanking","bank_name":"HDFC"}},{"basic":{"id":"2","voucher_type":"sales","name":"Sales","event":"Booking","type":"Sales","type_slug":"sales","pattern":"S\/{fyear}\/","last_number":"8252","is_active":"1","voucher_no":"S\/19-20\/8236","transaction_datetime":"2019-05-29 11:21:12","transaction_id":"14468"},"transactions":{"Base Fare":{"amount":324900},"Taxes and Fees":{"codes":{"2":{"ledger_name":"Fuel Surcharge","amount":19050},"5":{"ledger_name":"Passenger Service Fees","amount":980},"66":{"ledger_name":"Airline GST","amount":17198},"14":{"ledger_name":"Other Taxes & Fees","amount":4546}},"total":41774},"Gross Fare":{"amount":366674},"Discounts":{"codes":{"26":{"ledger_name":"Discount","amount":-2436}},"total":-2436},"Grand Total":{"amount":364238},"Total Payable Now":{"amount":364238},"Total":{"amount":364238}}}],"total_amount_due":0,"total_amount_paid":364238},"total_amount_paid":364238,"vcode":"ric","bstatus":"pending","documents":[],"addon_request_allowed":false,"cancellation_request_allowed":true,"reschedule_request_allowed":true,"special_request_allowed":false,"user":{"pax_id":23401,"email":"rahulTest@yopmail.com","billing_name":"Rahul Singh","mobile":"9716218822","credit_type":"B","isd":"+91","points":0,"account_data":{"bill":{"total_overdue":{"amount":139720,"number":92},"total_outstanding":205900,"recent_charges":66180},"credit":{"credit_limit":"200000.00","current_balance":205900,"available_credit":-5900}},"profile_name":"Rahu fdfasd","profile_img":""}}}

 */


// -=============Response for Booking product= Other

  /* {"success":true,"errors":[],"data":{"id":"9706","booking_number":"B\/18-19\/8810","booking_date":"2019-01-27 12:26:04","communication_number":"+91 9716218822","depart":"","billing_info":{"email":"rahulTest@yopmail.com","communication_number":"+91 9716218822","billing_name":"Rahul Singh","gst":"","address":{"address_line1":"Noida Sector 52 Metro Station, Sector 52","address_line2":"","city":"Noida","state":"Uttar Pradesh","postal_code":"201301","country":"IN"}},"product":"other","category":"","trip_type":"single","special_fares":"0","bdetails":{"booking_date":"2019-01-27 12:26:04","title":"Visa","details":"3 X Visa Amsterdam","travellers":[{"id":"17177","booking_id":"9706","ref_table":"booking_others","ref_table_id":"6","pax_type":"ADT","pax_id":"136","salutation":"Mr","first_name":"Rahul","middle_name":null,"last_name":"Dhande","age":"1","dob":"2017-06-01","gender":"male","pax_status":"1","status_id":null,"lead_pax":"1","pnr":null,"pnr_sector":null,"ticket_no":"","crs_pnr":"","added_while_booking":"0","pax_group":null,"added_on":"2019-01-27 12:27:56","updated_on":null,"pax_name":"Rahul Dhande"},{"id":"17178","booking_id":"9706","ref_table":"booking_others","ref_table_id":"6","pax_type":"ADT","pax_id":"23801","salutation":"Mr","first_name":"Yash","middle_name":null,"last_name":"Khutiya","age":"1","dob":"2017-07-01","gender":"male","pax_status":"1","status_id":null,"lead_pax":"0","pnr":null,"pnr_sector":null,"ticket_no":"","crs_pnr":"","added_while_booking":"0","pax_group":null,"added_on":"2019-01-27 12:27:57","updated_on":null,"pax_name":"Yash Khutiya"}],"note":"","event_start_date":"2019-01-27 12:27:56","event_end_date":"2019-01-27 12:27:56"},"itinerary_id":"","cases":[],"receipt":{"vouchers":[{"basic":{"id":"2","voucher_type":"sales","name":"Sales","event":"Booking","type":"Sales","type_slug":"sales","pattern":"S\/{fyear}\/","last_number":"8252","is_active":"1","voucher_no":"S\/18-19\/7511","transaction_datetime":"2019-01-27 12:26:00","transaction_id":"12322"},"transactions":{"Net Fare":{"amount":0},"Grand Total":{"amount":0},"Total Payable Now":{"amount":0},"Total":{"amount":0}}}],"total_amount_due":2900,"total_amount_paid":0},"total_amount_paid":0,"vcode":"ric","bstatus":"booked","documents":[],"addon_request_allowed":false,"cancellation_request_allowed":null,"reschedule_request_allowed":false,"special_request_allowed":false,"user":{"pax_id":23401,"email":"rahulTest@yopmail.com","billing_name":"Rahul Singh","mobile":"9716218822","credit_type":"B","isd":"+91","points":0,"account_data":{"bill":{"total_overdue":{"amount":139720,"number":92},"total_outstanding":205900,"recent_charges":66180},"credit":{"credit_limit":"200000.00","current_balance":205900,"available_credit":-5900}},"profile_name":"Rahu fdfasd","profile_img":""}}}
 
 */
