//
//  DetailsView.swift
//  Unsplash Gallery
//
//  Created by user on 29.11.2021.
//

import UIKit

class DetailsView: UIView {
    
    var authorNameLabel = UILabel()
    var dateCreatedLabel = UILabel()
    var locationLabel = UILabel()
    var downloadsCountLabel = UILabel()
    var photoView = UIImageView()
    var favouriteButton = UIButton()
    var favouriteView = UIImageView()

    var image: UIImage? {
        didSet{
            guard let image = image else { return }
            photoView.image = image
        }
    }
    
    init() {
        super.init(frame: .zero)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        setUpView()
        setUpLabels()
        setUpPhotoView()
        setUpFavouriteButton()
        setUpFavouriteView()
        setUpAuthorNameLabel()
        setUpConstraints()
    }
    
    private func setUpView(){
        backgroundColor = .systemBackground
    }
    
    private func setUpLabels(){
        for view in [authorNameLabel, dateCreatedLabel, locationLabel, downloadsCountLabel] {
            view.translatesAutoresizingMaskIntoConstraints = false
            view.numberOfLines = 0
            view.font = UIFont.preferredFont(forTextStyle: .body)
            addSubview(view)
        }
    }
    
    private func setUpPhotoView(){
        photoView.translatesAutoresizingMaskIntoConstraints = false
        photoView.contentMode = .scaleAspectFit
        addSubview(photoView)
    }
    
    private func setUpFavouriteButton(){
        favouriteButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(favouriteButton)
    }
    
    private func setUpFavouriteView(){
        favouriteView.translatesAutoresizingMaskIntoConstraints = false
        favouriteView.contentMode = .scaleAspectFit
        favouriteView.image = UIImage(systemName: "heart")
        favouriteView.clipsToBounds = true
        favouriteView.tintColor = .red
        favouriteButton.addSubview(favouriteView)
    }
    
    private func setUpAuthorNameLabel() {
        authorNameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        authorNameLabel.textAlignment = .center
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            photoView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8),
            photoView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8),
            photoView.heightAnchor.constraint(lessThanOrEqualTo: photoView.widthAnchor),
            
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
            
            favouriteButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -15),
            favouriteButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -15),
            favouriteButton.heightAnchor.constraint(equalToConstant: 40),
            favouriteButton.widthAnchor.constraint(equalTo: favouriteButton.heightAnchor),
            
            favouriteView.centerXAnchor.constraint(equalTo: favouriteButton.centerXAnchor),
            favouriteView.centerYAnchor.constraint(equalTo: favouriteButton.centerYAnchor),
            favouriteView.widthAnchor.constraint(equalTo: favouriteButton.widthAnchor),
            favouriteView.heightAnchor.constraint(equalTo: favouriteButton.heightAnchor)
        ])
    }
}
