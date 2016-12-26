//
//  main.swift
//  lbgithub
//
//  Created by Dennis Oberhoff on 26/12/2016.
//  Copyright © 2016 Dennis Oberhoff. All rights reserved.
//

import Foundation

var arguments = CommandLine.arguments.removeFirst()
let query = CommandLine.arguments.joined(separator: " ")

#if LBMAS
    Mas.perform(query: query)
#elseif LBGITHUB
    Github.perform(query: query)
#elseif LBCOCOAPODS
    Cocoapods.perform(query: query)
#elseif LBSPOTIFY
    Spotify.perform(query: query)
#endif
