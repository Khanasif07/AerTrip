//
//  JSONParser.swift
//  Aertrip
//
//  Created by Hrishikesh Devhare on 25/03/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import Foundation

func parse <T: Decodable >(data: Data ,into type: T.Type , with decoder : JSONDecoder) -> T?
{    
    do {
        
        let parsedData = try decoder.decode(type , from: data)
        return parsedData
        
    } catch let DecodingError.dataCorrupted(context) {
        
        for element in context.codingPath {
//            print(element.stringValue)
        }
        
        if let JSONString = data.prettyPrintedJSONString {
            saveToFile(JSONString as String)
        }else {
            if let stringReponse = String(bytes: data, encoding: .utf8) {
                    saveToFile(stringReponse)
            }
        }
        

    } catch let DecodingError.keyNotFound(key, context) {
        
        printDebug("~~~~~~~~~~JSON PARSING ERROR~~~~~~~~~~~")
        printDebug(context)
        printDebug("~~~~~~~~~~JSON PARSING ERROR~~~~~~~~~~~")

        for element in context.codingPath {

        }
        saveToFile(data.prettyPrintedJSONString as? String ?? "")

    } catch let DecodingError.valueNotFound(value, context) {
        
        printDebug("~~~~~~~~~~JSON PARSING ERROR~~~~~~~~~~~")
        printDebug(context)
        printDebug("~~~~~~~~~~JSON PARSING ERROR~~~~~~~~~~~")
        
        for element in context.codingPath {
        }
        
        saveToFile(data.prettyPrintedJSONString as? String ?? "")

    } catch let DecodingError.typeMismatch(type, context)  {
        
        printDebug("~~~~~~~~~~JSON PARSING ERROR~~~~~~~~~~~")
        printDebug(context)
        printDebug("~~~~~~~~~~JSON PARSING ERROR~~~~~~~~~~~")
        
        for element in context.codingPath {
        }

        saveToFile(data.prettyPrintedJSONString as? String ?? "")

    } catch {
        
        saveToFile(data.prettyPrintedJSONString as? String ?? "")

        print("error: ", error)
    }
    
    return nil
}


func saveToFile(_ string : String) {
    
    let filename = getDocumentsDirectory().appendingPathComponent("output.txt")
//    print(filename.absoluteString)
    
    do {
        try string.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
    } catch {
        
        print()
    }
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}
