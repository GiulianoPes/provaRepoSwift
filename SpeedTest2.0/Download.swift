//
//  Download.swift
//  MultipleDownload
//
//  Created by Giuliano Pes on 11/10/18.
//  Copyright © 2018 Giuliano Pes. All rights reserved.
//

import Foundation

class Download: NSObject, URLSessionDownloadDelegate{
    
    var id:Int?
    var idDownload:Int{
        get{
            return self.id!
        }
    }
    
    var session:URLSession?
    var urlSlowStart: URL?
    var urlRandomData: URL?
    
    
    var timerStopDownload:Timer?
    
    var downloadTask: URLSessionDownloadTask?
    var resumeData: Data? //potrebbero servirmi per il download
    
    var slowStart:Data?//download slowStart
    var randomData:Data?//donwload randomData
    
    //variabili temporali
    var startTime:Date?
    var stopTime:Date?
    var timeInterval:TimeInterval?
    
    var error:Error?
    var errorFound:Error{
        get{
            return self.error!
        }
    }
    
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
    var bytesReceived:Double?
    
    var test:Test?
    
    //0 ,slowStart ,randomData ,1
    private var state:String? = "0"
    public var actualState:String{
        get{return self.state!}
        set(newState){
            //print("Download: \(newState)")
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
                self.test!.downloadFinishedTest()
                return
            default:
                print("oops")
                return
            }
        }
    }
    
    init(id: Int, test:Test){
        self.id = id
        self.test = test
        let prefix:URL = self.test!.url!
        self.urlSlowStart = URL(string: "\(prefix)slowStart\(id)/slow\(id)")!
        self.urlRandomData = URL(string: "\(prefix)randomData\(id)/random\(id)")
        self.timeInterval = TimeInterval()
    }
    
    func start(secOfSlowStart: Int){
        
        self.actualState = "0"
        self.actualSecOfSlowStart = secOfSlowStart
        self.goSlowStart()
    }
    
    func goSlowStart(){
        let conf = URLSessionConfiguration.default
        conf.timeoutIntervalForRequest = TimeInterval(self.secOfSlowStart!)
        conf.timeoutIntervalForResource = TimeInterval(self.secOfSlowStart!)
        
        self.session = URLSession(configuration: conf, delegate: self , delegateQueue: OperationQueue.main)
        self.downloadTask = self.session!.downloadTask(with: self.urlSlowStart!)
        self.downloadTask!.resume()
        
        self.startTime = Date.init()
        self.actualState = "slowStart"
    }
    
    func goRandomData(){
        let conf = URLSessionConfiguration.default
        conf.timeoutIntervalForRequest = 10
        conf.timeoutIntervalForResource = 10
        
        self.session = URLSession(configuration: conf, delegate: self , delegateQueue: OperationQueue.main)
        self.downloadTask = self.session!.downloadTask(with: self.urlRandomData!)
        self.downloadTask!.resume()
        
        
        
        self.startTime = Date.init()
        self.actualState = "randomData"
    }
    
    //end of task
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL){
        
        self.stopTime = Date.init()
        self.timeInterval = DateInterval.init(start: self.startTime!, end: self.stopTime!).duration
        
        switch self.actualState {
        case "slowStart"://significa che lo slowStart è stato completato
            self.goRandomData()
            return
        case "randomData"://significa che i randomData sono stati inviati
            self.speed = (Double(downloadTask.countOfBytesReceived)*8)/Double(self.timeInterval!)/1000/1000
            print("Download, finished task: \(self.speed!) id \(self.id!)")
            self.bytesReceived = Double(downloadTask.countOfBytesReceived)
            self.actualState = "1"
            //return
            return
        default:
            print("oooops")
            return
        }
    }
    
    
    //progress
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64){
        
        self.progress = Double(downloadTask.countOfBytesReceived) / Double(downloadTask.countOfBytesExpectedToReceive)
        self.test!.updateDownloadProgress(download: self)
    }
    
    //gestisce la stop del download dopo 10 secondi
    //Aggiornamento temporale della mainProgressBar e della mainProgressLabel
    func timerForStopDownload(){
        self.timerStopDownload = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.stopDownload), userInfo: nil, repeats: false)
    }
    
    @objc func stopDownload(){
        self.downloadTask!.cancel(byProducingResumeData: { (data) in
            self.resumeData = data
            
            self.stopTime = Date.init()
            self.timeInterval = DateInterval.init(start: self.startTime!, end: self.stopTime!).duration
            
            switch self.actualState {
            case "slowStart"://significa che lo slowStart è stato completato
                self.goRandomData()
                return
            case "randomData"://significa che i randomData sono stati inviati
               
                self.speed = ((Double(data!.count))*8)/Double(self.timeInterval!)/1000/1000
                print("Download, finished task: \(self.speed!) id \(self.id!)")
                self.bytesReceived = Double(data!.count)
                self.actualState = "1"
                //return
                return
            default:
                print("oooops")
                return
            }
            
        })
    }
}
