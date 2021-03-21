//
//  DataModel.swift
//  DB Valve
//
//  Created by Lokesh Kumar on 02/03/20.
//  Copyright © 2020 Lokesh Kumar. All rights reserved.
//

import Foundation

struct DataModel: Codable {
    let name, images: String
    let child: [DataModel]?
    let url: String?
}

extension DataModel {
    
    static func getDatSet() -> [DataModel]? {
        if let url = Bundle.main.url(forResource: "DataSet", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let model = try JSONDecoder().decode([DataModel].self, from: data)
                return model
            } catch {
                print(error)
            }
        }
        return nil
    }
}
