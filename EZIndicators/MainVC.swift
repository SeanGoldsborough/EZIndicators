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
    
    var oneCoinPrice = ""
    
    var coinPriceArray = BinanceAPI.sharedInstance().coinPriceArray
    
    // Init dayAvg Variable
    var twoHundredDayAverage: Double = 0.0
    var fiftyDayAverage: Double = 0.0
    var twentySixDayAverage: Double = 0.0
    var twelveDayAverage: Double = 0.0

    var goldenCross: Bool = false
    var MACD: Bool = false
    
    @IBOutlet weak var currentPriceLabel: UILabel!
    
    @IBOutlet weak var goldenCrossIndicator: UILabel!
    
    @IBOutlet weak var macdIndicator: UILabel!
    
    @IBOutlet weak var rsiIndicator: UILabel!
    
    @IBAction func refreshButton(_ sender: Any) {
        self.coinPriceArray.removeAll()
        print("coinDataArray is:")
        print(self.coinPriceArray)
        
        BinanceAPI.sharedInstance().getCoinPrice { (results, error) in
            
            self.oneCoinPrice = results!
            DispatchQueue.main.async {
                self.currentPriceLabel.text! = "\(results!)"
            }
        }
        
        BinanceAPI.sharedInstance().getAllCoinPrices { (results, error) in
            
            self.coinPriceArray = results
            print("coin array count is:")
            print(self.coinPriceArray.count)
            
            self.twoHunAvg()
            self.fiftyDayAvg()
            self.twelveDayAvg()
            self.twentySixDayAvg()
            
            DispatchQueue.main.async {
                self.currentPriceLabel.text! = ""
                self.currentPriceLabel.text! = "\(BinanceAPI.sharedInstance().oneCoinPrice)"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BinanceAPI.sharedInstance().getCoinPrice { (results, error) in
            
            self.oneCoinPrice = results!
            DispatchQueue.main.async {
                self.currentPriceLabel.text! = "\(results!)"
            }
        }
        
        BinanceAPI.sharedInstance().getAllCoinPrices { (results, error) in
            self.compareFiftyAndTwoHundred()
            self.compareTwelveTwentySix()
        }

        
}
    
    // Array of 200 Prices

    func createRandomNumber() {
        let randomNumber = Double(arc4random_uniform(20))
        print(randomNumber)
    }
 
    // Calculate 200 day average - func should take argument of array and return a double
    func twoHunAvg() {
        print(coinPriceArray)
        
        twoHundredDayAverage = coinPriceArray.reduce(0, { x, y in
            x + y
        }) / 200
        print("twoHundredDayAverage is: \(twoHundredDayAverage)")
        //return twoHundredDayAverage
    }
    
    func fiftyDayAvg() {
        
        let fiftyDayArray = coinPriceArray.suffix(50)
        print("fiftyDayArray is: \(fiftyDayArray)")
        print("fiftyDayArray count is: \(fiftyDayArray.count)")
        fiftyDayAverage = fiftyDayArray.reduce(0, { x, y in
            x + y
        }) / 50
        print("fiftyDayAverage is: \(fiftyDayAverage)")
    }
   
    func compareFiftyAndTwoHundred() {
        fiftyDayAvg()
        twoHunAvg()
        
        if fiftyDayAverage > twoHundredDayAverage {
            print("Golden Cross")
            goldenCross = true
        
            DispatchQueue.main.async {
                self.goldenCrossIndicator.backgroundColor = UIColor.green
                self.goldenCrossIndicator.text! = "GO"
            }
        } else if fiftyDayAverage < twoHundredDayAverage {
            print("Death Cross")
            DispatchQueue.main.async {
                self.goldenCrossIndicator.backgroundColor = UIColor.red
                self.goldenCrossIndicator.text! = "STOP"
            }
        }
    }
    
    /////// MACD
    
    func twentySixDayAvg() {
        
        let twentySixDayArray = coinPriceArray.suffix(26)
        print("twentySixDayArray is: \(twentySixDayArray)")
        print("twentySixDayArray count is: \(twentySixDayArray.count)")
        twentySixDayAverage = twentySixDayArray.reduce(0, { x, y in
            x + y
        }) / 26
        print("twentySixDayAverage is: \(twentySixDayAverage)")
    }
    
    func twelveDayAvg() {
        
        let twelveDayArray = coinPriceArray.suffix(12)
        print("twelveDayArray is: \(twelveDayArray)")
        print("ttwelveDayArray count is: \(twelveDayArray.count)")
        twelveDayAverage = twelveDayArray.reduce(0, { x, y in
            x + y
        }) / 12
        print("twelveDayAverage is: \(twelveDayAverage)")
    }

//    MACD execution
    func compareTwelveTwentySix() {
    
        self.twelveDayAvg()
        self.twentySixDayAvg()
    
        if twelveDayAverage > twentySixDayAverage {
            print("UPTREND - BUY")
            MACD = true
            DispatchQueue.main.async {
                self.macdIndicator.text! = "GO"
                self.macdIndicator.backgroundColor = UIColor.green
            }
        } else if twelveDayAverage < twentySixDayAverage {
            print("DOWNTREND - SELL")
            MACD = false
            DispatchQueue.main.async {
                self.macdIndicator.text! = "STOP"
                self.macdIndicator.backgroundColor = UIColor.red
            }
        }
    }
}

