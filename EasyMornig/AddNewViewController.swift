//
//  AddAlarmViewController.swift
//  Alarm
//
//  Created by Petar Korda on 5/4/17.
//  Copyright © 2017 Cash Me Outside. All rights reserved.
//

import UIKit

protocol AddNewDelegate {
    func alarmAdded(new: Alarm)
}

class AddNewViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var snoozeSwitch: UISwitch!
    @IBOutlet weak var newsSwitch: UISwitch!
    @IBOutlet weak var spotifySwitch: UISwitch!
    @IBOutlet weak var forecastForCity: UITextField!
    @IBOutlet weak var forecastSwitch: UISwitch!
    @IBOutlet weak var cityStack: UIStackView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var delegate: AddNewDelegate?
    var scheduler = Scheduler()
    
    @IBOutlet var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x:0,y:250), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x:0,y:0), animated: true)
    }
    
    @IBAction func forecastSwitchPressed(_ sender: UISwitch) {
        if !forecastSwitch.isOn {
            cityStack.isHidden = true
        } else {
            cityStack.isHidden = false
        }
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        
        var newAlarm = Alarm()
        
        
        newAlarm.date = datePicker.date
        
        newAlarm.enabled = true
        newAlarm.uuid = UUID().uuidString
        newAlarm.forcastForCity = forecastForCity.text
        newAlarm.newsFlag = newsSwitch.isOn
        newAlarm.forecastFlag = forecastSwitch.isOn
        newAlarm.snoozeFlag = snoozeSwitch.isOn
        newAlarm.spotifyFlag = spotifySwitch.isOn
        
        let currentDate = Date()
        
        if (currentDate > newAlarm.date) {
            //schedule for next day
            newAlarm.date = Date(timeInterval: 24*60*60, since: newAlarm.date)
        }
        
        
        delegate!.alarmAdded(new: newAlarm)
        
        scheduler.scheduleNotification(alarm: newAlarm)
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
}
