//
//  ServiceProtocol.swift
//  LaunchBar
//
//  Created by Dennis Oberhoff on 26/12/2016.
//  Copyright © 2016 Dennis Oberhoff. All rights reserved.
//

import Foundation

public protocol ServiceProtocol {
    static func perform(query: String)
    static func parse(data: Any?) -> [Response]
    static func fetch(request: URLRequest?)
}

extension ServiceProtocol {

    static func fetch(request: URLRequest?) {

        var response = [Response]()
        guard let request = request else { return }

        let semaphore = DispatchSemaphore(value: 0)

        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, request, error in
            defer {
                semaphore.signal()
            }
            guard let data = data else { return }
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
            response = Self.parse(data: json)
        })

        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        let jsonDict = response.map({ $0.dict })
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted)
        let jsonText = String(data: jsonData ?? Data(), encoding: .utf8) ?? String()
        print(jsonText)
    }
}
