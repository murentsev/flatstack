//
//  CountryImagesCollectionViewCell.swift
//  flatstack
//
//  Created by Алексей Муренцев on 27.06.2021.
//

import UIKit

class CountryImagesCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Public methods
    
    public func configure(countryImage: CountryImage, flagData: Data?) {
        if let imageData = countryImage.image {
            if let image = UIImage(data: imageData) {
                imageView.image = image
            } else {
                imageView.image = UIImage(named: "emptyFlagImage")
            }
        } else {
            setFlagImage(flagData: flagData)
        }
        
    }
    
    public func setFlagImage(flagData: Data?) {
        if let data = flagData {
            if let flagImage = UIImage(data: data) {
                imageView.image = flagImage
            } else {
                imageView.image = UIImage(named: "emptyFlagImage")
            }
        } else {
            imageView.image = UIImage(named: "emptyFlagImage")
        }
    }
}
