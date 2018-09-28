//
//  Quote.swift
//  Typist
//
//  Created by Simon Elhoej Steinmejer on 27/09/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import Foundation

struct Quote: Decodable
{
    let contents: Contents
    
    enum CodingKeys: String, CodingKey
    {
        case contents
    }
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let contents = try container.decode(Contents.self, forKey: .contents)
        self.contents = contents
    }
    
    struct Contents: Decodable
    {
        let quote: String
        let author: String
        let id: String
        
        enum CodingKeys: String, CodingKey
        {
            case quote
            case author
            case id
        }
        
        init(from decoder: Decoder) throws
        {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let quote = try container.decode(String.self, forKey: .quote)
            let author = try container.decode(String.self, forKey: .author)
            let id = try container.decode(String.self, forKey: .id)
            
            self.quote = quote
            self.author = author
            self.id = id
        }
    }
}
