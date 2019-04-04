//
//  AppServerClient.swift
//  Boxing 247
//
//  Copyright © 2018 Omar. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AppServerClient: NSObject {
    
    var articles = [Article]()
    
    func downloadNews(completion: @escaping ([Article]) -> ()) {
        let newsfeedURL = URL(string: "https://bit.ly/2tZmM0E")
        var json : JSON?
        
        Alamofire.request(newsfeedURL!).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                json = JSON(value)

                for element in json!["items"].arrayValue {
                    let article = Article(initialiseArticleWith: element)
                    self.articles.append(article)
                }
                completion(self.articles)
            
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadURLimage(imageURL: String, completion: @escaping (UIImage) -> ()) {
        var image : UIImage?
        
        Alamofire.request(imageURL).responseData { (response) in
            if response.error == nil {
                print(response.result)
                if let data = response.data {
                    image = UIImage(data: data)
                    completion(image!)
                }
            }
        }
    
    }
}
