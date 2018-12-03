//
//  Test.swift
//  SpeedTest
//
//  Created by Giuliano Pes on 20/10/18.
//  Copyright © 2018 Giuliano Pes. All rights reserved.
//

import Foundation

class Test{
    
    var timerProgress:Timer?
    var increasePerInterval:Float?
    var mainProgress:Float = 0
    let interval:Double = 0.02
    
    //var secOfSlowStart:Int?
    var secOfRandomData = 10
    
    var view:ViewController?
    var url:URL?
    //var urlUpload:URL?
    //var urlDownload:URL?
    
    var download1:Download?
    var download2:Download?
    var download3:Download?
    
    var upload1:Upload?
    var upload2:Upload?
    var upload3:Upload?
    
    init(view:ViewController,url:URL){
        self.view = view
        self.url = url
        
        self.download1 = Download.init(id: 1, test: self)
        self.download2 = Download.init(id: 2, test: self)
        self.download3 = Download.init(id: 3, test: self)
        
        //Per ora, l'upload è gestito con dei file random presenti sul Mac
        let data:((slowStart1: Data, randomData1: Data), (slowStart2: Data, randomData2: Data), (slowStart3: Data, randomData3: Data)) = LoadData.init().getData()
        
        self.upload1 = Upload.init(id: 1,slowStart: data.0.slowStart1, randomData: data.0.randomData1,test:self)
        self.upload2 = Upload.init(id: 2,slowStart: data.1.slowStart2, randomData: data.1.randomData2,test:self)
        self.upload3 = Upload.init(id: 3,slowStart: data.2.slowStart3, randomData: data.2.randomData3,test:self)
        
        self.timerProgress = Timer.init()
    }
    
    func start(secOfSlowStart:Int){
        
        self.increasePerInterval = Float(interval)/Float(secOfSlowStart + self.secOfRandomData)
        
        pingTest()
        downloadTest()
        uploadTest()
        
        self.mainProgress = 0.0
        self.scheduledTimerWithTimeInterval()
    }
    
    func pingTest(){}
    
    func downloadTest(){
        self.download1!.start(secOfSlowStart: 2)
        self.download2!.start(secOfSlowStart: 2)
        self.download3!.start(secOfSlowStart: 2)
    }
    
    func uploadTest(){
        self.upload1!.start(secOfSlowStart: 2)
        self.upload2!.start(secOfSlowStart: 2)
        self.upload3!.start(secOfSlowStart: 2)
    }
    
    func startSendingSlowStart(){
        //cambia lo stato del test: da '0' a 'slowStart'
        //deve quindi aggiornare l'interfaccia
        self.view!.startSendingSlowStart()
    }
    
    func startSendingRandomData(){
        //cambia lo stato del test: da 'slowStart' a 'randomData'
        //deve quindi aggiornare l'interfaccia
        self.view!.startSendingRandomData()
    }
    
    func uploadFinishedTest(){//viene chiamata tre volte
        //cambia lo stato del test: da randomData' a 1
        //deve quindi aggiornare l'interfaccia
        if uploadTestIsComplete(up1: self.upload1!, up2: self.upload2!, up3: self.upload3!) == true{
            //print(self.upload1!.errorFound.localizedDescription)
            self.timerProgress!.invalidate()
            
            //prendo la speed(velocità di ogni upload) e ne faccio la media
            //prendo la quantità di dati complessiva e la divido per 10 secondi
            let totalBytesSent = self.upload1!.bytesSent! + self.upload2!.bytesSent! + self.upload3!.bytesSent!
            
            let uploadSpeed = (totalBytesSent*8)/1000/1000/10
            //let currentUploadSpeed = (totalBytesSent*8)/1000/1000/10
            //self.view!.finishedTest(speed: currentUploadSpeed)
            self.view!.uploadTestUpdate(speed: uploadSpeed)
        }
    }
    
    func downloadFinishedTest(){
        if downloadTestIsComplete(do1: self.download1!, do2: self.download2!, do3: self.download3!){
            self.timerProgress!.invalidate()
            let totalBytesReceived = self.download1!.bytesReceived! + self.download2!.bytesReceived! + self.download3!.bytesReceived!
            
            let downloadSpeed = (totalBytesReceived*8)/1000/1000/10
            //let currentDownloadSpeed = (totalBytesReceived*8)/1000/1000/10
            //self.view!.finishedTest(speed: currentDownloadSpeed)
            
            self.view!.downloadTestUpdate(speed: downloadSpeed)
            
        }
    }
    
    //restituisce true se tutti e tre gli upload sono stati completati
    func uploadTestIsComplete(up1 : Upload, up2 : Upload, up3 : Upload)->Bool{
        if up1.actualState == "1" && up2.actualState == "1" && up3.actualState == "1"{
            return true
        }
        return false
    }
    
    func downloadTestIsComplete(do1 : Download, do2 : Download, do3 : Download)->Bool{
        if do1.actualState == "1" && do2.actualState == "1" && do3.actualState == "1"{
            return true
        }
        return false
        
    }
    
    //Aggiornamento degli upload
    func updateUploadProgress(upload:Upload){
        //deve quindi aggiornare l'interfaccia
        self.view!.updateUploadProgress(upload: upload)
    }
    
    func updateDownloadProgress(download:Download){
        self.view!.updateDownloadProgress(download: download)
    }
    
    //Aggiornamento temporale della mainProgressBar e della mainProgressLabel
    func scheduledTimerWithTimeInterval(){
        self.timerProgress = Timer.scheduledTimer(timeInterval: self.interval, target: self, selector: #selector(self.updateMainTest), userInfo: nil, repeats: true)
    }
    
    @objc func updateMainTest(){
        self.mainProgress += self.increasePerInterval!
        self.view!.updateMainTest(mainProgress: self.mainProgress)
    }
}
