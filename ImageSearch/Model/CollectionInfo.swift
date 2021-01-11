//
//  CollectionInfo.swift
//  ImageSearch
//
//  Created by Костина Вероника  on 09.01.2021.
//

import Foundation


struct CollectionInfo: Decodable {
    var id: String
    var cover_photo: photo
    var title: String
}

struct photo: Decodable {
    var urls: link
}

struct link:Decodable {
    var full: URL?
}
