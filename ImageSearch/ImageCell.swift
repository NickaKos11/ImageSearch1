//
//  ImageCell.swift
//  ImageSearch
//
//  Created by Костина Вероника  on 06.01.2021.
//

import UIKit

class ImageCell: UICollectionViewCell {
    static let identifier = "imageCell"
    @IBOutlet private weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func configure(with image:UIImage?) {
        imageView.image = image
    }
}
