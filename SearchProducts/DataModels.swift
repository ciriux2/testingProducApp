//
//  DataModels.swift
//  SearchProducts
//
//  Created by Cristobal Nuñez on 19/4/23.
//

import Foundation


// MARK: Structs representing data to be decoded from response

// Root as highest level
struct Root: Codable {
    enum CodingKeys: String, CodingKey {
        case item
    }
    let item: Item
}

// Collection field that contains an array of 'SearchItems'
struct Item: Codable {
    enum CodingKeys: String, CodingKey {
        case props
    }
    let props: Props
}

struct Props: Codable {
    enum CodingKeys: String, CodingKey {
        case pageProps
    }
    let pageProps: PageProps
}

//struct PageProps: Codable {
//    enum CodingKeys: String, CodingKey {
//        case nonce
//    }
//    let nonce: String
//}

struct PageProps: Codable {
    enum CodingKeys: String, CodingKey {
        case initialData
    }
    let initialData: InitialData
}

struct InitialData: Codable {
    enum CodingKeys: String, CodingKey {
        case searchResult
    }
    let searchResult: SearchResult
}

struct SearchResult: Codable {
    enum CodingKeys: String, CodingKey {
        case itemStacks
    }
    let itemStacks:[ItemStacks]
}


struct ItemStacks: Codable {
    enum CodingKeys: String, CodingKey {
        case items
    }
    let items: [SearchInfo]
}

struct SearchInfo: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case price
        case image
    }
    let name: String?
    let price: Int?
    let image: String?
}
//
////// MARK: Data Model for Search results
public struct SearchResultViewModel {
    let image: String
    let name: String
    let price: Int

    init(href: String, title: String, price: Int) {
        self.image = href
        self.name = title
        self.price = price
    }
}
