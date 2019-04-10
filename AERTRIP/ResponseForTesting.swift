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
