//
//  FlickrResponse.swift
//  Virtual-Tourist-Udacity
//
//  Created by Stefan Weiss on 08.04.22.
//

import Foundation
import UIKit

struct PhotoResponseData: Codable {
    let photos: PhotoSearchData
    let status: String?
    
    enum CodingKeys: String, CodingKey {
        case photos = "photos"
        case status = "stat"
    }
}

struct PhotoSearchData: Codable {
    let page: Int
    let pages: Int
    let perPage: Int
    let photo: [PhotoInformation]
    
    enum CodingKeys: String, CodingKey {
        case page
        case pages
        
        case perPage = "perpage"
        case photo = "photo"
    }
}

struct PhotoInformation: Codable {
    
    let title: String
    let url_m: String?
    let id: String?
    
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case url_m = "url_m"
        case id = "id"
    }
}

