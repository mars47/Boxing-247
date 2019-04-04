//
//  NewsFeedCellVM.swift
//  Boxing 247
//
//  Copyright © 2018 Omar. All rights reserved.
//

import UIKit

class NewsFeedCellVM: NSObject {
    
    let article: Article
    let appServerClient: AppServerClient
    var image: UIImage!
    
    init(initWith article: Article, appServerClient: AppServerClient = AppServerClient()) {
        
        self.article = article
        self.appServerClient = appServerClient
        super.init()
        let thumbnailUrl = URL(string: article.thumbnail)
        setupThumbnailImage(url: thumbnailUrl!) // asynchronous network request
    }
    
    func setupThumbnailImage(url: URL) {
        appServerClient.loadURLimage(imageURL: "\(url)") { (result) in
        self.image = result
        }
    }
}
