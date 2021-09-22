//
//  RequestManager.swift
//  DemoMeteor
//
//  Created by Jagdish on 22/09/21.
//

import Foundation
class RequestManager {
    
    static var shared = RequestManager()
    private init() {
        
    }
    
    func getMeteorData(block: @escaping (_ flag: Bool, _ elements: [MeteorElement]?, _ message: String?) -> Void) {

        let escapedString = "https://data.nasa.gov/resource/gh4g-9sfh.json"

        var request = URLRequest.init(url: URL(string: escapedString)!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.timeoutInterval = 200.0
       
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            

            if error == nil {
                let res = response as! HTTPURLResponse
                if res.statusCode == 200
                {
                    guard let response = data else {
                        return block(false, nil, "No data")
                    }
                    
                    let decoder = JSONDecoder()
                    do {
//
//                        let tempObject = try JSONSerialization.jsonObject(with: response, options: []) as AnyObject
//                        debugPrint(tempObject)
                        
//                        let array = tempObject as! NSArray
//                        for a in 0..<array.count {
//                            let meter = array[a]
//                            debugPrint("\(a) \(meter)")
//                        }
//
                        let elements: [MeteorElement] = try decoder.decode([MeteorElement].self, from: response as Data)

                        //Filter by 1900
                        let newElements = elements.filter { element in
                            guard let year = element.year else {
                                return false
                            }
                            let extractYear = year.getYear()
                            return extractYear >= 1900
                        }
                        
                        
                        print(elements.count)
                        print(newElements.count)
                        
                        block(true, newElements, "success")
                    } catch {
                        block(false, nil, "Data not in expected")
                    }
                }
                else {
                    block(false, nil, error?.localizedDescription)
                }
            }else{
                block(false, nil, error?.localizedDescription)
            }
        }
        task.resume()
    }
}

extension String {
    func getYear() -> Int {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        let date = dateFormatter.date(from: self)
        print("date: \(String(describing: date))")
        
        if let dateValue = date {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year], from: dateValue)
            let year = components.year
            return year!
        }
        return 0
    }
}
