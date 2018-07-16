//
//  RideViewController.swift
//  Ride
//
//  Created by Keaton Burleson on 7/4/18.
//  Copyright © 2018 Keaton Burleson. All rights reserved.
//

import Foundation
import UIKit

class RideViewController: UITableViewController{
    var ride: Ride? = nil
    
    @IBOutlet weak var descriptionCell: UITableViewCell?
    @IBOutlet weak var descriptionText: UITextView?
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var yearLabel: UILabel?
    @IBOutlet weak var makeLabel: UILabel?
    @IBOutlet weak var modelLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // Resizes
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 3){
            return ((descriptionText?.contentSize.height)! + 25)
        }
        return 55
    }
    
    func configureView(){
        guard let ride = self.ride
            else{
                self.dismiss(animated: true, completion: nil)
                return
        }
        self.parent?.navigationController?.title = ride.getName()
        imageView?.removeFromSuperview()
        yearLabel?.text = String(ride.year)
        makeLabel?.text = ride.make
        modelLabel?.text = ride.model
        descriptionText?.text = ride.description
        self.tableView.reloadRows(at: [IndexPath.init(row: 4, section: 0)], with: .automatic)
    }
}
