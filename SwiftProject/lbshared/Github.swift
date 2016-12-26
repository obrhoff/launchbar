//
//  Github.swift
//  LaunchBar
//
//  Created by Dennis Oberhoff on 26/12/2016.
//  Copyright © 2016 Dennis Oberhoff. All rights reserved.
//

import Foundation

struct Github: ServiceProtocol {

    public static func perform(query: String) {

        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = "/search/repositories"
        components.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "sort", value: "stars"),
            URLQueryItem(name: "order", value: "desc"),
        ]

        guard let url = components.url else { return }

        let request = URLRequest(url: url)
        Github.fetch(request: request)
    }

    public static func parse(data: Any?) -> [Response] {

        var response = [Response]()

        let items = (data as? [String: Any])?["items"]

        (items as? [[String: Any]])?.forEach({
            let title = ($0["full_name"] as? String) ?? String()
            let subtitle = ($0["description"] as? String) ?? String()
            let link = ($0["html_url"] as? String) ?? String()
            response.append(Response(title: title, subtitle: subtitle, url: link, icon: "Github"))
        })
        return response
    }
}
