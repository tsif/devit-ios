//
//  Rating.swift
//  DEVit
//
//  Created by Athanasios Theodoridis on 03/11/2016.
//  Copyright © 2016 devitconf. All rights reserved.
//

import Foundation

import ObjectMapper

public class Rating: Mappable, CustomStringConvertible {
    
    var talkId: String? = nil
    var presentation: Int? = nil
    var topic: Int? = nil
    
    public var description: String {
        return "id: \(talkId) topicRating: \(topic) presentationRating: \(presentation)"
    }
    
    required public init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        
        self.presentation <- map["presentation"]
        self.topic <- map["topic"]
        
    }
    
}
