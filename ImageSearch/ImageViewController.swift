//
//  ImageViewController.swift
//  ImageSearch
//
//  Created by Костина Вероника  on 06.01.2021.
//

import UIKit

class ImageViewController: UIViewController {
    
    let spacing: CGFloat = 15
    let numberOfItemsPerRow: CGFloat = 3
    
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
        NetworkService.shared.fetchImages(amount: 9) { (result) in
            switch result {
            case let .failure(error):
                print(error)
            case let .success(imagesInfo):
                self.imagesInfo=imagesInfo
                self.images = Array(repeating: nil, count: imagesInfo.count)
                self.collectionView.reloadData()
            }
        }
    }
    
    private func loadImage(for cell: ImageCell, at index: Int) {
        let info = imagesInfo[index]
        NetworkService.shared.loadImage(from: info.urls.full) { (image) in
            self.images[index] = image
            cell.configure(with: self.images[index])

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
        spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        spacing
    }
}

