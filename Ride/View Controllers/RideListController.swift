//
//  ViewController.swift
//  Ride
//
//  Created by Keaton Burleson on 6/30/18.
//  Copyright © 2018 Keaton Burleson. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RideListController: UICollectionViewController, DatabaseAdaptorDelegate {
    var rides: [String: Ride] = [:]
    var databaseAdaptor: DatabaseAdaptor? = nil
    var selectedRide: Ride!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.dataSource = self
        self.collectionView?.delegate = self
        self.collectionView?.contentInset = UIEdgeInsetsMake(10, 20, 10, 20)
        self.collectionView?.reloadData()
        
        let addGesture = UITapGestureRecognizer(target: self, action: #selector(showAddView))
        self.collectionView?.addGestureRecognizer(addGesture)
        
        Auth.auth().signIn(withEmail: "keaton.burleson@me.com", password: "test123") { (user, error) in
            let uid = user?.uid
            self.databaseAdaptor = DatabaseAdaptor(uid: uid!)
            self.databaseAdaptor?.delegate = self
            self.databaseAdaptor?.subscribeToChanges()
        }
    }

    func ridesDidUpdate(rides: [String: Ride]) {
        self.rides = rides

        self.collectionView?.reloadData()
        self.collectionView?.collectionViewLayout.invalidateLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func showAddView(){
        self.performSegue(withIdentifier: "newRide", sender: self)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: RideCell!
        let keys = Array(self.rides.keys)

        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rideCell", for: indexPath) as? RideCell
        let key = keys[indexPath.row]
        guard let ride = databaseAdaptor?.rideFor(key: key)
            else {
                return cell!
        }

        cell?.primaryLabel?.text = ride.getName()
        cell?.secondaryLabel?.text = ride.make


        return cell!
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.rides.count
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let key = Array(self.rides.keys)[indexPath.row]
        guard let ride = databaseAdaptor?.rideFor(key: key)
            else {
                return
        }
        self.selectedRide = ride
        self.performSegue(withIdentifier: "showRide", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showRide") {
            let rideViewController = segue.destination.childViewControllers[0] as! RideViewController
            rideViewController.ride = self.selectedRide
            rideViewController.configureView()
            segue.destination.title = self.selectedRide.getName()
        }else{
            let createRideViewController = segue.destination as! CreateRideViewController
            createRideViewController.databaseAdaptor = self.databaseAdaptor
        }
    }


}

