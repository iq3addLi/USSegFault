import Foundation
import Dispatch


guard let url = URL(string: "https://hogehoge.api.github.com/" ) // Network Error : Would you like to connect to the server anyway?
    else{ fatalError() }

//guard let body = try? JSONSerialization.data(withJSONObject: [ "test" : "test" ], options: JSONSerialization.WritingOptions())
//    else{ fatalError() }
    
var request = URLRequest(url:url, cachePolicy:.reloadIgnoringLocalCacheData, timeoutInterval:1)
//request.httpMethod = "POST"
//request.addValue("application/json", forHTTPHeaderField:"Content-Type")
//request.httpBody = body

let session = URLSession(configuration: URLSessionConfiguration.default, delegate:nil, delegateQueue: nil)
let semaphore = DispatchSemaphore(value: 0) // Force synchronize
    
var data:Data?,response:URLResponse?,error:Swift.Error?
let subtask = session.dataTask(with: request) { (d, r, e) in
    data = d; response = r; error = e;
    semaphore.signal()
}
subtask.resume()
let _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    
if let error = error {
    print("\(error)") // Segmentetion fault on Linux
    print("This problem is solved!😄")
}else{
    print("Test failed.")
}
