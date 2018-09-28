//
//  WpmResult+Convenience.swift
//  Typist
//
//  Created by Simon Elhoej Steinmejer on 27/09/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import Foundation
import CoreData

extension WpmResult
{
    convenience init(wpm: Int32, timestamp: Date = Date(), context: NSManagedObjectContext = CoreDataManager.shared.mainContext)
    {
        self.init(context: context)
        self.wpm = wpm
        self.timestamp = timestamp
    }
}
