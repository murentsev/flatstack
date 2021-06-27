//
//  CountriesService.swift
//  flatstack
//
//  Created by Алексей Муренцев on 20.06.2021.
//
import Foundation
import RealmSwift

final class CountriesService {
    
    // MARK: - Public properties
    
    public let startingURL: String = "https://rawgit.com/NikitaAsabin/799e4502c9fc3e0ea7af439b2dfd88fa/raw/7f5c6c66358501f72fada21e04d75f64474a7888/page1.json"
    
    // MARK: - Public methods
    
    public func loadJson(fromURLString urlString: String,
                         completion: @escaping (String) -> Void) {
        if let url = URL(string: urlString) {
            let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let fileData = try decoder.decode(FileData.self, from: data)
                        for countryStruct in fileData.countries {
                            self.createCountry(countryStruct: countryStruct)
                            self.prepareCountryImages(countryStruct: countryStruct)
                        }
                        completion(fileData.next)
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }
            }
            urlSession.resume()
        }
    }
    
    // MARK: - Private methods
    
    private func createCountry(countryStruct: CountryStruct) {
        if let url = URL(string: countryStruct.country_info.flag) {
            getData(from: url, completion: { data, response, error in
                if let flagData = data, error == nil {
                    let country = Country(
                        name: countryStruct.name,
                        continent: countryStruct.continent,
                        capital: countryStruct.capital,
                        population: countryStruct.population,
                        smallDescription: countryStruct.description_small,
                        fullDescription: countryStruct.description,
                        flag: flagData
                    )
                    self.saveCountry(country: country)
                }  else {
                    let country = Country(
                        name: countryStruct.name,
                        continent: countryStruct.continent,
                        capital: countryStruct.capital,
                        population: countryStruct.population,
                        smallDescription: countryStruct.description_small,
                        fullDescription: countryStruct.description
                    )
                    self.saveCountry(country: country)
                }
            })
        }
    }
    
    private func saveCountry(country: Country) {
        do {
            let realm = try Realm()
            try realm.write {
                if let oldCountry = realm.object(ofType: Country.self, forPrimaryKey: country.name) {
                    realm.delete(oldCountry)
                }
                realm.add(country, update: .modified)
            }
        } catch {
            print(error)
        }
    }
    
    private func prepareCountryImages(countryStruct: CountryStruct) {
        tryCreateCountryImage(urlString: countryStruct.image, countryName: countryStruct.name)
        for imageUrlString in countryStruct.country_info.images {
            tryCreateCountryImage(urlString: imageUrlString, countryName: countryStruct.name)
        }
    }
    
    private func tryCreateCountryImage(urlString: String, countryName: String) {
        if let url = URL(string: urlString) {
            getData(from: url, completion: { data, response, error in
                guard let imageData = data, error == nil else { return }
                let countryImage = CountryImage(countryName: countryName, image: imageData, imageURL: urlString)
                self.saveCountryImage(countryImage: countryImage)
            })
        }
    }
    
    private func saveCountryImage(countryImage: CountryImage) {
        do {
            let realm = try Realm()
            try realm.write {
                if let oldImage = realm.object(ofType: CountryImage.self, forPrimaryKey: countryImage.imageURL) {
                    realm.delete(oldImage)
                }
                realm.add(countryImage, update: .modified)
            }
        } catch {
            print(error)
        }
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}

