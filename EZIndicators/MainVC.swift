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
            
            self.twoHunAvg(array: self.coinPriceArray)
            self.fiftyDayAvg()
            self.twelveDayAvg()
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

        twoHunAvg(array: coinPriceArray)
        fiftyDayAvg()
        twelveDayAvg()
}
    
    // Array of 200 Prices

    func createRandomNumber() {
        let randomNumber = Double(arc4random_uniform(20))
        
        print(randomNumber)
    }
 
    // Calculate 200 day average - func should take argument of array and return a double
    func twoHunAvg(array: [Double]) -> Double {
        
        var randomArray = coinPriceArray
        print(randomArray)
        
        twoHundredDayAverage = randomArray.reduce(0, { x, y in
            x + y
        }) / 200
        print("twoHundredDayAverage is: \(twoHundredDayAverage)")
        
        return twoHundredDayAverage
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
    
    //twentySixDayAvg()
    
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
    }
    
    ///////RSI CALCULATIONS
    //Oldest price is first in the array
    //SharpCharts uses at least 250 data points prior to the starting date of any chart (assuming that much data exists) when calculating its RSI values. To duplicate its RSI number, you'll need to use at least that much data also.
    //var lastFourteenClosingPrices = [44.34, 44.09, 44.15, 43.61, 44.33, 44.83, 45.10, 45.42, 45.84, 46.08, 45.89, 46.03, 45.61, 46.28]
    //var lastFourteenClosingPrices = [46.1250, 47.1250, 46.4375, 46.9375, 44.9375, 44.2500, 44.6250, 45.7500, 47.8125, 47.5625, 47.00, 44.5625, 46.3125, 47.6875, 46.6875]
    var lastFourteenClosingPrices = [0.05442, 0.057, 0.05808, 0.05783, 0.05019, 0.0513, 0.05156, 0.04868, 0.04701, 0.04581, 0.04669, 0.04632, 0.04488, 0.04284]
    
    
//    var arrayOfGains = [Double]()
//    var arrayOfLosses = [Double]()
//
//    for i in 0 ..< lastFourteenClosingPrices.count - 1 {
//    var number = lastFourteenClosingPrices[i + 1] - lastFourteenClosingPrices[i]
//    print(number)
//    if number > 0 { arrayOfGains.append(number) } else { arrayOfLosses.append(number) }
//    }
//    print("array of gains is:\(arrayOfGains)")
//    print("array of losses is:\(arrayOfLosses)")
//
//    let firstAvgGains = arrayOfGains.reduce(0, { x, y in x + y }) / 14
//    let firstAvgLosses = abs(arrayOfLosses.reduce(0, { x, y in x + y }) / 14)
//
//    print("firstAvgGains is:\(firstAvgGains)")
//    print("firstAvgLosses is:\(firstAvgLosses)")
//
//    //print(abs(firstAvgLosses))
//
//    let firstRS = firstAvgGains / firstAvgLosses
//    print("firstRS is: \(firstRS)")
//
//    let RSI = 100 - (100 / (1 + firstRS))
//    print("RSI is: \(RSI)")
//
//    let smoothedRS = (((firstAvgGains * 13) + 0.00 ) / 14) / (((firstAvgLosses * 13) + 1.00 ) / 14)
//    print("smoothedRS is: \(smoothedRS)")
//
//    let smoothedRSI = 100 - (100 / (1 + smoothedRS))
//    print("smoothedRSI is: \(smoothedRSI)")
//}
}

