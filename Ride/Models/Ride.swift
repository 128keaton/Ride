//
//  Ride.swift
//  Ride
//
//  Created by Keaton Burleson on 7/4/18.
//  Copyright © 2018 Keaton Burleson. All rights reserved.
//

import Foundation

class Ride: Codable {
    public var year: Int = 2000
    public var make: String = ""
    public var model: String = ""
    public var name: String = ""
    public var trimLevel: String = ""
    public var description: String = ""

    init() {

    }

    convenience init(year: Int, make: String, model: String) {
        self.init()
        self.year = year
        self.make = make
        self.model = model
    }

    convenience init(year: Int, make: String, model: String, name: String, trimLevel: String, description: String) {
        self.init(year: year, make: make, model: model)
        self.name = name
        self.trimLevel = trimLevel
        self.description = description
    }

    func toJson() -> String {
        var encodedRide: Data? = nil
        do {
            try encodedRide = JSONEncoder().encode(self)
        } catch _ {
            print("Unable to encode ride: \(self)")
            return String()
        }

        return String(data: encodedRide!, encoding: .utf8)!
    }

    func getName() -> String {
        if self.name == "" {
            return "\(self.year) \(self.model)"
        }

        return self.name
    }
}


