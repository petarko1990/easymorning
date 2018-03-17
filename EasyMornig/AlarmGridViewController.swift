//
//  AlarmGridViewController.swift
//  EasyMornig
//
//  Created by Petar Korda on 6/10/17.
//  Copyright © 2017 Cash Me Outside. All rights reserved.
//

import UIKit
import UserNotifications

class AlarmGridViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, AddNewDelegate,UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var alarmCollection: UICollectionView!
    var cellWidth = CGFloat(100.0)
    var cellHeight = CGFloat(180.0)
    
    var alarms: Alarms!
    var selectedRow = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().delegate = self
        
        cellWidth = self.view.frame.size.width/2
        
        alarms = Alarms()
//        print(alarms.alarms[0].propertyDictRepresentation)
        
        let lpRecoginizer = UILongPressGestureRecognizer(target: self, action: #selector(AlarmGridViewController.longPressed(recognizer:)))
        alarmCollection.addGestureRecognizer(lpRecoginizer)
        // Do any additional setup after loading the view.
    }
    
    func printNots() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            print("//////////////////")
            if requests.count == 0 {
                print("No nots")
            }
            for r in requests {
                print(r.trigger!.description)
            }
            print("//////////////////")
        }
    }
    
    func longPressed(recognizer: UIGestureRecognizer) {
        if recognizer.state == UIGestureRecognizerState.ended {
            let point = recognizer.location(in: alarmCollection)
            if let indexPath = alarmCollection.indexPathForItem(at: point) {
                if indexPath.row != alarms.count {
                    let alert = UIAlertController(title: "Delete", message: "Do you want to delete this alarm?", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
                        let scheduler = Scheduler()
                        scheduler.descheduleNotification(alarm: self.alarms.alarms[indexPath.row])
                        self.alarms.alarms.remove(at: indexPath.row)
                        self.alarmCollection.reloadData()
                        
                    }))
                    
                    alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                }
                
                
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addNewAlarm() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "addNewVC") as! AddNewViewController
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }

    
    @IBAction func switchTapped(_ sender: UISwitch) {
        let scheduler = Scheduler()
        alarms.alarms[sender.tag].enabled = sender.isOn
        
        if (sender.isOn == false) {
            
            scheduler.descheduleNotification(alarm: alarms.alarms[sender.tag])
        } else {
            
            
            
            let currentDate = Date()
            let calendar = Calendar.current
            let currentComponents = calendar.dateComponents([.month, .day, .hour, .minute, .second], from: currentDate)
            
            let alarmComponents = calendar.dateComponents([.month, .day, .hour, .minute, .second], from: alarms.alarms[sender.tag].date)
            
            if currentDate > alarms.alarms[sender.tag].date {
                //adjust for next day
                
                var daysDifference = currentComponents.day! - alarmComponents.day!
                
                daysDifference += 1
                alarms.alarms[sender.tag].date = Date(timeInterval: TimeInterval(daysDifference*24*60*60), since: alarms.alarms[sender.tag].date)
                
                
                
                
                
            }
            
            scheduler.scheduleNotification(alarm: alarms.alarms[sender.tag])
            
            
        }
        
        
    }
    
    func alarmAdded(new: Alarm) {
//        print(new.propertyDictRepresentation)
//        print(new.forecastFlag)
        alarms.alarms.append(new)
        alarmCollection.reloadData()
        
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return alarms.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: cellWidth, height: cellHeight)
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        cellWidth = size.width/2
        alarmCollection.collectionViewLayout.invalidateLayout()
    
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if indexPath.row == alarms.count {
            let addNewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "addNewCell", for: indexPath)
            
            addNewCell.layer.borderWidth = 2
            
            
            return addNewCell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "alarmCell", for: indexPath) as! AlarmCell
        
        cell.tag = indexPath.row
        cell.enableSwitch.tag = indexPath.row
        cell.enableSwitch.isOn = alarms.alarms[indexPath.row].enabled
        

        cell.setAlarmTime(date: alarms.alarms[indexPath.row].date)
        cell.layer.borderWidth = 0.5
        //cell.layer.backgroundColor = UIColor.white.cgColor
        cell.updateShowingIcons(news: true, weather: true, music: true)
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = alarmCollection.cellForItem(at: indexPath)

        cell?.layer.borderWidth = 4
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            // Put your code which should be executed with a delay here

            cell?.layer.borderWidth = 0.5
        })
        
        if indexPath.row == alarms.count {
            addNewAlarm()
        }
        
        else {
            //open alarm details
            selectedRow = indexPath.row
            performSegue(withIdentifier: "showDetailSegue", sender: self)
        }
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier=="showDetailSegue"){
            let destinationVC:DetailTabBarController=segue.destination as! DetailTabBarController
            
            destinationVC.alarmToDisplay = alarms.alarms[selectedRow]
        }
        
    }
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
        
        
        let id = response.notification.request.content.userInfo["uuid"] as! String
        
        if let sr = alarms.alarms.index(where: {$0.uuid == id}) {
            selectedRow = sr
            alarms.alarms[selectedRow].enabled = false
            alarmCollection.reloadData()
            
        }
        
        if response.actionIdentifier == "start" {
            
            performSegue(withIdentifier: "showDetailSegue", sender: self)
    
        } else if response.actionIdentifier == "snooze" {
        
            let content = response.notification.request.content
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5*60, repeats: false)
            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
        }
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let id = notification.request.content.userInfo["uuid"] as! String
        
        let alert = UIAlertController(title: "Alarm", message: "Start your day in the most perfect way with EasyMorning", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "START", style: UIAlertActionStyle.default, handler: { (action) in
            
            
            
            if let sr = self.alarms.alarms.index(where: {$0.uuid == id}) {
                self.selectedRow = sr
                self.alarms.alarms[self.selectedRow].enabled = false
                self.alarmCollection.reloadData()
                
            }
            print(self.selectedRow)
            
            self.performSegueFromClosure(id: "showDetailSegue")
            
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "SNOOZE", style: UIAlertActionStyle.default, handler: { (action) in
            let content = notification.request.content
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5*60, repeats: false)
            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func performSegueFromClosure(id: String) {
        performSegue(withIdentifier: id, sender: self)
    }
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
