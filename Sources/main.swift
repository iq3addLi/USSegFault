import Foundation

//#if os(Linux)
    
guard let url = URL(string: "http://0.0.0.0" ) // Network Error
    else{ fatalError() }
    
guard let body = try? JSONSerialization.data(withJSONObject: [ "test" : "test" ], options: JSONSerialization.WritingOptions())
    else{ fatalError() }
    
var request = URLRequest(url:url, cachePolicy:.reloadIgnoringLocalCacheData, timeoutInterval:1)
request.httpMethod = "POST"
request.addValue("application/json", forHTTPHeaderField:"Content-Type")
request.httpBody = body
    
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
}else{
    print("Test failed.")
}
