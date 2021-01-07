//
//  SecondViewController.swift
//  ImageSearch
//
//  Created by Костина Вероника  on 07.01.2021.
//

import UIKit

class SecondViewController: UIViewController {

    var id: String?
    var url: URL?

    var pictureName: String?
    
    @IBOutlet weak var fullPicture: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()

        }
    func configure() {
        NetworkService.shared.loadImage(from: url) { (image) in
            self.fullPicture.image = image
    }
    }
    

}
