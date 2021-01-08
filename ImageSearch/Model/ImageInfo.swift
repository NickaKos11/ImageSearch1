//
//  Image.swift
//  ImageSearch
//
//  Created by Костина Вероника  on 07.01.2021.
//

import Foundation

struct ImageInfo: Decodable {
    var id: String
    var urls: url
    var description: String?
    var likes: Int?
    var user: user
    
}

struct url: Decodable {
    var full: URL?
    
}

struct user:Decodable {
    var username: String?
    var name: String?
}
