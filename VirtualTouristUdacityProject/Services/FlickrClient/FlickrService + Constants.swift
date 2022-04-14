//
//  FlickrService + Constants.swift
//  VirtualTouristUdacityProject
//
//  Created by Stefan Weiss on 12.04.22.
//

import Foundation

import Foundation
import CoreData

enum API {
    static let Scheme = "https"
    static let Host = "api.flickr.com"
    static let Path = "/services/rest"
}

enum Methods {
    static let PhotoSearch = "flickr.photos.search"
}

enum ParameterKeys {
    static let APIKey = "api_key"
    static let Method = "method"
    static let Format = "format"
    static let NoJsonCallback = "nojsoncallback"
    static let Text = "text"
    static let BoundingBox = "bbox"
    static let Extra = "extras"
    static let latitude = "lat"
    static let longitude = "lon"
    static let per_page = "per_page"
    static let page = "page"
    static let pages = "pages"
}

enum ParameterDefaultValues {
    static let format = "json"
    static let noJsonCallback = "1"
    static let ExtraMediumURL = "url_m"
}
