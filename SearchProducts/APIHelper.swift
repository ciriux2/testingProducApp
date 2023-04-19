//
//  APIHelper.swift
//  SearchProducts
//
//  Created by Cristobal Nuñez on 19/4/23.
//

import Foundation
import UIKit

class APIHelper {
    
    enum Constant {
        static let productSearchEndpoint = "https://00672285.us-south.apigw.appdomain.cloud/demo-gapsi/search?"
    }
    
    public init() {}
    public func getProductSearchResults(search: String, pageNumber: Int, mediaType: String, pageLimit: Int?,
                           completion: @escaping (_ success: Bool, _ data: Data?) -> Void) {
        
        let endpoint = Constant.productSearchEndpoint + "query=\(search)&page=\(pageNumber)"
        
        let url = URL(string: endpoint)
        
        
        guard let url = url else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("adb8204d-d574-4394-8c1a-53226a40876e", forHTTPHeaderField: "X-IBM-Client-Id")
        
        // Calls endpoint
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                completion(true, data)
            }
            else {
                completion(false, nil)
            }
        }
        task.resume()
    }
    
    // Transforms data into array of SearchResult
    public func handleData(data: Data) -> [SearchResultViewModel] {
        let decoder = JSONDecoder()
        do {
            let root = try decoder.decode(Root.self, from: data)
            let results = root.item.props.pageProps.initialData.searchResult.itemStacks[0].items.map {
                return SearchResultViewModel(href: $0.image ?? "", title: $0.name ?? "Sin titulo", price: $0.price ?? 0)
            }
            return results
        }
        catch let error {
            print(error)
            return []
        }
    }
    
}

