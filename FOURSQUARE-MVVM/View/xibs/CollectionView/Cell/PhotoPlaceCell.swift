//
//  PhotoPlaceCell.swift
//  FOURSQUARE
//
//  Created by Van Ngoc Duc on 14/03/2022.
//

import UIKit
import SDWebImage

class PhotoPlaceCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        imageView.image = UIImage(named: "placeholder")
    }

    func updateCellViewModelWith(_ viewModel: String) {
        imageView.sd_setImage(with: URL(string: viewModel))
    }
}
