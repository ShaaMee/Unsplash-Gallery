//
//  ViewController.swift
//  Unsplash Gallery
//
//  Created by user on 21.11.2021.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var imageData: UnsplashImageData?
    var image: UIImage? {
        didSet{
            guard let image = image else { return }
            photoView.image = image
        }
    }
    
    private var isFavourite: Bool?
    
    private var photoView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var favouriteView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(systemName: "heart")
        view.clipsToBounds = true
        view.tintColor = .red
        return view
    }()
    
    private var authorNameLabel = UILabel()
    private var dateCreatedLabel = UILabel()
    private var locationLabel = UILabel()
    private var downloadsCountLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let imageData = imageData else { return }
        
        setupViews(imageData)
        setupConstraints()
    }
    
    
    fileprivate func setupViews(_ imageData: UnsplashImageData) {
        
        view.backgroundColor = .white
        
        for view in [authorNameLabel, dateCreatedLabel, locationLabel, downloadsCountLabel] {
            view.translatesAutoresizingMaskIntoConstraints = false
            view.numberOfLines = 0
            view.font = UIFont.preferredFont(forTextStyle: .body)
            self.view.addSubview(view)
        }
        
        view.addSubview(photoView)
        view.addSubview(favouriteView)
        
        authorNameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        authorNameLabel.textAlignment = .center
        
        authorNameLabel.text = imageData.user.name
        dateCreatedLabel.text = "Created: \(imageData.createdAt.description)"
        locationLabel.text = "Location: \(imageData.location.title ?? "N/A")"
        downloadsCountLabel.text = "Total downdloads: \(imageData.downloads.description)"
    }
    
    
    fileprivate func setupConstraints() {
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            photoView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            photoView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            photoView.heightAnchor.constraint(equalTo: photoView.widthAnchor),
            
            authorNameLabel.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 16),
            authorNameLabel.leadingAnchor.constraint(equalTo: photoView.leadingAnchor),
            authorNameLabel.trailingAnchor.constraint(equalTo: photoView.trailingAnchor),
            
            dateCreatedLabel.topAnchor.constraint(equalTo: authorNameLabel.bottomAnchor, constant: 16),
            dateCreatedLabel.leadingAnchor.constraint(equalTo: photoView.leadingAnchor),
            dateCreatedLabel.trailingAnchor.constraint(equalTo: photoView.trailingAnchor),
            
            locationLabel.topAnchor.constraint(equalTo: dateCreatedLabel.bottomAnchor, constant: 16),
            locationLabel.leadingAnchor.constraint(equalTo: photoView.leadingAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: photoView.trailingAnchor),
            
            downloadsCountLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 16),
            downloadsCountLabel.leadingAnchor.constraint(equalTo: photoView.leadingAnchor),
            downloadsCountLabel.trailingAnchor.constraint(equalTo: photoView.trailingAnchor),
            
            favouriteView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            favouriteView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            favouriteView.heightAnchor.constraint(equalToConstant: 50),
            favouriteView.widthAnchor.constraint(equalTo: favouriteView.heightAnchor)
        ])
    }
    
}

