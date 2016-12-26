//
//  Spotify.swift
//  LaunchBar
//
//  Created by Dennis Oberhoff on 26/12/2016.
//  Copyright © 2016 Dennis Oberhoff. All rights reserved.
//

import Foundation

struct Spotify: ServiceProtocol {

    public static func perform(query: String) {

        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.spotify.com"
        components.path = "/v1/search"
        components.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "type", value: "album,track,artist"),
        ]

        guard let url = components.url else { return }

        let request = URLRequest(url: url)
        self.fetch(request: request)
    }

    public static func parse(data: Any?) -> [Response] {

        var response = [Response]()
        let items = ((data as? [String: Any])?["tracks"] as? [String: Any])?["items"] as? [[String: Any]]
        let albums = ((data as? [String: Any])?["albums"] as? [String: Any])?["items"] as? [[String: Any]]
        let artists = ((data as? [String: Any])?["artists"] as? [String: Any])?["items"] as? [[String: Any]]

        let add = { (body: [String: Any]) in
            let title = (body["name"] as? String) ?? String()
            let link = (body["uri"] as? String) ?? String()
            let subtitle = ((body["artists"] as? [[String: Any]])?.first)?["name"] as? String ?? String()

            let type = body["type"] as? String ?? String()

            var icon = String()
            switch type {
            case "album":
                icon = "at.obdev.LaunchBar:AlbumTemplate"
                break
            case "artist":
                icon = "at.obdev.LaunchBar:ArtistTemplate"
                break
            default:
                icon = "at.obdev.LaunchBar:AudioTrackTemplate"
            }
            response.append(Response(title: title, subtitle: subtitle, url: link, icon: icon))
        }

        artists?.forEach(add)
        albums?.forEach(add)
        items?.forEach(add)
        return response
    }
}
