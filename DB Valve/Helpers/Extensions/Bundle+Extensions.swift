//
//  Bundle+Extensions.swift
//  ProFive
//
//  Created by Lokesh Kumar on 16/08/17.
//  Copyright © 2017 Lokesh Kumar. All rights reserved.
//

import Foundation

extension Bundle {
    
    static var versionNumber: String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }

    static var buildNumber: String? {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }
}



extension URL {
    public var queryItems: [String: String] {
        var params = [String: String]()
        return URLComponents(url: self, resolvingAgainstBaseURL: false)?
            .queryItems?
            .reduce([:], { (_, item) -> [String: String] in
                params[item.name] = item.value
                return params
            }) ?? queryDict ?? [:]
    }
    
    private var queryDict: [String: String]? {
       return self.host?.components(separatedBy: "&")
            .map({ $0.components(separatedBy: "=") })
            .reduce(into: [String: String](), { (dict, pair) in
                if pair.count == 2 {
                    dict[pair[0]] = pair[1]
                }
            })
    }
}

