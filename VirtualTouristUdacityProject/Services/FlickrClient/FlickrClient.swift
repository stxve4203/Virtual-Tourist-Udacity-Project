//
//  FlickrClient.swift
//  Virtual-Tourist-Udacity
//
//  Created by Stefan Weiss on 10.04.22.
//

import Foundation
import UIKit
import CoreLocation
import CoreData

class FlickrClient {
   
    var totalPages: Int?
    lazy var maxPhotos = Pin().maxPages
    
    var session: URLSession

    init(session: URLSession) {
        self.session = session
    }
    
        
    func getParametersWithCoordinates(latitude: Double, longitude: Double, page: Int, perPage: Int) -> [String: Any] {
    
        let parameters = ([
            ParameterKeys.APIKey: Constants.API_KEY,
            ParameterKeys.Format: ParameterDefaultValues.format,
            ParameterKeys.Method: Methods.PhotoSearch,
            ParameterKeys.latitude: latitude,
            ParameterKeys.longitude: longitude,
            ParameterKeys.NoJsonCallback: ParameterKeys.NoJsonCallback,
            ParameterKeys.Extra: ParameterDefaultValues.ExtraMediumURL,
            ParameterKeys.per_page: perPage,
            ParameterKeys.page: page,
            ParameterKeys.pages: ParameterKeys.pages
            
            
        ] as? [String : Any])!
        return parameters
    }
    
    func getFlickrURLAndParameters(parameters: [String:Any]) -> URL? {
        var components = URLComponents()
        components.scheme = API.Scheme
        components.host = API.Host
        components.path = API.Path
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        print(components.url)
        return components.url
    }
    
    func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completionHandler: @escaping (ResponseType?, Error?) -> Void
    ) -> URLSessionDataTask {
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let responseData = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(responseData, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                    print(error)
                }
            }
        }
        task.resume()
        return task
    }
                              
    
    func getImagesFromFlickrURL(latitude: Double, longitude: Double, page: Int, completionHandler: @escaping ([PhotoInformation], Int, Error?) -> Void) {
        
        let parameters = getParametersWithCoordinates(latitude: latitude, longitude: longitude, page: page, perPage: 50)
        let url = getFlickrURLAndParameters(parameters: parameters)!
        
        _ = taskForGETRequest(url: url, responseType: PhotoResponseData.self) { response, error in
            if let response = response {
                completionHandler(response.photos.photo, response.photos.pages, nil)
//                print("Max pages for Photos: \(response.photos.pages)")
//                print("Total photos returned \(response.photos.photo.count)")
//                print("Photos per page: \(response.photos.perPage)")
                
            } else {
                completionHandler([], 0, error)
            }
        }
}
    
    func downloadImage(img: URL?, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        guard let imageURL = img else {
            DispatchQueue.main.async {
                completionHandler(nil, nil)
            }
            return
        }
        
        let request = URLRequest(url: imageURL)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let image = UIImage(data: data!) else {
                completionHandler(nil, error)
                return
            }
            completionHandler(image, nil)
        }
        task.resume()
    }
}

