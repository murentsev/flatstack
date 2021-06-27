//
//  SelectCountryTableVC.swift
//  flatstack
//
//  Created by Алексей Муренцев on 19.06.2021.
//

import UIKit
import RealmSwift

class SelectCountryTableVC: UITableViewController {
    
    // MARK: - Private properties
    
    private lazy var service = CountriesService()
    private lazy var realm = try! Realm()
    private var countriesResult: Results<Country>!
    private var countries: [Country] = []
    private var notificationToken: NotificationToken?
    private var nextPageUrlString: String?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToNotifications()
        LoadFromNetwork()
    }
    
    // MARK: - Actions
    
    @IBAction func refreshBarButtonAction(_ sender: Any) {
        LoadFromNetwork()
    }
    
    // MARK: - Private methods
    
    private func subscribeToNotifications() {
        countriesResult = realm.objects(Country.self)
        notificationToken = countriesResult.observe {[weak self] (changes) in
            switch changes {
            case .initial(let countriesResult):
                self?.countries = Array(countriesResult).sorted {
                    $0.name < $1.name
                }
                self?.tableView.reloadData()
            case .update(let countriesResult, _, _, _):
                self?.countries = Array(countriesResult).sorted {
                    $0.name < $1.name
                }
                self?.tableView.reloadData()
            case let .error(error):
                print(error)
            }
        }
    }
    
    private func LoadFromNetwork() {
        service.loadJson(fromURLString: service.startingURL) { nextPageUrlString in
            self.nextPageUrlString = nextPageUrlString
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectCountryCell", for: indexPath)
        guard let selectCountryCell = cell as? SelectCountryTableViewCell else { return cell }
        selectCountryCell.configure(country: countries[indexPath.row])
        if indexPath.row == countries.count - 1 {
            guard let stringUrl = nextPageUrlString else { return selectCountryCell }
            service.loadJson(fromURLString: stringUrl) { nextPageUrlString in
                self.nextPageUrlString = nextPageUrlString.isEmpty ? nil : nextPageUrlString
            }
        }
        return selectCountryCell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? DetailCountryScreenVC {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let country = countries[indexPath.row]
            controller.name = country.name
            controller.capital = country.capital
            controller.population = String(country.population)
            controller.continent = country.continent
            controller.fullDescription = country.fullDescription
            controller.countryFlagData = country.flag
        }
    }
    
}
