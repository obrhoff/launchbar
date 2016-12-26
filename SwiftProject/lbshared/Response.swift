//
//  Responds.swift
//  LaunchBar
//
//  Created by Dennis Oberhoff on 26/12/2016.
//  Copyright © 2016 Dennis Oberhoff. All rights reserved.
//

import Foundation

public struct Response {
    
    let title : String
    let subtitle : String
    let url : String
    let icon : String
    
    public var dict : [String : String] {
        get {
            return ["title": self.title, "subtitle": self.subtitle, "url": self.url, "icon": self.icon]
        }
    }
}
