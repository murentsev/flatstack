//
//  SelectCountryTableViewCell.swift
//  flatstack
//
//  Created by Алексей Муренцев on 20.06.2021.
//

import UIKit

class SelectCountryTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var flag: UIImageView!
    @IBOutlet weak var description_small: UILabel!
    
    // MARK: - Public methods
    
    public func configure(country: Country) {
        title.text = country.name
        description_small.text = country.smallDescription
        subtitle.text = country.capital
        if let flagData = country.flag {
            if let flagImage = UIImage(data: flagData) {
                flag.image = flagImage
            } else {
                flag.image = UIImage(named: "emptyFlagImage")
            }
        } else {
            flag.image = UIImage(named: "emptyFlagImage")
        }
        selectionStyle = .none
    }
}
