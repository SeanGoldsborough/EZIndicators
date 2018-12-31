//
//  BinanceAPI.swift
//  EZIndicators
//
//  Created by Sean Goldsborough on 12/28/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import Foundation
import QuartzCore

class BinanceAPI {

var coinDataArray = [AnyObject]()
var coinPriceArray = [Double]()
var oneCoinPrice = ""
var session = URLSession.shared
    
    func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: Error?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            print("parsed result is:")
            print(parsedResult.count)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
        
            completionHandlerForConvertData(nil, error)
            print("The error on JSON func is: '\(error)'")
        }
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    func taskForGETAllPricesMethod(completionHandlerForGet: @escaping (_ result: AnyObject?, _ error: Error?) -> Void) -> URLSessionDataTask {
        
        let url = NSURL(string: "https://api.binance.com/api/v1/trades?symbol=BTCUSDT&limit=200")
        
        let request = NSMutableURLRequest(url: url as! URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)

        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            print("single coin price data from binance is: \(data)")
            func sendError(_ error: Error?) {
                print(error)
  
                completionHandlerForGet(nil, error)                
            }

            guard data != nil else {
                sendError(error)
                return
            }
            
            guard let range = Range?(0..<data!.count) else {
                sendError(error)
                return
            }
            
            let newData = data?.subdata(in: range) /* subset response data! */

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError(error)
                return
            }
            
            guard let data = newData else {
                sendError(error)
                return
            }
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGet)
        }
        task.resume()
        return task
    }
    
    func getAllCoinPrices(_ completionHandlerForGet: @escaping (_ result: [Double], _ error: String?) -> Void) {
        self.coinPriceArray.removeAll()
        let _ = taskForGETAllPricesMethod() { (results, error) in
           
            if let error = error {
                completionHandlerForGet([], error.localizedDescription)
            } else {
                
                if let jsonResponse = results {
                    print("results is: \(results!)")
                    guard let jsonArray = jsonResponse as? [[String: Any]] else { return }
                    print("JSON ARRAY IS:")
                    print(jsonArray)
                    
                    for dic in jsonArray{
                        guard let price = dic["price"] as? String else { return }
                        print("price is: \(price)")
                        self.coinPriceArray.append(Double(price) ?? 0.00)
                        print(self.coinPriceArray)
                    }
                    
                    if let udacityError = results!["error"] as? String {
                        
                        print("Udacity error is: \(udacityError)")
                        print("Udacity error!")
                        
                        completionHandlerForGet([], udacityError)
                        
                    } else {
                        print("No Udacity error!")
                    }
                    
                    completionHandlerForGet(self.coinPriceArray, nil)
                    
                } else {
                    completionHandlerForGet([], error?.localizedDescription)
                }
            }
        }
    }


func taskForGETMethod(completionHandlerForGet: @escaping (_ result: AnyObject?, _ error: Error?) -> Void) -> URLSessionDataTask {
    
    let url = NSURL(string: "https://api.binance.com/api/v3/ticker/price?symbol=BTCUSDT")
    let request = NSMutableURLRequest(url: url as! URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
    let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
        print("single coin price data from binance is: \(data)")
        func sendError(_ error: Error?) {
            print(error)
            completionHandlerForGet(nil, error)
        }

        guard data != nil else {
            sendError(error)
            return
        }
        
        guard let range = Range?(0..<data!.count) else {
            sendError(error)
            return
        }
        
        let newData = data?.subdata(in: range) /* subset response data! */

        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
            sendError(error)
            return
        }

        guard let data = newData else {
            sendError(error)
            return
        }
        self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGet)
    }
    task.resume()
    return task
}
    
    func getCoinPrice(_ completionHandlerForGet: @escaping (_ result: String?, _ error: String?) -> Void) {
        
        let _ = taskForGETMethod() { (results, error) in
            if let error = error {
                completionHandlerForGet(nil, error.localizedDescription)
            } else {
                
                if let result = results {
                    print("results is: \(results!)")
                    guard let myResult = result as? [String: Any] else { return }
                    print("JSON ARRAY IS:")
                    print(myResult)
                    
                    guard let price = myResult["price"] as? String else { return }
                    print(price)
                    self.oneCoinPrice = price
                    print("label text is \(price)")
                    
                    if let udacityError = results!["error"] as? String {
                
                        print("Udacity error is: \(udacityError)")
                        print("Udacity error!")
                        completionHandlerForGet(nil, udacityError)
                        
                    } else {
                        print("No Udacity error!")
                    }
                    
                    completionHandlerForGet(price, nil)
                    
                } else {
                    completionHandlerForGet(nil, error?.localizedDescription)
                }
            }
        }
    }

    // MARK: Shared Instance
    
    class func sharedInstance() -> BinanceAPI {
        struct Singleton {
            static var sharedInstance = BinanceAPI()
        }
        return Singleton.sharedInstance
    }
}
