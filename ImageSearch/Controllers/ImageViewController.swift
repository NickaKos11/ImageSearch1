//
//  ImageViewController.swift
//  ImageSearch
//
//  Created by Костина Вероника  on 06.01.2021.
//

import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    private var activityIndicator = UIActivityIndicatorView()
    
    var rowOfCell: Int = 0
    
    let spacing: CGFloat = 15
    let numberOfItemsPerRow: CGFloat = 3
    
    private var images: [UIImage?] = []
    private var imagesInfo = [ImageInfo]()

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        rowOfCell = indexPath.row
        print(rowOfCell)

        performSegue(withIdentifier: "ShowSecondVC", sender: indexPath)
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {        let fullInfo = imagesInfo[rowOfCell]
        if segue.identifier == "ShowSecondVC" {
            guard let secondVC = segue.destination as? SecondViewController
            else {
                fatalError()
            }
            secondVC.image = images[rowOfCell]
            secondVC.detail = fullInfo.description
            secondVC.likes = fullInfo.likes
            secondVC.author = fullInfo.user.name
            secondVC.user = fullInfo.user.username
        }
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       configure()
        //loadImages()
       getCachedImages()
        
    }
    
    private func configure() {
        collectionView.delegate = self
        collectionView.dataSource = self
        setupSpinner()
        setupSearchController()
    }
    
    private func setupSpinner() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = .blue
        activityIndicator.frame = collectionView.bounds
        activityIndicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.addSubview(activityIndicator)
    }
    
    private func setupSearchController() {
        let searchC = UISearchController(searchResultsController: nil)
        searchC.searchBar.placeholder = "Search"
        searchC.searchBar.delegate = self
        searchC.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchC
    }
    
    private func loadImages(query: String) {
        images.removeAll()
        updateUI()
        activityIndicator.startAnimating()
        NetworkService.shared.fetchImages(query: query, amount: 9) { (result) in
            self.activityIndicator.stopAnimating()
            switch result {
            case let .failure(error):
                print(error)
            case let .success(imagesInfo):
                self.imagesInfo=imagesInfo
                self.images = Array(repeating: nil, count: imagesInfo.count)
                self.updateUI()
            }
        }
    }
    
    private func updateUI() {
        self.collectionView.reloadSections(IndexSet(arrayLiteral: 0))
    }
    
    private func getCachedImages() {
       CacheManager.shared.getCachedImages { (images) in
           self.images = images
           self.updateUI()
       }
   }
    
    private func loadImage(for cell: ImageCell, at index: Int) {
        if let image = images[index] {
            cell.configure(with: image)
            return
        }
        let info = imagesInfo[index]
        NetworkService.shared.loadImage(from: info.urls.full) { (image) in
            if index < self.images.count {
            self.images[index] = image
                //CacheManager.shared.cacheImage(image, with: info.id)
            cell.configure(with: self.images[index])
            }
        }
    }

}

extension ImageViewController: UICollectionViewDataSource, UICollectionViewDelegate {
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return images.count
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

extension ImageViewController: UISearchBarDelegate {
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {

        guard let query = searchBar.text else {
            return
        }
        
        loadImages(query: query)
    }
}

