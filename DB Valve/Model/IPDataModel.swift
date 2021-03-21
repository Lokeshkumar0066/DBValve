//
//  IPData.swift
//  DB Valve
//
//  Created by Lokesh Kumar on 19/04/20.
//  Copyright © 2020 Lokesh Kumar. All rights reserved.
// 
import Foundation

struct IPModel: Codable {
    let continent, addressFormat, alpha2, alpha3: String
    let countryCode, internationalPrefix, ioc, gec: String
    let name: String
    let nationalPrefix, number, region, subregion: String
    let nationality: String
    let currencyCode: String
    
    enum CodingKeys: String, CodingKey {
        case continent
        case addressFormat = "address_format"
        case alpha2, alpha3
        case countryCode = "country_code"
        case internationalPrefix = "international_prefix"
        case ioc, gec, name
        case nationalPrefix = "national_prefix"
        case number, region, subregion
        case nationality
        case currencyCode = "currency_code"
    }
}
