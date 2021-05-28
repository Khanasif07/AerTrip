//
//  CurrencyModel.swift
//  AERTRIP
//
//  Created by Admin on 25/08/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

struct CurrencyModel:Codable {

    var currencySymbol : String = ""
    var currencyIcon: String  = ""
    var group:String  = ""
    var display_format:String  = ""
    var textSuffix:Bool  = false
    var currencyName:String  = ""
    var cancellation_rate:Double = 0.0
    var rate:Double = 1.0
    var text:String = ""
    var currencyCode:String = ""
    
    init(json: JSON, code:String) {
//        currencyId = json[APIKeys.id.rawValue].stringValue
        currencyCode = code//json[APIKeys.currency_code.rawValue].stringValue
        currencyName = json[APIKeys.name.rawValue].stringValue
        let symbol = Currencies.getCurrencySymbol(currencyCode: currencyCode)
//        if symbol.isEmpty {
//            symbol = StaticCurrencies.getSymbolForCurrencyCode(code: json[APIKeys.currency_code.rawValue].stringValue)
//        }
        self.currencySymbol = symbol
        currencyIcon = json["icon"].stringValue
        
        self.group = json["group"].stringValue.removeNull
        self.display_format = json["display_format"].stringValue.removeNull
        self.textSuffix = json["textSuffix"].boolValue
        self.cancellation_rate = json["cancellation_rate"].doubleValue
        self.rate = json["rate"].doubleValue
        self.text = json["text"].stringValue.removeNull
        
    }
    
    static func retunCurrencyModelArray(json: [String : JSON]) -> [CurrencyModel] {
        var array = [CurrencyModel]()
        for (key , obj) in json {
        array.append(CurrencyModel(json: obj, code: key))
        }
        return array
    }

    
}



enum Currencies:String{
    
    case INDIAN_RUPEE = "INR";
    case USD_DOLLAR = "USD";
    case JAPANESE_YEN = "JYP";
    case ALBANIAN_LEK = "ALL";
    case ALGERIAN_DINAR  = "DZD";
    case EURO  = "EUR";
    case BRITISH_POUNT  = "GBP";
    case ARGENTINE_PESO  = "ARS";
    case ARMENIAN_DRAM  = "AMD";
    case ARUBAN_FLORIN  = "AWG";
    case AUSTRALIAN_DOLLAR  = "AUD";
    case BAHAMIAN_DOLLAR  = "BSD";
    case BANGLADESHI_TAKA  = "BDT";
    case BARBADIAN_DOLLAR  = "BBD";
    case BELIZE_DOLLAR  = "BZD";
    case BERMUDIAN_DOLLAR  = "BMD";
    case BOLIVIAN_BOLIVIANO  = "BOB";
    case BOTSWANA_PULA  = "BWP";
    case BRUNEI_DOLLAR  = "BND";
    case BURMESE_KYAT  = "MMK";
    case CAMBODIAN_RIEL = "KHR";
    case CANADIAN_DOLLAR  = "CAD";
    case CAYMAN_ISLANDS_DOLLAR  = "KYD";
    case CHINESE_YUAN  = "CNY";
    case COLOMBIAN_PESO  = "COP";
    case COSTA_RICAN_COL  = "CRC";
    case CROATIAN_KUNA  = "HRK";
    case CZECH_KORUNA  = "CZK";
    case DANISH_KRONE  = "DKK";
    case DOMINICAN_PESO  = "DOP";
    case EGYPTIAN_POUND  = "EGP";
    case ETHIOPIAN_BIRR  = "ETB";
    case FIJIAN_DOLLAR  = "FJD";
    case GAMBIAN_DALASI  = "GMD";
    case GIBRALTAR_POUND  = "GIP";
    case GUATEMALAN_QUETZAL  = "GTQ";
    case GUYANESE_DOLLAR  = "GYD";
    case HAITIAN_GOURDE  = "HTG";
    case HONDURAN_LEMPIRA  = "HNL";
    case HONG_KONG_DOLLAR  = "HKD";
    case HUNGARIAN_FORINT  = "HUF";
    case INDONESAIN_RUPIAH  = "IDR";
    case ISRAELI_NEW_SHEKEL  = "ILS";
    case JAMAICAN_DOLLAR  = "JMD";
    case KAZAKHSTANI_TENGE  = "KZT";
    case KENYAN_SHILLING  = "KES";
    case KYRGYZZTANI_SOM  = "KGS";
    case LAO_KIP  = "LAK";
    case LEBANESE_POUND  = "LBP";
    case LESOTHO_LOTI  = "LSL";
    case LIBERIAN_DOLLAR  = "LRD";
    case MACANESE_PATACA  = "MOP";
    case MACEDONIAN_DENAR  = "MKD";
    case MALAWIAN_KWACHA  = "MWK";
    case MALAYSIAN_RINGGIT  = "MYR";
    case MALDIVIAN_RUFIYAA  = "MVR";
    case MAURITIAN_RUPEE  = "MUR";
    case MEXICAN_PESO  = "MXN";
    case MOLDOVAN_LEU  = "MDL";
    case MONGOLIAN_T  = "MNT";
    case MOROCCAN_DIRHAM  = "MAD";
    case NAMIBIAN_DOLLAR  = "NAD";
    case NEPALESE_RUPEE  = "NPR";
    case NEW_ZEALAND_DOLLAR  = "NZD";
    case NICARAGUAN_C  = "NIO";
    case NIGERIAN_NAIRA  = "NGN";
    case NORWEGIAN_KRONE  = "NOK";
    case PAKISTANI_RUPEE  = "PKR";
    case PAPUA_NEW_GUINEAN_KINA  = "PGK";
    case PERUVIAN_SOl  = "PEN";
    case PHILIPPINE_PESO  = "PHP";
    case QATARI_RIYAL  = "QAR";
    case RUSSAIN_RUBLE  = "RUB";
    case SAUDI_RIYAL  = "SAR";
    case SEYCHELLOIS_RUPEE  = "SCR";
    case SIERRA_LEONEAN_LEONE  = "SLL";
    case SINGAPORE_DOLLAR  = "SGD";
    case SOMALI_SHILLING  = "SOS";
    case SOUTH_AFRICAN_RAND  = "ZAR";
    case SRILANKAN_RUPEE  = "LKR";
    case SWAZI_LILANGENi  = "SZL";
    case SWEDISH_KRONA  = "SEK";
    case SWISS_FRANC  = "CHF";
    case TANZANIAN_SHILLING  = "TZS";
    case THAI_BAHT  = "THB";
    case TRINIDAD_AND_TOBAGO  = "TTD";
    case UNITED_ARAB  = "AED";
    case URUGUAYAN_PESO  = "UYU";
    case UZBEKISTANI_SOM  = "UZS";
    case YEMENI_RIAL  = "YER";
    case SALVADORAN_COLON  = "SVC";
    
    static func  getCurrencySymbol(currencyCode: String) -> String{
        var symbol = "";
        guard let currency = Currencies(rawValue: currencyCode) else {return ""}
        switch (currency) {
        case .INDIAN_RUPEE:
            symbol = "₹";
            break;
        case .USD_DOLLAR:
            symbol = "$";
            break;
        case .JAPANESE_YEN:
            symbol = "¥";
            break;
        case .ALBANIAN_LEK:
            symbol = "L";
            break;
        case .ALGERIAN_DINAR:
            symbol = "DA";
            break;
        case .EURO:
            symbol = "€";
            break;
        case .BRITISH_POUNT:
            symbol = "£";
            break;
        case .ARGENTINE_PESO:
            symbol = "$a";
            break;
        case .ARMENIAN_DRAM:
            symbol = "֏";
            break;
        case .ARUBAN_FLORIN:
            symbol = "Afl.";
            break;
        case .AUSTRALIAN_DOLLAR:
            symbol = "A$";
            break;
        case .BAHAMIAN_DOLLAR:
            symbol = "B$";
            break;
        case .BANGLADESHI_TAKA:
            symbol = "৳";
            break;
        case .BARBADIAN_DOLLAR:
            symbol = "Bds$";
            break;
        case .BELIZE_DOLLAR:
            symbol = "BZ$";
            break;
        case .BERMUDIAN_DOLLAR:
            symbol = "BD$";
            break;
        case .BOLIVIAN_BOLIVIANO:
            symbol = "Bs.";
            break;
        case .BOTSWANA_PULA:
            symbol = "P";
            break;
        case .BRUNEI_DOLLAR:
            symbol = "B$";
            break;
        case .BURMESE_KYAT:
            symbol = "Ks";
            break;
        case .CAMBODIAN_RIEL:
            symbol = "៛";
            break;
        case .CANADIAN_DOLLAR:
            symbol = "C$";
            break;
        case .CAYMAN_ISLANDS_DOLLAR:
            symbol = "Cl";
            break;
        case .CHINESE_YUAN:
            symbol = "RMB";
            break;
        case .COLOMBIAN_PESO:
            symbol = "COL$";
            break;
        case .COSTA_RICAN_COL:
            symbol = "₡";
            break;
        case .CROATIAN_KUNA:
            symbol = "kn";
            break;
        case .CZECH_KORUNA:
            symbol = " Kč";
            break;
        case .DANISH_KRONE:
            symbol = "Dkr";
            break;
        case .DOMINICAN_PESO:
            symbol = "RD$";
            break;
        case .EGYPTIAN_POUND:
            symbol = "L.E.";
            break;
        case .ETHIOPIAN_BIRR:
            symbol = "Br";
            break;
        case .FIJIAN_DOLLAR:
            symbol = "FJ$";
            break;
        case .GAMBIAN_DALASI:
            symbol = "D";
            break;
        case .GIBRALTAR_POUND:
            symbol = "£";
            break;
        case .GUATEMALAN_QUETZAL:
            symbol = "Q";
            break;
        case .GUYANESE_DOLLAR:
            symbol = "G$";
            break;
        case .HAITIAN_GOURDE:
            symbol = "G";
            break;
        case .HONDURAN_LEMPIRA:
            symbol = "L";
            break;
        case .HONG_KONG_DOLLAR:
            symbol = "HK$";
            break;
        case .HUNGARIAN_FORINT:
            symbol = "Ft";
            break;
        case .INDONESAIN_RUPIAH:
            symbol = "Rp";
            break;
        case .ISRAELI_NEW_SHEKEL:
            symbol = " ₪";
            break;
        case .JAMAICAN_DOLLAR:
            symbol = "J$";
            break;
        case .KAZAKHSTANI_TENGE:
            symbol = "₸";
            break;
        case .KENYAN_SHILLING:
            symbol = "Ksh";
            break;
        case .KYRGYZZTANI_SOM:
            symbol = "som";
            break;
        case .LAO_KIP:
            symbol = "₭";
            break;
        case .LEBANESE_POUND:
            symbol = "LL";
            break;
        case .LESOTHO_LOTI:
            symbol = "M";
            break;
        case .LIBERIAN_DOLLAR:
            symbol = "L$";
            break;
        case .MACANESE_PATACA:
            symbol = "MOP$";
            break;
        case .MACEDONIAN_DENAR:
            symbol = "DEN";
            break;
        case .MALAWIAN_KWACHA:
            symbol = "MK";
            break;
        case .MALAYSIAN_RINGGIT:
            symbol = "RM";
            break;
        case .MALDIVIAN_RUFIYAA:
            symbol = "Rf.";
            break;
        case .MAURITIAN_RUPEE:
            symbol = "₨";
            break;
        case .MEXICAN_PESO:
            symbol = "Mex$";
            break;
        case .MOLDOVAN_LEU:
            symbol = "MDL";
            break;
        case .MONGOLIAN_T:
            symbol = "₮";
            break;
        case .MOROCCAN_DIRHAM:
            symbol = "MAD";
            break;
        case .NAMIBIAN_DOLLAR:
            symbol = "N$";
            break;
        case .NEPALESE_RUPEE:
            symbol = "रू";
            break;
        case .NEW_ZEALAND_DOLLAR:
            symbol = "NZ$";
            break;
        case .NICARAGUAN_C:
            symbol = "C$";
            break;
        case .NIGERIAN_NAIRA:
            symbol = "₦";
            break;
        case .NORWEGIAN_KRONE:
            symbol = "kr";
            break;
        case .PAKISTANI_RUPEE:
            symbol = "Rs";
            break;
        case .PAPUA_NEW_GUINEAN_KINA:
            symbol = "K";
            break;
        case .PERUVIAN_SOl:
            symbol = "S/";
            break;
        case .PHILIPPINE_PESO:
            symbol = "₱";
            break;
        case .QATARI_RIYAL:
            symbol = "QR";
            break;
        case .RUSSAIN_RUBLE:
            symbol = "₽";
            break;
        case .SAUDI_RIYAL:
            symbol = "SR";
            break;
        case .SEYCHELLOIS_RUPEE:
            symbol = "SRe";
            break;
        case .SIERRA_LEONEAN_LEONE:
            symbol = "Le";
            break;
        case .SINGAPORE_DOLLAR:
            symbol = "S$";
            break;
        case .SOMALI_SHILLING:
            symbol = "Sh.So.";
            break;
        case .SOUTH_AFRICAN_RAND:
            symbol = "R";
            break;
        case .SRILANKAN_RUPEE:
            symbol = "රු";
            break;
        case .SWAZI_LILANGENi:
            symbol = "E";
            break;
        case .SWEDISH_KRONA:
            symbol = "kr";
            break;
        case .SWISS_FRANC:
            symbol = "Fr.";
            break;
        case .TANZANIAN_SHILLING:
            symbol = "TSh";
            break;
        case .THAI_BAHT:
            symbol = "฿";
            break;
        case .TRINIDAD_AND_TOBAGO:
            symbol = "TT$";
            break;
        case .UNITED_ARAB:
            symbol = "Dhs";
            break;
        case .URUGUAYAN_PESO:
            symbol = "$U";
            break;
        case .UZBEKISTANI_SOM:
            symbol = "sum";
            break;
        case .YEMENI_RIAL:
            symbol = "YER";
            break;
        case .SALVADORAN_COLON:
            symbol = "SVC";
            break;
//        default:
//            symbol = "";
        }
        if symbol.isEmpty{
            symbol = self.getSymbolForCurrencyCode(code: currencyCode)
        }
        return symbol;
    }
    
    private static func getSymbolForCurrencyCode(code: String) -> String {
        var candidates: [String] = []
        let locales: [String] = NSLocale.availableLocaleIdentifiers
        for localeID in locales {
            guard let symbol = findMatchingSymbol(localeID: localeID, currencyCode: code) else {
                continue
            }
            if symbol.count == 1 {
                return symbol
            }
            candidates.append(symbol)
        }
        let sorted = sortAscByLength(list: candidates)
        if sorted.count < 1 {
            return ""
        }
        return sorted[0]
    }

    private static func findMatchingSymbol(localeID: String, currencyCode: String) -> String? {
        let locale = Locale(identifier: localeID as String)
        guard let code = locale.currencyCode else {
            return nil
        }
        if code != currencyCode {
            return nil
        }
        guard let symbol = locale.currencySymbol else {
            return nil
        }
        return symbol
    }

    private static func sortAscByLength(list: [String]) -> [String] {
        return list.sorted(by: { $0.count < $1.count })
    }
    
}

