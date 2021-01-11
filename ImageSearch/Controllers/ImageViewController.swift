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
    
    private var images: [UIImage?] = []
    private var imagesInfo = [ImageInfo]()
    private var collectionInfo = [CollectionInfo]()
    
    var rowOfCell: Int = 0
    
    let spacing: CGFloat = 15
    let numberOfItemsPerRow: CGFloat = 3
    
    let switchController = UISwitch(frame: CGRect(x: 300, y: 135, width: 150, height: 50))
    
    
    //MARK:- Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       configure()
 
        switchController.addTarget(self, action: #selector(switchAction), for: .touchUpInside)
        var label = UILabel(frame: CGRect(x: 30, y: 100, width: 300, height: 100))

        label.text = "Включить поиск по коллекциям"
        self.view.addSubview(label)
        self.view.addSubview(switchController)
    }
    
    @objc func switchAction(){
        if switchController.isOn == true {
  
      print("Switch tapped")
        }
    }
    
    private func configure() {
        collectionView.delegate = self
        collectionView.dataSource = self
        setupSpinner()
        setupSearchController()
        getCachedImages()
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
    
    private func loadImage(for cell: ImageCell, at index: Int) {
        if let image = images[index] {
            cell.configure(with: image)
            return
        }
 
        
        if switchController.isOn == true {
            let info = collectionInfo[index]
            
            NetworkService.shared.loadCollectionImage(from: info.cover_photo.urls.full) { (image) in
                if index < self.images.count {
                self.images[index] = image
                cell.configure(with: self.images[index])
                }
            }

        } else {
            let info = imagesInfo[index]
            NetworkService.shared.loadImage(from: info.urls.full) { (image) in
                if index < self.images.count {
                self.images[index] = image
                    CacheManager.shared.cacheImage(image, with: info.id)
                cell.configure(with: self.images[index])
                }
            }

        }

   
    }
    
    private func getCachedImages() {
       CacheManager.shared.getCachedImages { (images) in
           self.images = images
           self.updateUI()
       }
   }
    
    //MARK:- SecondVC
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
    
    //MARK:-  search through collections
    private func loadCollections(query: String) {
        images.removeAll()
        updateUI()
        activityIndicator.startAnimating()
        NetworkService.shared.searchCollections(query: query, amount: 9) { (result) in
            self.activityIndicator.stopAnimating()
            switch result {
            case let .failure(error):
                print(error)
            case let .success(imagesInfo):
                self.collectionInfo=imagesInfo
                self.images = Array(repeating: nil, count: imagesInfo.count)
                self.updateUI()
            }
        }
    }
}

//MARK:- Data Source & Delegate
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

//MARK:- Flow Layout
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

//MARK:- SearchBarDelegate
extension ImageViewController: UISearchBarDelegate {
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if switchController.isOn == true {
            guard let query = searchBar.text else {
                return
            }
            loadCollections(query: query)
        } else {
            guard let query = searchBar.text else {
                return
            }
            loadImages(query: query)
        }


        

    }
}

