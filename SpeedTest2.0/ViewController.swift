//
//  ViewController.swift
//  SpeedTest
//
//  Created by Giuliano Pes on 18/10/18.
//  Copyright © 2018 Giuliano Pes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //interface
    @IBOutlet weak var progressBar1: UIProgressView!
    @IBOutlet weak var progressBar2: UIProgressView!
    @IBOutlet weak var progressBar3: UIProgressView!
    @IBOutlet weak var mainProgressBar: UIProgressView!
    @IBOutlet weak var mainProgressLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    private let dataSource:[Int] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
    @IBOutlet weak var pickerSlowStart: UIPickerView!
    @IBOutlet weak var slowStartLabel: UILabel!
    @IBOutlet weak var loopSwitch: UISegmentedControl!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    var secOfSlowStartSelected:Int?
    @IBOutlet var resultView: UITextView!
    var numberOfTest:Int?
    
    //object
    var test:Test?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //pc
        //let url = URL(string: "http://192.168.1.7/exampleServer/")!
        //mac
        let url = URL(string: "http://192.168.64.2/exampleServer/")!
        
        
        if !ConnectionCheck.init().internetIsAvailable(url: url){
            showConnectionAlert()
        }
    
        self.test = Test.init(view: self, url: url)
        DispatchQueue.main.async{
            self.pickerSlowStart.dataSource = self
            self.pickerSlowStart.delegate = self
            self.activityView.hidesWhenStopped = true
            self.activityView.isHidden = true
            self.slowStartLabel.text = "1 of slow start"
            self.secOfSlowStartSelected = 1
            self.resultView.text = "Result\tMb/s\n"
            self.numberOfTest = 0
            
            //
            /*
            print(UIDevice.current.name)
            print("\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)")
            */
            //let app = UIApplication.shared
            
            
        }
    }
    
    @IBAction func tapStartButton(_ sender: UIButton){
        starTest()
    }
    
    func starTest(){
        if self.startButton.currentTitle == "Start"{
            DispatchQueue.main.async {
                self.stateLabel.text = "slow start..."
            }
        }else if self.startButton.currentTitle == "Start again"{
            DispatchQueue.main.async{
                self.progressBar1.progress = 0.0
                self.progressBar2.progress = 0.0
                self.progressBar3.progress = 0.0
                self.mainProgressBar.progress = 0.0
                self.mainProgressLabel.text = "0%"
            }
        }
        self.startButton.setTitle("", for: UIControl.State.normal)
        self.startButton.isUserInteractionEnabled = false
        self.pickerSlowStart.isUserInteractionEnabled = false
        self.loopSwitch.isUserInteractionEnabled = false
        self.test!.start(secOfSlowStart: self.secOfSlowStartSelected!)
        self.activityView.startAnimating()
    }
    
    func startSendingSlowStart(){
        //cambia lo stato del test: da '0' a 'slowStart'
        //deve quindi aggiornare l'interfaccia
        DispatchQueue.main.async{
            self.stateLabel!.text = "slowStart..."
        }
    }
    
    func startSendingRandomData(){
        //cambia lo stato del test: da 'slowStart' a 'randomData'
        //deve quindi aggiornare l'interfaccia
        DispatchQueue.main.async{
            self.stateLabel!.text = "randomData..."
        }
    }
    
    func downloadTestUpdate(speed: Double){
        DispatchQueue.main.async{
            self.stateLabel!.text = "download result"
            self.mainProgressLabel.text = "100%"
            self.mainProgressBar.progress = 1.0
            let strSpeed = "\(speed)".prefix(8)
            print("Download: \(strSpeed)")
            self.resultView.text.append(contentsOf: "\t\(self.numberOfTest!)\t\(strSpeed)\n")
        }
    }
    
    func uploadTestUpdate(speed: Double){
        DispatchQueue.main.async{
            self.stateLabel!.text = "update result"
            self.mainProgressLabel.text = "100%"
            self.mainProgressBar.progress = 1.0
            let strSpeed = "\(speed)".prefix(8)
            print("Upload: \(strSpeed)")
            self.resultView.text.append(contentsOf: "\t\(self.numberOfTest!)\t\(strSpeed)\n")
        }
    }
    
    
    func finishedTest(speed: Double){
        //cambia lo stato del test: da randomData' a 1
        //deve quindi aggiornare l'interfaccia
        self.numberOfTest! += 1
        DispatchQueue.main.async{
            self.stateLabel!.text = "Result"
            self.startButton.isUserInteractionEnabled = true
            self.startButton.setTitle("Start again", for: UIControl.State.normal)
            self.mainProgressLabel.text = "100%"
            self.mainProgressBar.progress = 1.0
            self.activityView.stopAnimating()
            self.pickerSlowStart.isUserInteractionEnabled = true
            self.loopSwitch.isUserInteractionEnabled = true
            let strSpeed = "\(speed)".prefix(8)
            self.resultView.text.append(contentsOf: "\t\(self.numberOfTest!)\t\(strSpeed)\n")
        }
        
        if self.loopSwitch.selectedSegmentIndex == 1{//loop
            run(after: 1){
                 self.starTest()
            }
        }
    }
    
    func run(after seconds:Int,completion: @escaping()->Void){
        let deadline = DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline: deadline){
            completion()
        }
    }
    
    //Aggiornamento degli upload
    func updateUploadProgress(upload:Upload){
        //deve quindi aggiornare l'interfaccia
        let progress:Float = Float(upload.progress!)
        switch upload.idUpload{
        case 1:
            DispatchQueue.main.async{
                self.progressBar1.progress = progress
            }
            return
        case 2:
            DispatchQueue.main.async{
                self.progressBar2.progress = progress
            }
            return
        case 3:
            DispatchQueue.main.async{
                self.progressBar3.progress = progress
            }
            return
        default:
            print("nessun upload individuato!")
            return
        }
    }
    
    func updateDownloadProgress(download: Download){
        
        let progress:Float = Float(download.progress!)
        switch download.idDownload{
        case 1:
            DispatchQueue.main.async{
                self.progressBar1.progress = progress
            }
            return
        case 2:
            DispatchQueue.main.async{
                self.progressBar2.progress = progress
            }
            return
        case 3:
            DispatchQueue.main.async{
                self.progressBar3.progress = progress
            }
            return
        default:
            print("nessun download individuato!")
            return
        }
        
    }
    
    func updateMainTest(mainProgress:Float){
        if mainProgress<=1.0{
            DispatchQueue.main.async{
                self.mainProgressBar.progress = mainProgress
                self.mainProgressLabel.text = "\(Int(mainProgress*100))%"
            }
        }
    }
    
    func showConnectionAlert(){
        var alertController: UIAlertController?
        alertController = UIAlertController(title: "Connection failed!", message: "Cotrol your connectivity options", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController!.addAction(confirmAction)
        
        DispatchQueue.main.async{
            self.present(alertController!, animated: true, completion: nil)
        }
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    //quante colonne/rotelle
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return self.dataSource.count
    }
    //row=riga, passata al dataSource restituisce il valore di quella riga
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        self.slowStartLabel.text = "\(dataSource[row]) of slow start"
        self.secOfSlowStartSelected = dataSource[row]
        //print(self.secOfSlowStartSelected!)
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return "\(self.dataSource[row])"
    }
}
