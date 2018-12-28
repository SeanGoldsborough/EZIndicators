//
//  BinanceAPI.swift
//  EZIndicators
//
//  Created by Sean Goldsborough on 12/28/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import Foundation
//TODO: put funcs for API call to get data for each time period needed here

//var parsedResult: AnyObject!
var coinDataArray = [CoinData]()
var session = URLSession.shared
//
//    if let json = (try? JSONSerialization.jsonObject(with: newData!, options: JSONSerialization.ReadingOptions(rawValue: 0))) as? [[String : AnyObject]] {
//    print(json.count) // Should be 2, based on your sample json above

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


func taskForGETMethodUdacity(completionHandlerForUdacityGET: @escaping (_ result: AnyObject?, _ error: Error?) -> Void) -> URLSessionDataTask {
    
    /* 1. Set the parameters */
    //var parametersWithApiKey = parameters
    let url = NSURL(string: "https://api.binance.com/api/v1/klines?symbol=BNBBTC&interval=1h")
    
    //let variant = URLPathVariants.UdacityUserID + APIClient.sharedInstance().uniqueID!
    
    /* 2/3. Build the URL, Configure the request */
    let request = NSMutableURLRequest(url: url as! URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
    
    /* 4. Make the request */
    let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
        print("data from binance is: \(data)")
        func sendError(_ error: Error?) {
            print(error)
            //let userInfo = [NSLocalizedDescriptionKey : error]
            completionHandlerForUdacityGET(nil, error)
            //completionHandlerForUdacityGET(nil, NSError(domain: "taskForGETMethodUdacity", code: 1, userInfo: userInfo))
        }
        
        /* GUARD: Was there an error? */
        guard data != nil else {
            sendError(error)
            //sendError((error?.localizedDescription)!)
            //sendError("No data was returned by the request")
            return
        }
        
        guard let range = Range?(0..<data!.count) else {
            sendError(error)
            //sendError((error?.localizedDescription)!)
            //sendError("ERROR ON RANGE/DATA!")
            return
        }
        
        let newData = data?.subdata(in: range) /* subset response data! */
        var encodedData = String(data: newData!, encoding: .utf8)!
        var encodedDataInt = Double(encodedData)
        print("encoded data is: \(encodedData)")
        print("encoded data as double is: \(encodedDataInt)")
        
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
        convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForUdacityGET)
    }
    
    /* 7. Start the request */
    task.resume()
    
    return task
}

func getPublicUserDataUdacity(_ completionHandlerForUdacityGet: @escaping (_ result: CoinData?, _ error: String?) -> Void) {
    let start = CACurrentMediaTime()
    //1. Specify parameters, method (if has {key}), and HTTP body (if POST)
    //let parameters = [String:AnyObject]()
    
    //let variant = URLPathVariants.UdacityUserID + APIClient.sharedInstance().uniqueID!
    
    /* 2. Make the request */
    
    let _ = taskForGETMethodUdacity() { (results, error) in
        /* 3. Send the desired value(s) to completion handler */
        if let error = error {
            completionHandlerForUdacityGet(nil, error.localizedDescription)
        } else {
            
            if let result = results {
                print("results is: \(results)")
                if let udacityError = results!["error"] as? String {
                    print("Udacity error is: \(udacityError)")
                    print("Udacity error!")
                    
                    completionHandlerForUdacityGet(nil, udacityError)
                } else {
                    print("No Udacity error!")
                    //print("Udacity results is: \(results)")
                    print(result.indexPath?.row)
                    print("No Udacity error!")
                }
                
                
                
                //                guard let getResults = results![""] as? [[String:AnyObject]]else { return }
                //                print("get results is: \(getResults)")
                
                //                    guard let firstNameResults = getResults["nickname"] as? String else {
                //                        return
                //                    }
                //                    UdacityPersonalData.sharedInstance().firstName = firstNameResults
                //
                //                    guard let lastNameResults = getResults["last_name"] as? String else {
                //                        return
                //                    }
                //                    UdacityPersonalData.sharedInstance().lastName = lastNameResults
                //
                //
                //                    guard let keyResults = getResults["key"] as? String else {
                //                        return
                //                    }
                //                    UdacityPersonalData.sharedInstance().uniqueKey = keyResults
                completionHandlerForUdacityGet(CoinData.sharedInstance(), nil)
                
                let end = CACurrentMediaTime()
                print("\(end)")
                print("time to make API Call is:")
                print(end - start)
                
            } else {
                completionHandlerForUdacityGet(nil, error?.localizedDescription)
            }
        }
    }
}

getPublicUserDataUdacity { (results, error) in
    coinDataArray = [results!]
    
    print("The self.coinDataArray count is: \(coinDataArray.count)")
    print("The self.coinDataArray count is: \(CoinData.sharedInstance().openTime)")
    print("The binance data array  count is: \(results)")
}
