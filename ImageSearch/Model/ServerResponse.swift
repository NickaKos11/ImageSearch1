//
//  ServerResponse.swift
//  ImageSearch
//
//  Created by Костина Вероника  on 07.01.2021.
//

import Foundation

struct ServerResponse<Object: Decodable>: Decodable {
    var hits: [Object]
}
