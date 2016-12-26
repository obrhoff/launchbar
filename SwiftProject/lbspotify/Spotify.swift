//
//  Spotify.swift
//  LaunchBar
//
//  Created by Dennis Oberhoff on 26/12/2016.
//  Copyright © 2016 Dennis Oberhoff. All rights reserved.
//

import Foundation

struct Spotify: ServiceProtocol {

    func perform(query: String) {

        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.spotify.com"
        components.path = "/v1/search"
        components.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "type", value: "track"),
        ]

        guard let url = components.url else { return }

        let request = URLRequest(url: url)
        self.fetch(request: request)
    }

    func parse(data: Any?) -> [Response] {

        var response = [Response]()
        let tracks = (data as? [String: Any])?["tracks"]
        let items = (tracks as? [String: Any])?["items"] as? [[String: Any]]

        items?.forEach({
            let title = ($0["name"] as? String) ?? String()
            let link = ($0["uri"] as? String) ?? String()
            let subtitle = (($0["artists"] as? [[String: Any]])?.first)?["name"] as? String ?? String()
            response.append(Response(title: title, subtitle: subtitle, url: link, icon: "Spotify"))
        })
        return response
    }
}
