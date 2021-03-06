//
//  ViewController.swift
//  Unsplash Gallery
//
//  Created by user on 21.11.2021.
//

import UIKit

class DetailsViewController: UIViewController {
    
    private var mainView: DetailsView {
        guard let view = self.view as? DetailsView else {
            return DetailsView()
        }
        return view
    }
        
    var imageData: UnsplashImageData?
    private let dateFormatter = DateFormatter()
    
    var image = UIImage() {
        didSet{
            mainView.image = image
        }
    }

    private var persistanceKey: String? {
        imageData?.urls.small
    }
    
    private var isFavourite: Bool = false {
        didSet{
            mainView.favouriteView.image = isFavourite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        }
    }
    
    // MARK: - loadView()
  
    override func loadView() {
        view = DetailsView()
    }
    
    // MARK: - viewDidLoad()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        guard let imageData = imageData else { return }
        setupViews(imageData)
    }
    
    // MARK: - Setting up labels, button and DateFormatter

    private func setupViews(_ imageData: UnsplashImageData) {
                
        mainView.authorNameLabel.text = imageData.user.name
        mainView.dateCreatedLabel.text = "Created: \(dateFormatter.string(from: imageData.createdAt))"
        mainView.locationLabel.text = "Location: \(imageData.location.title ?? "N/A")"
        mainView.downloadsCountLabel.text = "Total downdloads: \(imageData.downloads.description)"

        mainView.favouriteButton.addTarget(self, action: #selector(toggleFavourite), for: .touchUpInside)
        dateFormatter.dateFormat = "dd.MM.yyyy"
    }
    
    // MARK: - viewWillAppear() (Changing state of heart icon)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let key = persistanceKey else { return }
        isFavourite = Persistance.shared.storesObjectForKey(key, ofType: UnsplashImageData.self)
    }
    
    // MARK: - Favourite button action

    @objc private func toggleFavourite(){
        isFavourite.toggle()
        
        guard let storedData = imageData,
              let key = persistanceKey else { return }
        
        switch isFavourite {
        case true: Persistance.shared.addObject(storedData, withKey: key)
        default: Persistance.shared.removeObjectWithKey(key, ofType: UnsplashImageData.self)
        }
    }
}

