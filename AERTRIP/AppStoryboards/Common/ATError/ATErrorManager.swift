//
//  ATError.swift
//  AERTRIP
//
//  Created by Admin on 28/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class ATErrorManager {
    
    //MARK:- Enums
    //MARK:-
    enum Module: String {
        case profile
        case login
        case hotelsSearch
    }
    
    enum LocalError: Int {
        case `default` = -4561
        case noInternet = -4562
        case requestTimeOut = -4563
        case userNotLoggedIn = -4564 //if backend send -1 then we are converting it to -4564
        
        var message: String {
            switch self {
            case .noInternet:
                return LocalizedString.NoInternet.localized
                
            case .requestTimeOut:
                return LocalizedString.requestTimeOut.localized
                
            case .userNotLoggedIn:
                return LocalizedString.userNotLoggedIn.localized
                
            default:
                return LocalizedString.SomethingWentWrong.localized
            }
        }
    }
    
    //MARK:- Shared instance and initializer
    //MARK:-
    static let `default` = ATErrorManager()
    
    private init() {}
    
    
    //MARK:- Methods
    //MARK:- Private
    
   /*
     For parsing use
     
     allCol.count > 2 && allCol[2] == forCode
     
     change the 2 witht the index for "Error Code" column in google sheet
   */
    
    private func getErrorRow(forCode: String, module: ATErrorManager.Module) -> String {
        
        let res = self.readDataFromCSV(fileName: module.rawValue, fileType: "csv")
        
        guard !res.isEmpty else {
            return ""
        }
        
        let lines = res.components(separatedBy: "\n")
        return lines.first(where: { (str) -> Bool in
            let allCol = str.components(separatedBy: ",")
            return allCol.count > 2 && allCol[2] == forCode
        }) ?? ""
    }
    
    private func readDataFromCSV(fileName:String, fileType: String)-> String {
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
            else {
                return ""
        }
        do {
            var contents = try String(contentsOfFile: filepath, encoding: .utf8)
            contents = cleanRows(file: contents)
            return contents
        } catch {
            printDebug("File Read Error for file \(filepath)")
            return ""
        }
    }
    
    private func cleanRows(file:String)->String{
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        return cleanFile
    }
    
    //MARK:- Public
    func error(forCode: Int, module: ATErrorManager.Module) -> ATError {
        var error = ATError()
        
        let forCode = (forCode == -1) ? LocalError.userNotLoggedIn.rawValue : forCode
        error.code = "\(forCode)"
        error.module = module.rawValue
        
        if (-4564)...(-4561) ~= forCode {
            let err = LocalError(rawValue: forCode) ?? .default
            
            error.message = err.message
            error.hint = ""
        }
        else {
            
            let row = self.getErrorRow(forCode: "\(forCode)", module: module)
            
            let allCol = row.components(separatedBy: ",")
            if allCol.count > 4, !allCol[4].isEmpty {
                error.message = allCol[4].isEmpty ? LocalError.default.message : "\(allCol[4])"
            }
            
            if allCol.count > 3, !allCol[3].isEmpty {
                error.hint = allCol[3].isEmpty ? LocalError.default.message : "\(allCol[3])"
            }
        }
        
        return error
    }
    
    func logError(forCodes errors: ErrorCodes, fromModule module: ATErrorManager.Module) {
        
        let (_, message, hint) = ATErrorManager.default.error(forCodes: errors, module: module)
        let finalError = "******************************************************************\n" +
            "                              ATError                             \n" +
            "                              =======                             \n" +
            "                          Message to show:                        \n" +
            "\(message)\n" +
            "------------------------------------------------------------------\n" +
            "                           Developer hint:                        \n" +
            "\(hint)\n" +
        "******************************************************************\n"
        
        printDebug(finalError)
    }
    
    func error(forCodes: [Int], module: ATErrorManager.Module) -> ([ATError], String, String) {
        var temp = [ATError]()
        var message = ""
        var hint = ""
        
        for code in forCodes {
            let err = self.error(forCode: code, module: module)
            if !message.isEmpty {
                message += "\n"
            }

            hint += err.hint
            message += err.message
            temp.append(err)
        }
        
        return (temp, message, hint)
    }
}

struct ATError {
    
    var code: String = ""
    var module: String = ""
    var hint: String = ""
    var message: String = ""
}
