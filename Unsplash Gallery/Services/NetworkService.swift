//
//  NetworkService.swift
//  Unsplash Gallery
//
//  Created by user on 21.11.2021.
//

import Foundation
import Alamofire

class NetworkService {
    
    static let shared = NetworkService()
    
    private let clientID = "Client-ID V3zkhd96J-spd6EtpmlyaMwM7ONhGPsDYZqgwWTAkkM"
    private let imagesCount = 30
    
    func fetchDataFromURL(_ url: URL, searchText: String? = nil, completion: @escaping ((Data) -> ())) {
        
        var parameters: Parameters
        
        if let searchText = searchText {
            parameters = ["query":searchText]
        } else {
            parameters = ["count":imagesCount]
        }
                
        AF.request(url,
                   parameters: parameters,
                   headers: [HTTPHeader(name: "Authorization", value: clientID)])
            .validate()
            .responseData(completionHandler: { response in
                guard let data = response.data else {
                    print("No Data")
                    return
                }
                completion(data)
            })
    }
}
