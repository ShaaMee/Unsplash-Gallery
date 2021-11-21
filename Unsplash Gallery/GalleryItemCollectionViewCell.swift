//
//  GalleryItemCollectionViewCell.swift
//  Unsplash Gallery
//
//  Created by user on 21.11.2021.
//

import UIKit

class GalleryItemCollectionViewCell: UICollectionViewCell {
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.style = UIActivityIndicatorView.Style.large
        return indicator
    }()
    
    private var imageView = UIImageView(frame: .zero) {
        didSet {
            layoutSubviews()
        }
    }
    
    var image: UIImage? {
        didSet {
            guard let image = image else { return }
            imageView = UIImageView(image: image)
        }
    }
    
    var dataTask: URLSessionTask?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        contentView.addSubview(activityIndicator)
        clipsToBounds = true
        
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        dataTask?.cancel()
    }
    
}
