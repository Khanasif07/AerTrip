//
//  CurrencyModel.swift
//  AERTRIP
//
//  Created by Admin on 25/08/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

struct CurrencyModel {
    
    static let INDIAN_RUPEE = "INR";
    static let USD_DOLLAR = "USD";
    static let JAPANESE_YEN = "JYP";
    static let ALBANIAN_LEK = "ALL";
    static let ALGERIAN_DINAR  = "DZD";
    static let EURO  = "EUR";
    static let BRITISH_POUNT  = "GBP";
    static let ARGENTINE_PESO  = "ARS";
    static let ARMENIAN_DRAM  = "AMD";
    static let ARUBAN_FLORIN  = "AWG";
    static let AUSTRALIAN_DOLLAR  = "AUD";
    static let BAHAMIAN_DOLLAR  = "BSD";
    static let BANGLADESHI_TAKA  = "BDT";
    static let BARBADIAN_DOLLAR  = "BBD";
    static let BELIZE_DOLLAR  = "BZD";
    static let BERMUDIAN_DOLLAR  = "BMD";
    static let BOLIVIAN_BOLIVIANO  = "BOB";
    static let BOTSWANA_PULA  = "BWP";
    static let BRUNEI_DOLLAR  = "BND";
    static let BURMESE_KYAT  = "MMK";
    static let CAMBODIAN_RIEL = "KHR";
    static let CANADIAN_DOLLAR  = "CAD";
    static let CAYMAN_ISLANDS_DOLLAR  = "KYD";
    static let CHINESE_YUAN  = "CNY";
    static let COLOMBIAN_PESO  = "COP";
    static let COSTA_RICAN_COL  = "CRC";
    static let CROATIAN_KUNA  = "HRK";
    static let CZECH_KORUNA  = "CZK";
    static let DANISH_KRONE  = "DKK";
    static let DOMINICAN_PESO  = "DOP";
    static let EGYPTIAN_POUND  = "EGP";
    static let ETHIOPIAN_BIRR  = "ETB";
    static let FIJIAN_DOLLAR  = "FJD";
    static let GAMBIAN_DALASI  = "GMD";
    static let GIBRALTAR_POUND  = "GIP";
    static let GUATEMALAN_QUETZAL  = "GTQ";
    static let GUYANESE_DOLLAR  = "GYD";
    static let HAITIAN_GOURDE  = "HTG";
    static let HONDURAN_LEMPIRA  = "HNL";
    static let HONG_KONG_DOLLAR  = "HKD";
    static let HUNGARIAN_FORINT  = "HUF";
    static let INDONESAIN_RUPIAH  = "IDR";
    static let ISRAELI_NEW_SHEKEL  = "ILS";
    static let JAMAICAN_DOLLAR  = "JMD";
    static let KAZAKHSTANI_TENGE  = "KZT";
    static let KENYAN_SHILLING  = "KES";
    static let KYRGYZZTANI_SOM  = "KGS";
    static let LAO_KIP  = "LAK";
    static let LEBANESE_POUND  = "LBP";
    static let LESOTHO_LOTI  = "LSL";
    static let LIBERIAN_DOLLAR  = "LRD";
    static let MACANESE_PATACA  = "MOP";
    static let MACEDONIAN_DENAR  = "MKD";
    static let MALAWIAN_KWACHA  = "MWK";
    static let MALAYSIAN_RINGGIT  = "MYR";
    static let MALDIVIAN_RUFIYAA  = "MVR";
    static let MAURITIAN_RUPEE  = "MUR";
    static let MEXICAN_PESO  = "MXN";
    static let MOLDOVAN_LEU  = "MDL";
    static let MONGOLIAN_T  = "MNT";
    static let MOROCCAN_DIRHAM  = "MAD";
    static let NAMIBIAN_DOLLAR  = "NAD";
    static let NEPALESE_RUPEE  = "NPR";
    static let NEW_ZEALAND_DOLLAR  = "NZD";
    static let NICARAGUAN_C  = "NIO";
    static let NIGERIAN_NAIRA  = "NGN";
    static let NORWEGIAN_KRONE  = "NOK";
    static let PAKISTANI_RUPEE  = "PKR";
    static let PAPUA_NEW_GUINEAN_KINA  = "PGK";
    static let PERUVIAN_SOl  = "PEN";
    static let PHILIPPINE_PESO  = "PHP";
    static let QATARI_RIYAL  = "QAR";
    static let RUSSAIN_RUBLE  = "RUB";
    static let SAUDI_RIYAL  = "SAR";
    static let SEYCHELLOIS_RUPEE  = "SCR";
    static let SIERRA_LEONEAN_LEONE  = "SLL";
    static let SINGAPORE_DOLLAR  = "SGD";
    static let SOMALI_SHILLING  = "SOS";
    static let SOUTH_AFRICAN_RAND  = "ZAR";
    static let SRILANKAN_RUPEE  = "LKR";
    static let SWAZI_LILANGENi  = "SZL";
    static let SWEDISH_KRONA  = "SEK";
    static let SWISS_FRANC  = "CHF";
    static let TANZANIAN_SHILLING  = "TZS";
    static let THAI_BAHT  = "THB";
    static let TRINIDAD_AND_TOBAGO  = "TTD";
    static let UNITED_ARAB  = "AED";
    static let URUGUAYAN_PESO  = "UYU";
    static let UZBEKISTANI_SOM  = "UZS";
    static let YEMENI_RIAL  = "YER";
    static let SALVADORAN_COLON  = "SVC";

    
    
    /*
    var icon: String
    var group:String
    var display_format:String
    var textSuffix:Bool
    var name:String
    var cancellation_rate:String
    var rate:String
    var text:String
    var code:String
 */
 var currencyId : String = ""
 var currencySymbol : String = ""
 var currencyName : String = ""
 var currencyCode : String = ""
 var currencyIcon : String = ""
    
    //    init() {
    //        let json = JSON()
    //        self.init(json: json)
    //    }
    /*
    init(json:JSON, code: String) {
        self.icon = json["icon"].stringValue.removeNull
        self.group = json["group"].stringValue.removeNull
        self.display_format = json["display_format"].stringValue.removeNull
        self.textSuffix = json["textSuffix"].boolValue
        self.name = json["name"].stringValue.removeNull
        self.cancellation_rate = json["cancellation_rate"].stringValue.removeNull
        self.rate = json["rate"].stringValue.removeNull
        self.text = json["text"].stringValue.removeNull
        self.code = code
    }
    */
    init(json: JSON) {
        currencyId = json[APIKeys.id.rawValue].stringValue
        currencyCode = json[APIKeys.currency_code.rawValue].stringValue
        currencyName = json[APIKeys.name.rawValue].stringValue
        var symbol = self.getCurrencySymbolStatic(currencyCode: currencyCode)
        if symbol.isEmpty {
            symbol = self.getSymbolForCurrencyCode(code: json[APIKeys.currency_code.rawValue].stringValue)
        }
        self.currencySymbol = symbol
        currencyIcon = json[APIKeys.currency_icon.rawValue].stringValue
    }
    
    static func retunCurrencyModelArray(json: [JSON]) -> [CurrencyModel] {
        var array = [CurrencyModel]()
        /*
        let keys = json.dictionaryValue.keys
        for key in keys {
            array.append(CurrencyModel(json: json[key], code: key))
        }
 */
        for obj in json {
        array.append(CurrencyModel(json: obj))
        }
        return array
    }
    
    /*
     "icon" : "icon icon_currency-usd",
     "group" : "Secondary",
     "display_format" : "million",
     "textSuffix" : false,
     "cancellation_rate" : "0.02035531",
     "name" : "Brunei Dollar",
     "rate" : "0.02031286",
     "text" : "B"
     */
    func getSymbolForCurrencyCode(code: String) -> String {
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

    func findMatchingSymbol(localeID: String, currencyCode: String) -> String? {
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

    func sortAscByLength(list: [String]) -> [String] {
        return list.sorted(by: { $0.count < $1.count })
    }
    func  getCurrencySymbolStatic(currencyCode: String) -> String{
        var symbol = "";
        switch (currencyCode) {
        case CurrencyModel.INDIAN_RUPEE:
            symbol = "₹";
            break;
        case CurrencyModel.USD_DOLLAR:
            symbol = "$";
            break;
        case CurrencyModel.JAPANESE_YEN:
            symbol = "¥";
            break;
        case CurrencyModel.ALBANIAN_LEK:
            symbol = "L";
            break;
        case CurrencyModel.ALGERIAN_DINAR:
            symbol = "DA";
            break;
        case CurrencyModel.EURO:
            symbol = "€";
            break;
        case CurrencyModel.BRITISH_POUNT:
            symbol = "£";
            break;
        case CurrencyModel.ARGENTINE_PESO:
            symbol = "$a";
            break;
        case CurrencyModel.ARMENIAN_DRAM:
            symbol = "֏";
            break;
        case CurrencyModel.ARUBAN_FLORIN:
            symbol = "Afl.";
            break;
        case CurrencyModel.AUSTRALIAN_DOLLAR:
            symbol = "A$";
            break;
        case CurrencyModel.BAHAMIAN_DOLLAR:
            symbol = "B$";
            break;
        case CurrencyModel.BANGLADESHI_TAKA:
            symbol = "৳";
            break;
        case CurrencyModel.BARBADIAN_DOLLAR:
            symbol = "Bds$";
            break;
        case CurrencyModel.BELIZE_DOLLAR:
            symbol = "BZ$";
            break;
        case CurrencyModel.BERMUDIAN_DOLLAR:
            symbol = "BD$";
            break;
        case CurrencyModel.BOLIVIAN_BOLIVIANO:
            symbol = "Bs.";
            break;
        case CurrencyModel.BOTSWANA_PULA:
            symbol = "P";
            break;
        case CurrencyModel.BRUNEI_DOLLAR:
            symbol = "B$";
            break;
        case CurrencyModel.BURMESE_KYAT:
            symbol = "Ks";
            break;
        case CurrencyModel.CAMBODIAN_RIEL:
            symbol = "៛";
            break;
        case CurrencyModel.CANADIAN_DOLLAR:
            symbol = "C$";
            break;
        case CurrencyModel.CAYMAN_ISLANDS_DOLLAR:
            symbol = "Cl";
            break;
        case CurrencyModel.CHINESE_YUAN:
            symbol = "RMB";
            break;
        case CurrencyModel.COLOMBIAN_PESO:
            symbol = "COL$";
            break;
        case CurrencyModel.COSTA_RICAN_COL:
            symbol = "₡";
            break;
        case CurrencyModel.CROATIAN_KUNA:
            symbol = "kn";
            break;
        case CurrencyModel.CZECH_KORUNA:
            symbol = " Kč";
            break;
        case CurrencyModel.DANISH_KRONE:
            symbol = "Dkr";
            break;
        case CurrencyModel.DOMINICAN_PESO:
            symbol = "RD$";
            break;
        case CurrencyModel.EGYPTIAN_POUND:
            symbol = "L.E.";
            break;
        case CurrencyModel.ETHIOPIAN_BIRR:
            symbol = "Br";
            break;
        case CurrencyModel.FIJIAN_DOLLAR:
            symbol = "FJ$";
            break;
        case CurrencyModel.GAMBIAN_DALASI:
            symbol = "D";
            break;
        case CurrencyModel.GIBRALTAR_POUND:
            symbol = "£";
            break;
        case CurrencyModel.GUATEMALAN_QUETZAL:
            symbol = "Q";
            break;
        case CurrencyModel.GUYANESE_DOLLAR:
            symbol = "G$";
            break;
        case CurrencyModel.HAITIAN_GOURDE:
            symbol = "G";
            break;
        case CurrencyModel.HONDURAN_LEMPIRA:
            symbol = "L";
            break;
        case CurrencyModel.HONG_KONG_DOLLAR:
            symbol = "HK$";
            break;
        case CurrencyModel.HUNGARIAN_FORINT:
            symbol = "Ft";
            break;
        case CurrencyModel.INDONESAIN_RUPIAH:
            symbol = "Rp";
            break;
        case CurrencyModel.ISRAELI_NEW_SHEKEL:
            symbol = " ₪";
            break;
        case CurrencyModel.JAMAICAN_DOLLAR:
            symbol = "J$";
            break;
        case CurrencyModel.KAZAKHSTANI_TENGE:
            symbol = "₸";
            break;
        case CurrencyModel.KENYAN_SHILLING:
            symbol = "Ksh";
            break;
        case CurrencyModel.KYRGYZZTANI_SOM:
            symbol = "som";
            break;
        case CurrencyModel.LAO_KIP:
            symbol = "₭";
            break;
        case CurrencyModel.LEBANESE_POUND:
            symbol = "LL";
            break;
        case CurrencyModel.LESOTHO_LOTI:
            symbol = "M";
            break;
        case CurrencyModel.LIBERIAN_DOLLAR:
            symbol = "L$";
            break;
        case CurrencyModel.MACANESE_PATACA:
            symbol = "MOP$";
            break;
        case CurrencyModel.MACEDONIAN_DENAR:
            symbol = "DEN";
            break;
        case CurrencyModel.MALAWIAN_KWACHA:
            symbol = "MK";
            break;
        case CurrencyModel.MALAYSIAN_RINGGIT:
            symbol = "RM";
            break;
        case CurrencyModel.MALDIVIAN_RUFIYAA:
            symbol = "Rf.";
            break;
        case CurrencyModel.MAURITIAN_RUPEE:
            symbol = "₨";
            break;
        case CurrencyModel.MEXICAN_PESO:
            symbol = "Mex$";
            break;
        case CurrencyModel.MOLDOVAN_LEU:
            symbol = "MDL";
            break;
        case CurrencyModel.MONGOLIAN_T:
            symbol = "₮";
            break;
        case CurrencyModel.MOROCCAN_DIRHAM:
            symbol = "MAD";
            break;
        case CurrencyModel.NAMIBIAN_DOLLAR:
            symbol = "N$";
            break;
        case CurrencyModel.NEPALESE_RUPEE:
            symbol = "रू";
            break;
        case CurrencyModel.NEW_ZEALAND_DOLLAR:
            symbol = "NZ$";
            break;
        case CurrencyModel.NICARAGUAN_C:
            symbol = "C$";
            break;
        case CurrencyModel.NIGERIAN_NAIRA:
            symbol = "₦";
            break;
        case CurrencyModel.NORWEGIAN_KRONE:
            symbol = "kr";
            break;
        case CurrencyModel.PAKISTANI_RUPEE:
            symbol = "Rs";
            break;
        case CurrencyModel.PAPUA_NEW_GUINEAN_KINA:
            symbol = "K";
            break;
        case CurrencyModel.PERUVIAN_SOl:
            symbol = "S/";
            break;
        case CurrencyModel.PHILIPPINE_PESO:
            symbol = "₱";
            break;
        case CurrencyModel.QATARI_RIYAL:
            symbol = "QR";
            break;
        case CurrencyModel.RUSSAIN_RUBLE:
            symbol = "₽";
            break;
        case CurrencyModel.SAUDI_RIYAL:
            symbol = "SR";
            break;
        case CurrencyModel.SEYCHELLOIS_RUPEE:
            symbol = "SRe";
            break;
        case CurrencyModel.SIERRA_LEONEAN_LEONE:
            symbol = "Le";
            break;
        case CurrencyModel.SINGAPORE_DOLLAR:
            symbol = "S$";
            break;
        case CurrencyModel.SOMALI_SHILLING:
            symbol = "Sh.So.";
            break;
        case CurrencyModel.SOUTH_AFRICAN_RAND:
            symbol = "R";
            break;
        case CurrencyModel.SRILANKAN_RUPEE:
            symbol = "රු";
            break;
        case CurrencyModel.SWAZI_LILANGENi:
            symbol = "E";
            break;
        case CurrencyModel.SWEDISH_KRONA:
            symbol = "kr";
            break;
        case CurrencyModel.SWISS_FRANC:
            symbol = "Fr.";
            break;
        case CurrencyModel.TANZANIAN_SHILLING:
            symbol = "TSh";
            break;
        case CurrencyModel.THAI_BAHT:
            symbol = "฿";
            break;
        case CurrencyModel.TRINIDAD_AND_TOBAGO:
            symbol = "TT$";
            break;
        case CurrencyModel.UNITED_ARAB:
            symbol = "Dhs";
            break;
        case CurrencyModel.URUGUAYAN_PESO:
            symbol = "$U";
            break;
        case CurrencyModel.UZBEKISTANI_SOM:
            symbol = "sum";
            break;
        case CurrencyModel.YEMENI_RIAL:
            symbol = "YER";
            break;
        case CurrencyModel.SALVADORAN_COLON:
            symbol = "SVC";
            break;
        default:
            symbol = "";
        }
        return symbol;
    }
}

