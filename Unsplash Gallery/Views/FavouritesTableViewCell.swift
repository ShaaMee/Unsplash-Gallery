//
//  FavouritesTableViewCell.swift
//  Unsplash Gallery
//
//  Created by user on 22.11.2021.
//

import UIKit

class FavouritesTableViewCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
    }

}
