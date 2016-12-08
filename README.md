# USSegFault
This Project is examining when segmentation fault by URLSession on Linux.
This problem no happen on macOS and iOS.

I found it when I was writing [this library](https://github.com/iq3addLi/WebStruct)

# Environment at problem discovery

| key        | value          |
| --------------- |:---------------:|
| OS | Ubuntu 16.04 |
| Swift | 3.0.1 |
| Build | Debug and Release |

# What of problem?
If an error is contained in the completionHandler of URLSessionDataTask, passing it to the local variable across block will destroy the contents of Optional and generate a segmentation fault when accessing.

```swift
let session = URLSession(configuration: URLSessionConfiguration.default, delegate:nil, delegateQueue: nil)
let semaphore = DispatchSemaphore(value: 0) // Force synchronize
    
var data:Data?,response:URLResponse?,error:Swift.Error?
let subtask = session.dataTask(with: request) { (d, r, e) in
    data = d; response = r; error = e;
    semaphore.signal()
}
subtask.resume()
let _ = semaphore.wait(timeout: DispatchTime.distantFuture)
```

```swift
if let error = error {
    print("\(error)") // Segmentetion fault on Linux
}else{
    print("Test failed.")
}
```

## Execute log on EC2
```bash
ubuntu@ip-*:~/USSegFault$ swift build
ubuntu@ip-*:~/USSegFault$ .build/debug/USSegFault
Segmentation fault (core dumped)
ubuntu@ip-*:~/USSegFault$ swift build -c release
Compile Swift Module 'USSegFault' (1 sources)
Linking ./.build/release/USSegFault
ubuntu@ip-*:~/USSegFault$ .build/release/USSegFault
Segmentation fault (core dumped)
```

# Resolution

* I want URLSession to have synchronization processing.
* Since problems do not occur in iOS and macOS, please correct it in the same way.


Thanks! 
