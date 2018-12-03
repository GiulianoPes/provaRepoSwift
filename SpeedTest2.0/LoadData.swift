//
//  LoadData.swift
//  SpeedTest
//
//  Created by Giuliano Pes on 20/10/18.
//  Copyright © 2018 Giuliano Pes. All rights reserved.
//

import Foundation

class LoadData{
    
    private var slowStart1:Data?
    var slowStart1Corrente:Data?{
        get{
            return self.slowStart1
        }
    }
    private var randomData1:Data?
    var randomData1Corrente:Data?{
        get{
            return self.randomData1
        }
    }
    
    private var slowStart2:Data?
    var slowStart2Corrente:Data?{
        get{
            return self.slowStart2!
        }
    }
    private var randomData2:Data?
    var randomData2Corrente:Data?{
        get{
            return self.randomData2
        }
    }
    
    private var slowStart3:Data?
    var slowStart3Corrente:Data?{
        get{
            return self.slowStart3
        }
    }
    private var randomData3:Data?
    var randomData3Corrente:Data?{
        get{
            return self.randomData3
        }
    }
    
    init(){
        let pathSlowStart1 = "Users/giulianopes/Documents/slowStart1.dms"
        let pathRandomData1 = "Users/giulianopes/Documents/randomData1.dms"
        
        let pathSlowStart2 = "Users/giulianopes/Documents/slowStart2.dms"
        let pathRandomData2 = "Users/giulianopes/Documents/randomData2.dms"
        
        let pathSlowStart3 = "Users/giulianopes/Documents/slowStart3.dms"
        let pathRandomData3 = "Users/giulianopes/Documents/randomData3.dms"
        
        self.slowStart1 = FileManager.default.contents(atPath: pathSlowStart1)
        self.randomData1 = FileManager.default.contents(atPath: pathRandomData1)
        
        self.slowStart2 = FileManager.default.contents(atPath: pathSlowStart2)
        self.randomData2 = FileManager.default.contents(atPath: pathRandomData2)
        
        self.slowStart3 = FileManager.default.contents(atPath: pathSlowStart3)
        self.randomData3 = FileManager.default.contents(atPath: pathRandomData3)
        
        guard let _ = slowStart1 else{
            print("slowStart1 non trovato!")
            return
        }
        guard let _ = randomData1 else{
            print("randomData1 non trovato!")
            return
        }
        
        guard let _ = slowStart2 else{
            print("slowStart2 non trovato!")
            return
        }
        guard let _ = randomData2 else{
            print("randomData2 non trovato!")
            return
        }
        
        guard let _ = slowStart3 else{
            print("slowStart3 non trovato!")
            return
        }
        guard let _ = randomData3 else{
            print("randomData3 non trovato!")
            return
        }
    }
    
    func getData() -> ((slowStart1 :Data,randomData1: Data),(slowStart2: Data,randomData2: Data),(slowStart3:Data,randomData3 :Data)){
        return ((self.slowStart1Corrente!,self.randomData1Corrente!),(self.slowStart2Corrente!,self.randomData2Corrente!),(self.slowStart3Corrente!,self.randomData3Corrente!))
    }
}
