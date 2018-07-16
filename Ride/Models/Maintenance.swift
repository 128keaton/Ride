//
//  Maintenance.swift
//  Ride
//
//  Created by Keaton Burleson on 7/6/18.
//  Copyright © 2018 Keaton Burleson. All rights reserved.
//

import Foundation

class Maintenance: Codable{
    var performedOn: Date = Date()
    var maintenanceType: MaintenanceType? = .other
    var recordType: RecordType? = .app
    var ride: Ride? = nil
    var description: String? = ""
    var documentURL: URL? = nil
    
    init(){
    }
    
    convenience init(performedOn: Date, maintenanceType: MaintenanceType, ride: Ride, description: String) {
        self.init()
        self.performedOn = performedOn
        self.maintenanceType = maintenanceType
        self.ride = ride
        self.description = description
    }
    
    convenience init(performedOn: Date, documentURL: URL, type: RecordType, ride: Ride){
        self.init()
        self.performedOn = performedOn
        self.documentURL = documentURL
        self.recordType = type
        self.ride = ride
    }
    
    func toJson() -> String {
        var encodedRide: Data? = nil
        do {
            try encodedRide = JSONEncoder().encode(self)
        } catch _ {
            print("Unable to encode maintenance record: \(self)")
            return String()
        }
        
        return String(data: encodedRide!, encoding: .utf8)!
    }
}

enum RecordType: Int, Codable{
    case app = 0
    case pdf = 1
    case rawText = 2
}

enum MaintenanceType: Int, Codable{
    case other = 9999
    case oilChange = 1
    case suspensionReplacement = 2
    case alignment = 3
    case tireBalance = 4
    case tireRotation = 5
    case tireReplacement = 6
    case coolantFlush = 7
    case newRim = 8
}
