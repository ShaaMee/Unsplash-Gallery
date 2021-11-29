//
//  AlertService.swift
//  Unsplash Gallery
//
//  Created by user on 23.11.2021.
//

import UIKit

class AlertService {
    static let shared = AlertService()
    
    private init(){}
    
    func showAlertWith(messeage: String, inViewController vc: UIViewController){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Oooops =(", message: messeage, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(action)
            vc.present(alert, animated: true)
        }
    }
}
