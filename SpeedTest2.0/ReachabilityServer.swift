//
//  ReachabilityServer.swift
//  SpeedTest2.0
//
//  Created by Giuliano Pes on 28/10/2018.
//  Copyright © 2018 Giuliano Pes. All rights reserved.
//

import Foundation

class ReachabilityServer:NSObject, URLSessionDataDelegate{
    
    var session: URLSession?
    var task:URLSessionDataTask?
    var data:Data?
    
   
    func checkConnectionToAddress(address : String){
        let conf = URLSessionConfiguration.default
        self.session = URLSession.init(configuration: conf, delegate: self as URLSessionDataDelegate?, delegateQueue: OperationQueue.main)
        
        let url:URL = URL(string: "http://192.168.1.8")!
        var request = URLRequest.init(url: url)
        
        request.httpMethod = "GET"
        
        self.task = session!.dataTask(with: request){ (data, response, error) in
            guard let _ = data else{
                print("nessun dato ricevuto")
                return
            }
            print(data!)
            guard let _ =  response else{
                print("nessun response")
                return
            }
            print(response! )
            
            guard let _ = error else{
                print("nessun errore")
                return
            }
            print(error!)
            
            /*
            guard error == nil else {
                print(error!)
                return
            }
            */
        }
        
        self.task!.resume()
    }
}
