//
//  ImageViewController.swift
//  ImageSearch
//
//  Created by Костина Вероника  on 06.01.2021.
//

import UIKit

class ImageViewController: UIViewController {
    
    let spacing: CGFloat = 5
    private let numberOfItemsPerRow: CGFloat = 3
    
    private var images: [UIImage?] = []
    private var imagesInfo = [ImageInfo]()

    @IBOutlet private weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
       configure()
        loadImages()
    }
    
    private func configure() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func loadImages() {
        NetworkService.shared.fetchImages(amount: 20) { (result) in
            switch result {
            case let .failure(error):
                print(error)
            case let .success(imagesInfo):
                self.imagesInfo=imagesInfo
                self.collectionView.reloadData()
            }
        }
    }
    
    private func loadImage(for cell: ImageCell, at index: Int) {
        let info = imagesInfo[index]
        NetworkService.shared.loadImage(from: info.previewURL) { (image) in
            if let image=image {
                cell.configure(with: image)

            }
        }
    }

}

extension ImageViewController: UICollectionViewDataSource, UICollectionViewDelegate {
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return imagesInfo.count
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as? ImageCell else {
        fatalError("Incorrect Cell Format")
    }
    
    
    loadImage(for: cell, at: indexPath.row)
    
    return cell
}
}

extension ImageViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfItemsPerRow: CGFloat = 3
        let width = view.bounds.width
        let summarySpacing = spacing * (numberOfItemsPerRow - 1)
        let insets = 2 * spacing
        let rawWidth = width - summarySpacing - insets
        let cellWidth = rawWidth/numberOfItemsPerRow
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        50
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
}

