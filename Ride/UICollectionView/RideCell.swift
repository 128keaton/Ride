//
//  RideCell.swift
//  Ride
//
//  Created by Keaton Burleson on 7/4/18.
//  Copyright © 2018 Keaton Burleson. All rights reserved.
//

import Foundation
import UIKit
class RideCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var primaryLabel: UILabel?
    @IBOutlet weak var secondaryLabel: UILabel?
    @IBOutlet weak var otherLabel: UILabel?
    @IBOutlet fileprivate weak var containerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 6
        containerView.layer.masksToBounds = true
    }
}
