//
//  Upload.swift
//  SpeedTest
//
//  Created by Giuliano Pes on 18/10/18.
//  Copyright © 2018 Giuliano Pes. All rights reserved.
//

import Foundation

class Upload: NSObject, URLSessionDataDelegate{
    
    var id:Int?
    var idUpload:Int{
        get{
            return self.id!
        }
    }
    
    var session: URLSession?
    var url:URL?
    var request:URLRequest?
    
    var uploadTask:URLSessionUploadTask?
    var slowStart:Data?
    var randomData:Data?
    
    //variabili temporali
    var startTime:Date?
    var stopTime:Date?
    var timeInterval:TimeInterval?
    
    /*
    var error:Error?
    var errorFound:Error{
        get{
            return self.error!
        }
    }
    */
    
    var secOfSlowStart:Int?
    var actualSecOfSlowStart:Int{
        get{
            return secOfSlowStart!
        }
        set(value){
            self.secOfSlowStart = value
        }
    }
    
    var secOfRandomData:Int? = 10
    
    //completamento
    var progress:Double?
    var speed:Double?
    var bytesSent:Double?
    
    var test:Test?
    
    //0 ,slowStart ,randomData ,1
    private var state:String? = "0"
    public var actualState:String{
        get{return self.state!}
        set(newState){
            //print("Upload: \(newState)")
            self.state! = newState
            
            //switch
            switch newState {
            case "0":
                self.progress = 0.0
                return
            case "slowStart":
                self.test!.startSendingSlowStart()
                return
            case "randomData":
                self.test!.startSendingRandomData()
                return
            case "1":
                self.test!.uploadFinishedTest()
                return
            default:
                print("oops")
                return
            }
        }
    }
    
    init(id: Int,slowStart :Data,randomData:Data, test:Test){
        self.id = id
        self.slowStart = slowStart
        self.randomData = randomData
        self.test = test
        self.url = self.test!.url
        //self.url = URL(string: "http://192.168.1.7/exampleServer/")!
        self.request = URLRequest.init(url: self.url!)
        self.request!.httpMethod = "POST"
        self.request!.setValue("Keep-Alive", forHTTPHeaderField: "Connection")
        
        self.request!.setValue("chunked", forHTTPHeaderField: "TE")
        self.request!.setValue("1000", forHTTPHeaderField: "Content-Length")
        self.request!.setValue("HTTPS/1.3", forHTTPHeaderField: "Upgrade")
        
        
        //
        /*
        if self.id == 1{
            for field in self.request!.allHTTPHeaderFields!{
                print(field)
            }
        }
        */
        
    }
    
    func start(secOfSlowStart:Int){
        self.actualState = "0"
        self.actualSecOfSlowStart = secOfSlowStart
        //print("Upload \(secOfSlowStart) \(secOfRandomData!)")
        self.goSlowStart()
    }
    
    func goSlowStart(){
        let conf = URLSessionConfiguration.default
        conf.timeoutIntervalForRequest = TimeInterval(self.secOfSlowStart!)
        conf.timeoutIntervalForResource = TimeInterval(self.secOfSlowStart!)
        self.session = URLSession.init(configuration: conf, delegate: self as URLSessionDataDelegate?, delegateQueue: OperationQueue.main)
        self.uploadTask = self.session!.uploadTask(with: self.request!, from: self.slowStart!)
        self.uploadTask!.resume()
        self.startTime = Date.init()
        self.actualState = "slowStart"
    }
    
    func goRandomData(){
        let conf = URLSessionConfiguration.default
        conf.timeoutIntervalForRequest = 10
        conf.timeoutIntervalForResource = 10
        //self.session!.configuration.timeoutIntervalForRequest = 10
        //self.session!.configuration.timeoutIntervalForResource = 10
        //self.session!.configuration.allowsCellularAccess = true
        self.session = URLSession.init(configuration: conf, delegate: self as URLSessionDataDelegate?, delegateQueue: OperationQueue.main)
        self.uploadTask = self.session!.uploadTask(with: self.request!, from: self.randomData!)
        self.uploadTask!.resume()
        self.startTime = Date.init()
        self.actualState = "randomData"
    }
    
    //aggiornamento condizione upload
    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64){
        
        self.progress = Double(task.countOfBytesSent) / Double(totalBytesExpectedToSend)
        self.test!.updateUploadProgress(upload: self)
        
        //
        //print(task.earliestBeginDate!.description)
    }
    
    //resoconto fine upload
    public func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics){
        
        self.stopTime = Date.init()
        self.timeInterval = DateInterval.init(start: self.startTime!, end: self.stopTime!).duration
        
        switch self.actualState {
        case "slowStart"://significa che lo slowStart è stato completato
            self.goRandomData()
            return
        case "randomData"://significa che i randomData sono stati inviati
            self.speed = (Double(task.countOfBytesSent)*8)/Double(self.timeInterval!)/1000/1000
            //print(self.speed!)
            self.bytesSent = Double(task.countOfBytesSent)
            self.actualState = "1"
            //return
            return
        default:
            print("oooops")
            return
        }
    }
    
    //eventuali errori in upload
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?){
        //guard let _ = error else{print("nessun errore") ;return}
        //self.error = error
    }
}
