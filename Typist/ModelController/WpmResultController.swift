//
//  WpmResultController.swift
//  Typist
//
//  Created by Simon Elhoej Steinmejer on 27/09/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import Foundation
import CoreData

class WpmResultController
{
    private(set) var wpmResults = [WpmResult]()
    
    func createNewResult(wpm: Int32)
    {
        let result = WpmResult(wpm: wpm, context: CoreDataManager.shared.mainContext)
        
        do {
            
            try CoreDataManager.shared.saveContext()
            self.wpmResults.append(result)
            
        } catch let error {
            print(error)
        }
    }
    
    func fetchWpmResults(completion: (() -> ())? = nil)
    {
        let backgroundMoc = CoreDataManager.shared.container.newBackgroundContext()
        
        let fetchRequest = NSFetchRequest<WpmResult>(entityName: "WpmResult")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            
            let results = try backgroundMoc.fetch(fetchRequest)
            self.wpmResults = results
            completion?()
            
        } catch let fetchError {
            NSLog(fetchError as! String)
        }
    }
}
