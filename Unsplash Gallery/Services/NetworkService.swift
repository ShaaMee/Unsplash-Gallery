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
    
    func fetchDataFromURL(_ url: URL, completion: @escaping ((Data) -> ())) {
        AF.request(url,
                   parameters: ["count":30],
                   headers: [HTTPHeader(name: "Authorization", value: "Client-ID V3zkhd96J-spd6EtpmlyaMwM7ONhGPsDYZqgwWTAkkM")])
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
