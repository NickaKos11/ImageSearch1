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
    
}

struct url: Decodable {
    var full: URL?
    
}
