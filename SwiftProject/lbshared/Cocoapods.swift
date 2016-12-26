//
//  Cocoapods.swift
//  LaunchBar
//
//  Created by Dennis Oberhoff on 26/12/2016.
//  Copyright © 2016 Dennis Oberhoff. All rights reserved.
//

import Foundation

struct Cocoapods: ServiceProtocol {

    public static func perform(query: String) {

        var components = URLComponents()
        components.scheme = "https"
        components.host = "search.cocoapods.org"
        components.path = "/api/pods"
        components.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "amount", value: "20"),
        ]

        guard let url = components.url else { return }

        var request = URLRequest(url: url)
        request.addValue("application/vnd.cocoapods.org+flat.hash.json; version=1", forHTTPHeaderField: "Accept")
        self.fetch(request: request)
    }

    public static func parse(data: Any?) -> [Response] {

        var response = [Response]()
        (data as? [[String: Any]])?.forEach({
            let title = ($0["id"] as? String) ?? String()
            let subtitle = ($0["summary"] as? String) ?? String()
            let link = ($0["link"] as? String) ?? String()
            response.append(Response(title: title, subtitle: subtitle, url: link, icon: "Cocoapods"))
        })
        return response
    }
}
