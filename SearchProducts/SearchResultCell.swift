//
//  SearchResultCell.swift
//  SearchProducts
//
//  Created by Cristobal Nuñez on 19/4/23.
//

import UIKit
import Kingfisher

class SearchResultCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    var searchResultViewModel: SearchResultViewModel! {
        didSet {
            productTitleLabel.text = searchResultViewModel.name
            productPriceLabel.text = "$ " + searchResultViewModel.price.description
            // Retrieve and cache image using KingFisher library
            productImageView.kf.setImage(with: URL(string: searchResultViewModel.image))
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.productImageView.image = nil
        self.productTitleLabel.text = ""
        self.productPriceLabel.text = ""
    }
}
