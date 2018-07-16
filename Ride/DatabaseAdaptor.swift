//
//  DatabaseAdaptor.swift
//  Ride
//
//  Created by Keaton Burleson on 7/4/18.
//  Copyright © 2018 Keaton Burleson. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import CodableFirebase

class DatabaseAdaptor {
    private var ref: DatabaseReference!
    private var rides: [String: Ride]? = [:]

    public weak var delegate: DatabaseAdaptorDelegate?
    public var uid: String? = nil
    
    init() {
        Database.database().isPersistenceEnabled = true
        self.ref = Database.database().reference()
        self.ref.keepSynced(true)
    }

    convenience init(uid: String) {
        self.init()
        self.uid = uid
    }

    private func rideReference() -> DatabaseReference {
        let rides = self.ref.child("rides")
        rides.keepSynced(true)
        
        return rides
    }
    
    private func maintenanceReference() -> DatabaseReference {
        let maintenanceRecords = self.ref.child("maintenance")
        maintenanceRecords.keepSynced(true)
        
        return maintenanceRecords
    }

    private func rideReference(forUser user: String = "test") -> DatabaseReference {
        let userRides = self.rideReference().child(user)
        userRides.keepSynced(true)
        
        return userRides
    }
    
    private func maintenanceReference(forUser user: String = "test" ) -> DatabaseReference {
        let maintenanceRecords = self.ref.child("maintenance")
        maintenanceRecords.keepSynced(true)
        
        return maintenanceRecords
    }


    public func subscribeToChanges() {
        guard let uid = self.uid
            else {
                return
        }

        let _ = rideReference(forUser: uid).observe(DataEventType.value, with: { (snapshot) in
            let rides = snapshot.value
            for rideSnapshot in (rides as! NSDictionary) {
                do {
                    let ride = try FirebaseDecoder().decode(Ride.self, from: rideSnapshot.value)
                    self.rides![rideSnapshot.key as! String] = ride
                } catch let error {
                    print(error)
                }
            }
            if rides != nil {
                self.delegate?.ridesDidUpdate(rides: self.rides!)
            }
        })
    }

    public func save(ride: Ride) -> Bool {
        guard let uid = self.uid
            else {
                return false
        }
        let jsonString = try! FirebaseEncoder().encode(ride)
        rideReference(forUser: uid).childByAutoId().setValue(jsonString)

        return true
    }

    public func rideFor(key: String) -> Ride? {
        return self.rides?[key]
    }
}

protocol DatabaseAdaptorDelegate: AnyObject {
    func ridesDidUpdate(rides: [String: Ride])
}

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
