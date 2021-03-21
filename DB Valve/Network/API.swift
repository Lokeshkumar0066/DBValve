////
////  API.swift
////  DB Valve
////
////  Created by Lokesh Kumar on 19/04/20.
////  Copyright © 2020 Lokesh Kumar. All rights reserved.
////
//
//import Foundation
//
//class API {
//    
//    static func getData(_ completion: @escaping (IPModel) -> Void) {
//
//        let wifiIp = getAddress(for: .wifi)
//        let cellular = getAddress(for: .cellular)
//        
//        let ip = wifiIp ?? cellular ?? ""
//        
//        let request = NSMutableURLRequest(url: NSURL(string: "https://api.ipgeolocationapi.com/geolocate/"+ip)! as URL,
//                                          cachePolicy: .useProtocolCachePolicy,
//                                          timeoutInterval: 10.0)
//        request.httpMethod = "GET"
//        
//        let session = URLSession.shared
//        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
//            if (error != nil) {
//                print(error as Any)
//            } else if let d = data {
//                
//                let decoder = JSONDecoder()
//                do {
//                    let res = try decoder.decode(IPModel.self, from: d)
//                    completion(res)
//                } catch let e {
//                    print(e)
//                }
//            }
//        })
//        
//        dataTask.resume()
//        
//    }
//}
//
//
//func getAddress(for network: Network) -> String? {
//    var address: String?
//    
//    // Get list of all interfaces on the local machine:
//    var ifaddr: UnsafeMutablePointer<ifaddrs>?
//    guard getifaddrs(&ifaddr) == 0 else { return nil }
//    guard let firstAddr = ifaddr else { return nil }
//    
//    // For each interface ...
//    for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
//        let interface = ifptr.pointee
//        
//        // Check for IPv4 or IPv6 interface:
//        let addrFamily = interface.ifa_addr.pointee.sa_family
//        if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
//            
//            // Check interface name:
//            let name = String(cString: interface.ifa_name)
//            if name == network.rawValue {
//                
//                // Convert interface address to a human readable string:
//                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
//                getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
//                            &hostname, socklen_t(hostname.count),
//                            nil, socklen_t(0), NI_NUMERICHOST)
//                address = String(cString: hostname)
//            }
//        }
//    }
//    freeifaddrs(ifaddr)
//    
//    return address
//}
//enum Network: String {
//    case wifi = "en0"
//    case cellular = "pdp_ip0"
//    //... case ipv4 = "ipv4"
//    //... case ipv6 = "ipv6"
//}
