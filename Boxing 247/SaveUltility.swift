//
//  SaveUtility.swift
//  Boxing 247
//
//  Created by Omar on 17/04/2021.
//  Copyright © 2021 Omar. All rights reserved.
//

import Foundation
import SwiftyJSON

class SaveUtility {
    
    // MARK: - Saving Api data
    
    static func saveNewsArticles(withData json: JSON, completion: @escaping (Bool) -> Void) {
        
        CoreDataManager.performBackgroundTask { (context) in
            
            guard
                let dictionary = json.dictionary,
                let newsArticles = dictionary["items"]?.array
            else { completion(false); return }
            
            for article in newsArticles {
                NewsArticle.managedObject(withJson: article, in: context)
            }
            
            CoreDataManager.shared.save()
            completion(true)
        }
    }
    
    /* Generic method for saving core data entities */
    static func saveObjects<T: Updatable>(ofType updatableClass: T.Type, fromData data: Data, completion: @escaping (Bool) -> Void) {
        
        CoreDataManager.performBackgroundTask { (context) in
            
            if let jsonArray = try! JSON(data: data).array {
                
                for objectData in jsonArray {

                    updatableClass.managedObject(withJson: objectData, in: context)
                }
                
                CoreDataManager.shared.save()
                DispatchQueue.main.async {
                    completion(true)
                }
            }
        }
    }
    
    // MARK: - Saving local updates
    
    static func saveChanges() {
        
        do {
            try CoreDataManager.shared.container.viewContext.save()
            print("Saved changes successully!")

        } catch {
            print("Couldn't save object: \(error.localizedDescription)")
        }
    }

}
