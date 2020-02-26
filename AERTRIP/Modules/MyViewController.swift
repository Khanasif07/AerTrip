//
//  MyViewController.swift
//  AERTRIP
//
//  Created by Admin on 07/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import Alamofire

class MyViewController: UIViewController {
    
    var authors = [String]()
    let url = "https://learnappmaking.com/ex/books.json"
    
    
    func getAuthorsCount() {
        print("the number of authors : \(authors.count)")
        
        // this for loop doesn't get excuted
        for author in authors {
            print(author)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        AF.request(url).responseJSON { response in
            if let data = response.data {
                if let json = try? JSON(data: data) {
                    for item in json["books"].arrayValue {
                        var outputString: String
                        //print(item["author"])
                        outputString = item["author"].stringValue
                        //urlOfProjectAsset.append(outputString)
                        self.authors.append(outputString)
                        //print("authors.count: \(self.authors.count)")
                    }
                    self.getAuthorsCount() // I added this line of code.
                }
            }
        }
        getAuthorsCount()
        print("-------------")
    }
}
