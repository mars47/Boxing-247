//
//  NewsFeedVM.swift
//  Boxing 247
//
//  Copyright © 2018 Omar. All rights reserved.
//

import Foundation

class NewsFeedVM: NSObject {
    
    var articlesArray = Bindable([Article]())
    let url = URL(string: "https://bit.ly/2tZmM0E")
    var cellVMArray: [NewsFeedCellVM]!
    let appServerClient : AppServerClient
    
    init(appServerClient: AppServerClient = AppServerClient()) {
        self.appServerClient = appServerClient
    }
    
    func downloadNews() {
        
        self.appServerClient.downloadNews() { (result) in
            self.articlesArray.value = result
            
            // create an array of view models. 1 for each tableview view cell / articles returned from the web request
            self.cellVMArray = self.articlesArray.value.flatMap{ NewsFeedCellVM(initWith: $0) }
        }
        
    }
}
