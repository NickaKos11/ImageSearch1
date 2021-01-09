//
//  SecondViewController.swift
//  ImageSearch
//
//  Created by Костина Вероника  on 07.01.2021.
//

import UIKit

class SecondViewController: UIViewController {

    var detail: String?
    var image: UIImage?
    var likes: Int?
    var author: String?
    var user: String?
    var pictureName: String?
    
    @IBOutlet weak var userId: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var fullPicture: UIImageView!
    @IBOutlet weak var likesAmount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.descriptionLabel.text = self.detail
        self.fullPicture.image = self.image
        self.likesAmount.text = String(likes ?? 0)
        self.username.text = self.author
        self.userId.text = "@\(user ?? "-")"
        }
    

}
