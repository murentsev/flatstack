//
//  Country.swift
//  flatstack
//
//  Created by Алексей Муренцев on 21.06.2021.
//

import UIKit
import RealmSwift

final class Country: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var continent: String = ""
    @objc dynamic var capital: String = ""
    @objc dynamic var population: Int = 0
    @objc dynamic var smallDescription: String = ""
    @objc dynamic var fullDescription: String = ""
    @objc dynamic var flag: Data? = nil
    
    convenience init(
        name: String,
        continent: String,
        capital: String,
        population: Int,
        smallDescription: String,
        fullDescription: String,
        flag: Data? = nil
    ) {
        self.init()
        self.name = name
        self.continent = continent
        self.capital = capital
        self.population = population
        self.smallDescription = smallDescription
        self.fullDescription = fullDescription
        self.flag = flag
    }
    
    override static func primaryKey() -> String? {
        return "name"
    }
}

final class CountryImage: Object {
    
    @objc dynamic var countryName: String = ""
    @objc dynamic var image: Data? = nil
    @objc dynamic var imageURL: String = ""
    
    convenience init(countryName: String,
         image: Data? = nil,
         imageURL: String
    ) {
        self.init()
        self.countryName = countryName
        self.image = image
        self.imageURL = imageURL
    }
    
    override static func primaryKey() -> String? {
        return "imageURL"
    }
}


