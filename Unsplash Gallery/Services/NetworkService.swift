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
    private init(){}

    private let clientID = "Client-ID V3zkhd96J-spd6EtpmlyaMwM7ONhGPsDYZqgwWTAkkM"
    private let imagesCount = 10
    
    
    func fetchDataFromURL(_ url: URL, searchText: String? = nil, completion: @escaping ((Data, String?) -> ())) {
        
        var parameters: Parameters
       
        // Different request parameters for random photos and search result
        if let searchText = searchText {
            parameters = ["query":searchText,"per_page":imagesCount]
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
                
                // Checking if request limit is exceeded.
                guard let errorText = String(data: data, encoding: .ascii),
                      errorText == "Rate Limit Exceeded" else {
                    completion(data, nil)
                    return
                }
                completion(data, errorText)
            })
    }
}
