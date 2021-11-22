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
        return array.sorted { $0.user.name < $1.user.name }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(FavouritesTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
                
        view.backgroundColor = .white

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favouritesDictionary.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FavouritesTableViewCell
        
        cell.textLabel?.text = favouritesArray[indexPath.row].user.name
        
        guard let url = URL(string: favouritesArray[indexPath.row].urls.small) else { return cell }
        
        cell.tag = indexPath.row
        
        NetworkService.shared.fetchDataFromURL(url) { imageData in
            
            guard let image = UIImage(data: imageData) else { return }
            
            if cell.tag == indexPath.row {
                DispatchQueue.main.async {
                    cell.imageView?.image = image
                    cell.layoutSubviews()
                    //cell.activityIndicator.stopAnimating()
                    //cell.isUserInteractionEnabled = true
                }
            }
        }
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let detailsVC = DetailsViewController()
        detailsVC.imageData = favouritesArray[indexPath.row]
        detailsVC.image = cell.imageView?.image
        navigationController?.pushViewController(detailsVC, animated: true)    }

}
