//
//  FileData.swift
//  flatstack
//
//  Created by Алексей Муренцев on 20.06.2021.
//

import Foundation

struct FileData: Codable {
    let next: String
    let countries: [CountryStruct]
}

struct CountryStruct: Codable {
    let name: String
    let continent: String
    let capital: String
    let population: Int
    let description_small: String
    let description: String
    let image: String
    let country_info: CountryInfo
}

struct CountryInfo: Codable {
    let images: [String]
    let flag: String
}
