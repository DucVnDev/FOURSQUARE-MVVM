//
//  PlaceTableViewCell.swift
//  FOURSQUARE
//
//  Created by Van Ngoc Duc on 02/03/2022.
//

import UIKit
import Alamofire
import SDWebImage

class PlaceTableViewCell: UITableViewCell {

    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!

    var networkingApi = NetworkingAPI()

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        placeImageView.image = UIImage(named: "placeholder")
        titleLabel.text = ""
        subTitleLabel.text = ""
        distanceLabel.text = ""
        descLabel.text = ""
    }

    func commonInit() {
        placeImageView.image = UIImage(named: "placeholder")
        placeImageView.layer.cornerRadius = 8
    }

    //ListVM
    func updateCellViewModelWith(_ viewModel: PlaceTableViewCellViewModel, at indexPath: IndexPath) {
        titleLabel.text = "\(indexPath.row + 1). \(viewModel.title)"
        subTitleLabel.text = viewModel.subtitle
        distanceLabel.text = "\(viewModel.distance)m  \(viewModel.locality)"
        descLabel.text = ""

        if let imgURL = viewModel.imgURL {
            placeImageView.sd_setImage(with: URL(string: imgURL))
        }

        fetchPhotoID(fsqID: viewModel.fsqID)
    }

    private func fetchPhotoID(fsqID: String) {
        networkingApi.fetchPhotoWith(fsqID: fsqID) { [weak self] data in
            if let prefix = data.first?.placePhotoPrefix, let suffix = data.first?.suffix {
                let imgURLString = "\(prefix)120x120\(suffix)"
                self?.placeImageView.sd_setImage(with: URL(string: imgURLString))
            }
        }
    }
}
