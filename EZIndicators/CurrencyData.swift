//
//  CurrencyData.swift
//  EZIndicators
//
//  Created by Sean Goldsborough on 12/28/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import Foundation
// TODO: put a shared instance singleton struct data model here

class CoinDataArray : NSObject {
    public var listOfCoinPrices : [CoinData] = []
    
    static let sharedInstance = CoinDataArray()
}

class CoinData : NSObject {
    public var openTime: Double? = 0.0
    public var o: Double? = 0.0
    public var h: Double? = 0.0
    public var l: Double? = 0.0
    public var c: Double? = 0.0
    public var v: Double? = 0.0
    public var closeTime: Double? = 0.0
    public var gav: Double? = 0.0
    public var numTrades: Double? = 0.0
    public var takerBaseVol: Double? = 0.0
    public var takerQuoteVol: Double? = 0.0
    public var ignore: Double? = 0.0
    
    init?(dictionary: [String:AnyObject]) {
        
        openTime = dictionary["openTime"] as? Double ?? 0.00
        o = dictionary["o"] as? Double ?? 0.00
        h = dictionary["h"] as? Double ?? 0.00
        l = dictionary["l"] as? Double ?? 0.00
        c = dictionary["c"] as? Double ?? 0.00
        v = dictionary["v"] as? Double ?? 0.00
        closeTime = dictionary["closeTime"] as? Double ?? 0.00
        gav = dictionary["gav"] as? Double ?? 0.00
        numTrades = dictionary["numTrades"] as? Double ?? 0.00
        takerBaseVol = dictionary["takerBaseVol"] as? Double ?? 0.00
        takerQuoteVol = dictionary["takerQuoteVol"] as? Double ?? 0.00
        ignore = dictionary["ignore"] as? Double ?? 0.00
    }
    
    // MARK: Shared Instance
    
//    class func sharedInstance() -> CoinData {
//        struct Singleton {
//            static var sharedInstance = CoinData()
//        }
//        return Singleton.sharedInstance
//    }
    

    
    static func coinDataFromResults(_ results: [[String:AnyObject]]) -> [CoinData] {
        
        var coins = [CoinData]()
        var coinPriceList = CoinDataArray.sharedInstance.listOfCoinPrices
        
        // iterate through array of dictionaries, each Movie is a dictionary
        for result in results {
            coins.append(CoinData(dictionary: result)!)
            coinPriceList.append(CoinData(dictionary: result)!)
            
        }
        return coins
    }
}
