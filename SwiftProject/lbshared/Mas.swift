//
//  Mas.swift
//  LaunchBar
//
//  Created by Dennis Oberhoff on 26/12/2016.
//  Copyright © 2016 Dennis Oberhoff. All rights reserved.
//

import Foundation

struct Mas: ServiceProtocol {

    public static func perform(query: String) {

        var components = URLComponents()
        components.scheme = "https"
        components.host = "itunes.apple.com"
        components.path = "/search"
        components.queryItems = [
            URLQueryItem(name: "term", value: query),
            URLQueryItem(name: "entity", value: "macSoftware"),
            URLQueryItem(name: "attribute", value: "allTrackTerm"),
        ]

        guard let url = components.url else { return }

        let request = URLRequest(url: url)
        Mas.fetch(request: request)
    }

    public static func parse(data: Any?) -> [Response] {

        var response = [Response]()

        let items = (data as? [String: Any])?["results"]

        (items as? [[String: Any]])?.forEach({
            let title = ($0["trackName"] as? String) ?? String()
            let subtitle = ($0["description"] as? String) ?? String()
            let link = ($0["trackViewUrl"] as? String) ?? String()
            response.append(Response(title: title, subtitle: subtitle, url: link, icon: "Github"))
        })
        return response
    }
}
