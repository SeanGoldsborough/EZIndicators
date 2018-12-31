//
//  BinanceAPI.swift
//  EZIndicators
//
//  Created by Sean Goldsborough on 12/28/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import Foundation
import QuartzCore
//TODO: put funcs for API call to get data for each time period needed here

class BinanceAPI {

//var parsedResult: AnyObject!
//var coinDataArray = [CoinData]()
var coinDataArray = [AnyObject]()
var coinPriceArray = [Double]()
var oneCoinPrice = ""
var session = URLSession.shared
    
    func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: Error?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            //parsedResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [[String : AnyObject]] as AnyObject
            print("parsed result is:")
            print(parsedResult.count)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            //completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
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
            
            /* GUARD: Was there an error? */
            guard data != nil else {
                sendError(error)
                //sendError((error?.localizedDescription)!)
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
        let start = CACurrentMediaTime()
        
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
                    
                    let end = CACurrentMediaTime()
                    print("\(end)")
                    print("time to make API Call is:")
                    print(end - start)
                    
                } else {
                    completionHandlerForGet([], error?.localizedDescription)
                }
            }
        }
    }
    
    



func taskForGETMethod(completionHandlerForGet: @escaping (_ result: AnyObject?, _ error: Error?) -> Void) -> URLSessionDataTask {
    
    /* 1. Set the parameters */
    //var parametersWithApiKey = parameters
    let url = NSURL(string: "https://api.binance.com/api/v3/ticker/price?symbol=BTCUSDT")

    
    /* 2/3. Build the URL, Configure the request */
    let request = NSMutableURLRequest(url: url as! URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
    
    /* 4. Make the request */
    let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
        print("single coin price data from binance is: \(data)")
        func sendError(_ error: Error?) {
            print(error)
            //let userInfo = [NSLocalizedDescriptionKey : error]
            completionHandlerForGet(nil, error)
            //completionHandlerForGet(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
        }
        
        /* GUARD: Was there an error? */
        guard data != nil else {
            sendError(error)
            //sendError((error?.localizedDescription)!)
            //sendError("No data was returned by the request"
            return
        }
        
        guard let range = Range?(0..<data!.count) else {
            sendError(error)
            //sendError((error?.localizedDescription)!)
            //sendError("ERROR ON RANGE/DATA!")
            return
        }
        
        let newData = data?.subdata(in: range) /* subset response data! */
//        var encodedData = String(data: newData!, encoding: .utf8)!
//        var encodedDataInt = Double(encodedData)
//        print("encoded data is: \(encodedData)")
//        print("encoded data as double is: \(encodedDataInt)")
        
        /* GUARD: Did we get a successful 2XX response? */
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
            sendError(error)
            //sendError((error?.localizedDescription)!)
            //sendError("There was an error with your request")
            return
        }
        
        /* GUARD: Was there any data returned? */
        guard let data = newData else {
            sendError(error)
            //sendError((error?.localizedDescription)!)
            //sendError("No data was returned by the request")
            return
        }
        
        /* 5/6. Parse the data and use the data (happens in completion handler) */
        self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGet)
    }
    
    /* 7. Start the request */
    task.resume()
    
    return task
}
    
    func getCoinPrice(_ completionHandlerForGet: @escaping (_ result: String?, _ error: String?) -> Void) {
        let start = CACurrentMediaTime()
        
        let _ = taskForGETMethod() { (results, error) in
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForGet(nil, error.localizedDescription)
            } else {
                
                if let result = results {
                    print("results is: \(results!)")
                    guard let myResult = result as? [String: Any] else { return }
                    print("JSON ARRAY IS:")
                    print(myResult)
                    
                    guard let price = myResult["price"] as? String else { return }
                    print(price) // delectus aut autem
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
                    
                    let end = CACurrentMediaTime()
                    print("\(end)")
                    print("time to make API Call is:")
                    print(end - start)
                    
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


