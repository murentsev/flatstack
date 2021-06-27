//
//  DetailCountryScreenVC.swift
//  flatstack
//
//  Created by Алексей Муренцев on 26.06.2021.
//

import UIKit
import RealmSwift

class DetailCountryScreenVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var countryImagesCollectionView: UICollectionView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var continentLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Private properties
    
    private lazy var realm = try! Realm()
    private var countryImagesResult: Results<CountryImage>!
    private var notificationToken: NotificationToken?
    private var countryImagesData: [CountryImage] = []
    
    // MARK: - Public properties
    
    public var countryFlagData: Data? = nil
    public var name: String = ""
    public var capital: String = ""
    public var population: String = ""
    public var continent: String = ""
    public var fullDescription: String = ""
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabels()
        countryImagesCollectionView.delegate = self
        countryImagesCollectionView.dataSource = self
        subscribeToNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }
    
    // MARK: - Private properties
    
    private func setLabels() {
        countryNameLabel.text = name
        capitalLabel.text = capital
        populationLabel.text = population
        continentLabel.text = continent
        descriptionLabel.text = fullDescription
    }
    
    private func subscribeToNotifications() {
        countryImagesResult = realm.objects(CountryImage.self).filter("countryName == '\(name)'")
        notificationToken = countryImagesResult.observe {[weak self] (changes) in
            switch changes {
            case .initial(let countryImagesResult):
                self?.countryImagesData = Array(countryImagesResult)
                self?.countryImagesCollectionView.reloadData()
            case .update(let countryImagesResult, _, _, _):
                self?.countryImagesData = Array(countryImagesResult)
                self?.countryImagesCollectionView.reloadData()
            case let .error(error):
                print(error)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension DetailCountryScreenVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemsCount = countryImagesData.isEmpty ? 1 : countryImagesData.count
        pageControl.numberOfPages = itemsCount
        return itemsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)
        guard let cell = collectionCell as? CountryImagesCollectionViewCell else { return collectionCell }
        if !countryImagesData.isEmpty {
            cell.configure(countryImage: countryImagesData[indexPath.row], flagData: countryFlagData)
        } else {
            cell.setFlagImage(flagData: countryFlagData)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension DetailCountryScreenVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0 , left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}
