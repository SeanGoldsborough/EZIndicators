//
//  MainVC.swift
//  EZIndicators
//
//  Created by Sean Goldsborough on 12/28/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class MainVC: UIViewController {
    
    @IBOutlet weak var currentPriceLabel: UILabel!
    
    @IBOutlet weak var goldenCrossIndicator: UILabel!
    
    @IBOutlet weak var macdIndicator: UILabel!
    
    @IBOutlet weak var rsiIndicator: UILabel!
    
    
    @IBAction func refreshButton(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        func executionTimeInterval(block: () -> ()) -> CFTimeInterval {
            let start = CACurrentMediaTime()
            block();
            let end = CACurrentMediaTime()
            return end - start
        }
        let start = CACurrentMediaTime()
        
        print("\(start)")
        
        // Array of 200 Prices
        var pricesArray: [Double] = []
        
        func createRandomNumber() {
            let randomNumber = Double(arc4random_uniform(20))
            
            print(randomNumber)
            //pricesArray.append(randomNumber)
        }
        
        var randomArray = (1...200).map{_ in Double(arc4random_uniform(10))}
        
        let numberArray = [1.0, 2.0, 3.0, 4.0]
        let numberReduce = numberArray.reduce(0.0, { x, y in x + y })
        print("numberReduce is: \(numberReduce)")
        
        print("numberReduce Avg is: \(numberReduce / Double(numberArray.count))")
        
        
        // Init dayAvg Variable
        var twoHundredDayAverage: Double = 0.0
        var fiftyDayAverage: Double = 0.0
        var twentySixDayAverage: Double = 0.0
        var twelveDayAverage: Double = 0.0
        
        var goldenCross: Bool = false
        var MACD: Bool = false
        
        print(randomArray)
        
        // Calculate 200 day average
        func twoHunAvg() {
            twoHundredDayAverage = randomArray.reduce(0, { x, y in
                x + y
            }) / 200
            print("twoHundredDayAverage is: \(twoHundredDayAverage)")
        }
        
        twoHunAvg()
        
        print("poop")
        
        //Remove old price and add new price to array to get average
        let newPrice = 9.0
        randomArray.remove(at: 0)
        randomArray.append(newPrice)
        
        print(randomArray)
        twoHunAvg()
        print("NEW twoHundredDayAverage is: \(twoHundredDayAverage)")
        
        func fiftyDayAvg() {
            
            let fiftyDayArray = randomArray.suffix(50)
            print("fiftyDayArray is: \(fiftyDayArray)")
            print("fiftyDayArray count is: \(fiftyDayArray.count)")
            fiftyDayAverage = fiftyDayArray.reduce(0, { x, y in
                x + y
            }) / 50
            print("fiftyDayAverage is: \(fiftyDayAverage)")
        }
        
        fiftyDayAvg()
        
        if fiftyDayAverage > twoHundredDayAverage {
            print("Golden Cross")
            goldenCross = true
            self.goldenCrossIndicator.backgroundColor = UIColor.green
            self.goldenCrossIndicator.text! = "GO"
        } else if fiftyDayAverage < twoHundredDayAverage {
            print("Death Cross")
            self.goldenCrossIndicator.backgroundColor = UIColor.red
            self.goldenCrossIndicator.text! = "STOP"
        }

        
        /////// MACD
        
        func twentySixDayAvg() {
            
            let twentySixDayArray = randomArray.suffix(26)
            print("twentySixDayArray is: \(twentySixDayArray)")
            print("twentySixDayArray count is: \(twentySixDayArray.count)")
            twentySixDayAverage = twentySixDayArray.reduce(0, { x, y in
                x + y
            }) / 26
            print("twentySixDayAverage is: \(twentySixDayAverage)")
        }
        
        twentySixDayAvg()
        
        func twelveDayAvg() {
            
            let twelveDayArray = randomArray.suffix(12)
            print("twelveDayArray is: \(twelveDayArray)")
            print("ttwelveDayArray count is: \(twelveDayArray.count)")
            twelveDayAverage = twelveDayArray.reduce(0, { x, y in
                x + y
            }) / 12
            print("twelveDayAverage is: \(twelveDayAverage)")
        }
        
        twelveDayAvg()
        // MACD execution
        if twelveDayAverage > twentySixDayAverage {
            print("UPTREND - BUY")
            MACD = true
            self.macdIndicator.text! = "GO"
            self.macdIndicator.backgroundColor = UIColor.green
        } else if twelveDayAverage < twentySixDayAverage {
            print("DOWNTREND - SELL")
            MACD = false
            self.macdIndicator.text! = "STOP"
            self.macdIndicator.backgroundColor = UIColor.red
        }
        
                if MACD == true && goldenCross == true {
                    print("BUYING NOW!")
                } else if MACD == false && goldenCross == true || MACD == true && goldenCross == false {
                    print("murky waters here")
                } else {
                    print("SELLING NOW!!!")
                }
        
       
        
        let end = CACurrentMediaTime()
        print("\(end)")
        print(end - start)
    }
}

