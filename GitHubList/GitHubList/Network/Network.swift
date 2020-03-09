//
//  Network.swift
//  Xing
//
//  Created by Sergi Rojas on 03/03/2020.
//  Copyright © 2020 Sergi Rojas. All rights reserved.
//

import Foundation
import Alamofire

class Network {
    
    static func getRequest(url: String, requestID: Int, onCompletion: @escaping(([GitProject]) -> ())) {
        
        AF.request(url, method: .get, parameters: nil)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    
                    switch requestID {
                    case Constants.APIRequestMain:
                        var gits: [GitProject] = []
                        do {
                            if let data = response.data {
                                gits = try JSONDecoder().decode([GitProject].self, from: data)
                            } else {
                                print("some error on response data")
                            }
                        } catch let error {
                            print(response.data?.debugDescription)
                            print("some error parsing data")
                        }
                        
                        for git in gits {
                            DBHelper.shared.insertOrUpdate(git: git)
                        }
                        onCompletion(gits)
                        
                    default:
                        print("some error on request ID")
                        break
                    }
                case .failure(let error):
                    // error handling
                    switch requestID {
                    case Constants.APIRequestMain:
                        onCompletion([])
                    default:
                        print(error.errorDescription ?? "error on request")
                        break
                    }
                    
                    break
                }
        }
    }
    
}
