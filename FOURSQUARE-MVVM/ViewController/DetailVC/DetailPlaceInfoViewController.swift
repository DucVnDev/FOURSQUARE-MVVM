//
//  DetailPlaceInfoViewController.swift
//  FOURSQUARE
//
//  Created by Van Ngoc Duc on 02/03/2022.
//

import UIKit

class DetailPlaceInfoViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    var favouriteButton = UIBarButtonItem()

    var viewModel = DetailPlaceViewMode()

    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup UI
        setupUI()

        //BindViewModel
        bindViewModel()

        //Fetch Photo Place
        fetchPhoto()
        
        //Fetach Tip Place
        fetchTip()
    }

    //MARK: - Private Methods
    //Setup UI
    private func setupUI(){
        navigationItem.title = "Detail Place"

        //NagivationBar Configure
        let icon = viewModel.checkDb()
        
        favouriteButton = UIBarButtonItem(image: UIImage.init(systemName: icon), style: .plain, target: self, action: #selector(favouriteAction))
        navigationItem.rightBarButtonItem = favouriteButton

        //Collectionview
        collectionView.delegate = self
        collectionView.dataSource = self

        //register Cell
        collectionView.register(UINib(nibName: "InfoPlaceCell", bundle: .main), forCellWithReuseIdentifier: "InfoPlaceCell")
        collectionView.register(UINib(nibName: "PhotoPlaceCell", bundle: .main), forCellWithReuseIdentifier: "PhotoPlaceCell")
        collectionView.register(UINib(nibName: "TipPlaceCell", bundle: .main), forCellWithReuseIdentifier: "TipPlaceCell")

        //register Header
        collectionView.register(UINib(nibName: "PlaceDetailCollectionReusableView", bundle: .main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PlaceDetailCollectionReusableView")
        collectionView.register(UINib(nibName: "HeaderSectionPlaceDetailCell", bundle: .main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderSectionPlaceDetailCell")
    }

    private func bindViewModel() {
        viewModel.reloadCollectionView = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }

    private func fetchPhoto() {
        bindViewModel()
        viewModel.fetchPhotoPlace(viewModel.fetchDetailCellVM().id)
    }

    private func fetchTip(){
        bindViewModel()
        viewModel.fetchTipPlace(viewModel.fetchDetailCellVM().id)
    }

    @objc func favouriteAction() {
        let icon = viewModel.favouriteAction()
        favouriteButton.image = UIImage.init(systemName: icon)
    }


}

//MARK: -DetailPlaceInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource
extension DetailPlaceInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
            case 0:
                return .zero
            case 1:
                return 1 //InfoPlaceCell
            case 2:
                //return urlPhotosPlaceString.count //PhotoPlaceCell
                return viewModel.countPhotosPlace()
            case 3:
                //return tipDetailPlace.count //TipPlaceCell
                return viewModel.countTipsPlace()
            default:
                fatalError("Error numberOfItemsInSection")
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
            case 0:
                return UICollectionViewCell()
            case 1:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoPlaceCell", for: indexPath) as! InfoPlaceCell
                cell.delegate = self
                let cellVM = viewModel.fetchDetailCellVM()
                let viewModel = InfoPlaceCellViewModel(name: cellVM.name, address: cellVM.address, category: cellVM.category, latitude: cellVM.latidute, longitude: cellVM.longitude)
                cell.viewModel = viewModel
                return cell
            case 2:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoPlaceCell", for: indexPath) as! PhotoPlaceCell
                let cellVM = viewModel.getPhotoCellViewModel(at: indexPath)
                cell.updateCellViewModelWith(cellVM)
                return cell
            case 3:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TipPlaceCell", for: indexPath) as! TipPlaceCell
                let cellVM = viewModel.getTipCellViewModel(at: indexPath)
                cell.updateCellViewModelWith(cellVM)
                return cell
            default:
                fatalError("Error Section CollectView")
        }
    }
}

//MARK: -CoursePageViewController: UICollectionViewDelegateFlowLayout
extension DetailPlaceInfoViewController: UICollectionViewDelegateFlowLayout {
    //HEADER
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
            case 0:
                return CGSize(width: collectionView.frame.width, height: 277)
            default:
                return CGSize(width: collectionView.frame.width, height: 36)
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch indexPath.section {
            case 0:
                switch kind {
                    case UICollectionView.elementKindSectionHeader:
                        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PlaceDetailCollectionReusableView", for: indexPath) as! PlaceDetailCollectionReusableView
                        let cellVM = viewModel.fetchDetailCellVM()
                        headerView.updateCellViewModelWith(cellVM)
                        return headerView
                    default:
                        fatalError("Unexpected element kind")
                }
            case 1:
                switch kind {
                    case UICollectionView.elementKindSectionHeader:
                        let headerSetionView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderSectionPlaceDetailCell", for: indexPath) as! HeaderSectionPlaceDetailCell
                        headerSetionView.titleLabel.text = "Infomation"
                        return headerSetionView
                    default:
                        fatalError("Unexpected element kind")
                }
            case 2:
                switch kind {
                    case UICollectionView.elementKindSectionHeader:
                        let headerSetionView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderSectionPlaceDetailCell", for: indexPath) as! HeaderSectionPlaceDetailCell
                        headerSetionView.titleLabel.text = "Photos Place"
                        return headerSetionView
                    default:
                        fatalError("Unexpected element kind")
                }
            case 3:
                switch kind {
                    case UICollectionView.elementKindSectionHeader:
                        let headerSetionView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderSectionPlaceDetailCell", for: indexPath) as! HeaderSectionPlaceDetailCell
                        headerSetionView.titleLabel.text = "Tips Place"
                        return headerSetionView
                    default:
                        fatalError("Unexpected element kind")
                }
            default:
                fatalError("Unexpected section")
        }
    }
    //CELL
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
            case 0:
                return UIEdgeInsets(top: 0, left: 0 , bottom: 0, right: 0)
            case 1:
                return UIEdgeInsets(top: 0, left: 20 , bottom: 20, right: 20)
            case 2:
                return UIEdgeInsets(top: 10, left: 20 , bottom: 20, right: 20)
            case 3:
                return UIEdgeInsets(top: 10, left: 20 , bottom: 20, right: 20)
            default:
                return UIEdgeInsets(top: 10, left: 0 , bottom: 10, right: 0)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
            case 0:
                return CGSize(width: 0, height: 0)
            case 1:
                let screenWidth = UIScreen.main.bounds.width - 20 - 20
                return CGSize(width: screenWidth, height: screenWidth*0.5)
            case 2:
                let screenWidth = UIScreen.main.bounds.width - 20 - 20 - 10
                return CGSize(width: screenWidth/2, height: screenWidth/2)
            case 3:
                let screenWidth = UIScreen.main.bounds.width - 20 - 20
                return CGSize(width: screenWidth, height: screenWidth*0.26)
            default:
                return CGSize(width: 0, height: 0)
        }
    }
}

//MARK: -DetailPlaceInfoViewController: InfoPlaceCellDelegate
extension DetailPlaceInfoViewController: InfoPlaceCellDelegate {
    func InfoPlaceCellNavigateToMapVC(_ cell: InfoPlaceCell, viewModel: InfoPlaceCellViewModel?) {
        guard let lat = viewModel?.latitude,
              let long = viewModel?.longitude,
              let titlePin = viewModel?.name
        else {
            return
        }
        let mapVC = MapingViewController()
        mapVC.latitude = lat
        mapVC.longitude = long
        mapVC.titlePin = titlePin
        navigationController?.pushViewController(mapVC, animated: true)
    }
}
