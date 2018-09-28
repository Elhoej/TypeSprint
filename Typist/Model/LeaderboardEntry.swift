//
//  LeaderboardEntry.swift
//  Typist
//
//  Created by Simon Elhoej Steinmejer on 27/09/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import Foundation

struct LeaderboardEntry
{
    var name: String?
    var wpm: NSNumber?
    
    init(dictionary: [String: Any])
    {
        self.name = dictionary["name"] as? String
        self.wpm = dictionary["wpm"] as? NSNumber
    }
}
