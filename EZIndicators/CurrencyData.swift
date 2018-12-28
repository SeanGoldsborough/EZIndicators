//
//  CurrencyData.swift
//  EZIndicators
//
//  Created by Sean Goldsborough on 12/28/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import Foundation
// TODO: put a shared instance singleton struct data model here
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
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> CoinData {
        struct Singleton {
            static var sharedInstance = CoinData()
        }
        return Singleton.sharedInstance
    }
}
