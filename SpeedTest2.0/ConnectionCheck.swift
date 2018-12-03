//
//  Upload.swift
//  SpeedTest
//
//  Created by Giuliano Pes on 18/10/18.
//  Copyright © 2018 Giuliano Pes. All rights reserved.
//

import Foundation

class ConnectionCheck: NSObject, URLSessionDataDelegate{
    
    func internetIsAvailable(url: URL) -> Bool{
        
        let request:URLRequest? = URLRequest.init(url: url)
        let conf = URLSessionConfiguration.default
        conf.timeoutIntervalForResource = 1
        let session = URLSession.init(configuration: conf)
        var bool:Bool = false
        
        guard let _ = request else{
            print("nessuna request trovata!")
            return bool
        }
        
        session.dataTask(with: request!, completionHandler: {(data,response,error) in
            if error != nil {
                if let e = error as? URLError{
                    switch e.code{
                    case .notConnectedToInternet:
                        print("Connettiti al wifi/3g")
                        return
                    case .timedOut:
                        print("Connessione riuscita ed interrotta")
                        bool = true
                        return
                    default:
                        print(e.localizedDescription)
                    }
                }
            }else{
                if let httpResponse = response as? HTTPURLResponse {
                    print(httpResponse.statusCode)
                }
                //The request was successful
                print("Connesso a Internet")
                bool = true
            }
        }).resume()
        
        sleep(2)
        return bool
    }
}

/*
 public static var unknown: URLError.Code { get }
 
 public static var cancelled: URLError.Code { get }
 
 public static var badURL: URLError.Code { get }
 
 public static var timedOut: URLError.Code { get }
 
 public static var unsupportedURL: URLError.Code { get }
 
 public static var cannotFindHost: URLError.Code { get }
 
 public static var cannotConnectToHost: URLError.Code { get }
 
 public static var networkConnectionLost: URLError.Code { get }
 
 public static var dnsLookupFailed: URLError.Code { get }
 
 public static var httpTooManyRedirects: URLError.Code { get }
 
 public static var resourceUnavailable: URLError.Code { get }
 
 public static var notConnectedToInternet: URLError.Code { get }
 
 public static var redirectToNonExistentLocation: URLError.Code { get }
 
 public static var badServerResponse: URLError.Code { get }
 
 public static var userCancelledAuthentication: URLError.Code { get }
 
 public static var userAuthenticationRequired: URLError.Code { get }
 
 public static var zeroByteResource: URLError.Code { get }
 
 public static var cannotDecodeRawData: URLError.Code { get }
 
 public static var cannotDecodeContentData: URLError.Code { get }
 
 public static var cannotParseResponse: URLError.Code { get }
 */


/*
 if let e = error as? URLError, e.code == .notConnectedToInternet {
 //wifi attivo
 print("Not connected to wifi")
 self.isConnectedToInternet = false
 }else{
 //Some other error
 //print(error!)
 print("Not connected to internet")
 self.isConnectedToInternet = false
 }
 
 }else{
 //The request was successful
 //nessun errore
 print("Internet connection is available for \(url)")
 if let httpResponse = response as? HTTPURLResponse {
 print(httpResponse.statusCode)
 }
 self.isConnectedToInternet = true
 }
 */
