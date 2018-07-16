//
//  KBYearPicker.swift
//  Ride
//
//  Created by Keaton Burleson on 7/15/18.
//  Copyright © 2018 Keaton Burleson. All rights reserved.
//

import Foundation
import UIKit

class KBYearPicker: UIPickerView{
    public weak var pickerDelegate: KBYearPickerDelegate?
}

protocol KBYearPickerDelegate: AnyObject {
    func yearSelected(year: Int)
}
