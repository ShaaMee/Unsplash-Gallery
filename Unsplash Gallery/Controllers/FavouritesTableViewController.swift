//
//  FavouritesTableViewController.swift
//  Unsplash Gallery
//
//  Created by user on 21.11.2021.
//

import UIKit

class FavouritesTableViewController: UITableViewController {
    
    private let reuseIdentifier = "favouritesCell"
    
    private var favouritesDictionary: [String:UnsplashImageData] {
        Persistance.shared.getAllObjects()
    }
    
    private var favouritesArray: [UnsplashImageData] {
        var array = [UnsplashImageData]()
        favouritesDictionary.forEach { (_, value) in
            array.append(value)
        }
        return array.sorted { ($0.user.name.lowercased(), $0.id) < ($1.user.name.lowercased(), $1.id) }
    }

    // MARK: - viewDidLoad()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(FavouritesTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    // MARK: - viewWillAppear()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .systemBackground
        tableView.reloadData()
    }
}

// MARK: - Table view data source

extension FavouritesTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouritesDictionary.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? FavouritesTableViewCell else {
            return UITableViewCell()
        }
        
        cell.artistName = favouritesArray[indexPath.row].user.name
        
        cell.tag = indexPath.row
        
        ImageService.shared.image(forURLString: favouritesArray[indexPath.row].urls.small) { (image, _) in
            
            guard let image = image else { return }
            
            if cell.tag == indexPath.row {
                DispatchQueue.main.async {
                    cell.picture = image
                    cell.layoutSubviews()
                }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: - Table view delegate

extension FavouritesTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? FavouritesTableViewCell else { return }
        let detailsVC = DetailsViewController()
        detailsVC.imageData = favouritesArray[indexPath.row]
        detailsVC.image = cell.picture
        navigationController?.pushViewController(detailsVC, animated: true)
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete {
            
            let key = favouritesArray[indexPath.row].urls.small
            
            guard favouritesDictionary.keys.contains(key) else { return }
            
            Persistance.shared.removeObjectWithKey(key, ofType: UnsplashImageData.self)
            
            tableView.reloadData()
        }
    }
}
