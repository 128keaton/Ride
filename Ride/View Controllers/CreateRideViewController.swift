//
//  CreateRideViewController.swift
//  Ride
//
//  Created by Keaton Burleson on 7/14/18.
//  Copyright © 2018 Keaton Burleson. All rights reserved.
//

import Foundation
import UIKit
import PKHUD

class CreateRideViewController: UITableViewController {
    @IBOutlet weak var yearField: UITextField?
    @IBOutlet weak var makeField: UITextField?
    @IBOutlet weak var modelField: UITextField?
    @IBOutlet weak var doneButton: UIButton?

    public var databaseAdaptor: DatabaseAdaptor?
    public var ride: Ride = Ride()

    private var years: [Int] = []
    private var defaultRowSelected = 100
    private var yearPicker: UIPickerView? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        configureYearPicker()

        yearField?.delegate = self
        makeField?.delegate = self
        modelField?.delegate = self

        yearField?.addTarget(self, action: #selector(textFieldChanged), for: UIControlEvents.editingChanged)
        yearField?.addTarget(self, action: #selector(selectYear), for: UIControlEvents.editingDidBegin)
        makeField?.addTarget(self, action: #selector(textFieldChanged), for: UIControlEvents.editingChanged)
        modelField?.addTarget(self, action: #selector(textFieldChanged), for: UIControlEvents.editingChanged)

        if self.databaseAdaptor == nil {
            print("DatabaseAdaptor property not set on CreateRideViewController")
            self.dismiss(animated: true, completion: nil)
        }
    }

    private func configureYearPicker() {
        if yearPicker == nil {
            yearPicker = self.initializeYearPicker()
        }
        
        yearPicker?.target(forAction: #selector(handleYearPicker(sender:)), withSender: yearPicker)
        yearField?.inputView = yearPicker!
    }

    @IBAction func doneButtonPressed(sender: UIButton) {
        saveAndDismiss()
    }

    private func saveAndDismiss() {
        HUD.show(.progress)
        ride.make = (makeField?.text)!
        ride.model = (modelField?.text)!

        if (self.databaseAdaptor?.save(ride: ride))! {
            HUD.show(.success)
            self.dismiss(animated: true, completion: {
                HUD.hide()
            })
        } else {
            HUD.show(.error)
        }
    }

    @objc private func handleYearPicker(sender: UIPickerView) {
        let selectedYear = years[sender.selectedRow(inComponent: 0)]
        yearField?.text = String(selectedYear)
        textFieldChanged()
        ride.year = selectedYear
    }

    @objc func selectYear(_ sender: UITextField) {
        yearField?.inputView = yearPicker!
        yearPicker?.selectRow(defaultRowSelected, inComponent: 0, animated: true)
        yearField?.text = String(years[defaultRowSelected])
        ride.year = years[defaultRowSelected]
    }

}

extension CreateRideViewController: UITextFieldDelegate {
    @objc func textFieldChanged() {
        self.doneButton?.isEnabled = (yearField?.text != "" && makeField?.text != "" && modelField?.text != "")
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == makeField && makeField?.text != "" {
            modelField?.becomeFirstResponder()
            return true
        } else if textField == modelField && modelField?.text != "" {
            modelField?.endEditing(true)
            return true
        } else if textField == yearField {
            return true
        }
        return false
    }
}

extension CreateRideViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func initializeYearPicker() -> UIPickerView {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let maxYear = Calendar.current.date(byAdding: .year, value: 1, to: Date())
        let maxInt = Int(formatter.string(from: maxYear!))

        for i in 1900...maxInt! {
            years.append(i)
        }

        let yearPicker = UIPickerView()
        yearPicker.delegate = self
        yearPicker.dataSource = self

        return yearPicker
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return years.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(years[row])
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.handleYearPicker(sender: pickerView)
    }

}

