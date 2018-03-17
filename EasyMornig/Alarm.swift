//
//  Alarm.swift
//  Alarm
//
//  Created by Petar Korda on 5/4/17.
//  Copyright © 2017 Cash Me Outside. All rights reserved.
//

import Foundation

struct Alarm: PropertyReflectable {
    var date: Date = Date()
    var enabled: Bool = false
    var uuid: String = ""
    //var onSnooze: Bool = false
    var snoozeFlag: Bool = false
    var forcastForCity: String?
    var newsFlag: Bool = false
    var forecastFlag: Bool = false
    var spotifyFlag: Bool = false
    
    var formattedTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: self.date)
    }
    
    init(){}
    
    init(date:Date, enabled:Bool,uuid:String, forCity: String?, getNews: Bool){
        self.date = date
        self.enabled = enabled
        self.uuid = uuid
        self.forcastForCity = forCity
        self.newsFlag = getNews
        
    }
    
    init(_ dict: PropertyReflectable.RepresentationType){
        date = dict["date"] as! Date
        enabled = dict["enabled"] as! Bool
        uuid = dict["uuid"] as! String
        snoozeFlag = dict["snoozeFlag"] as! Bool
        forcastForCity = dict["forcastForCity"] as? String
        newsFlag = dict["newsFlag"] as! Bool
        forecastFlag = dict["forecastFlag"] as! Bool
        spotifyFlag = dict["spotifyFlag"] as! Bool
    }
    
    static var propertyCount: Int = 8
}

class Alarms: Persistable {
    let ud: UserDefaults = UserDefaults.standard
    let persistKey: String = "myAlarmKey"
    var alarms: [Alarm] = [] {
        //observer, sync with UserDefaults
        didSet{
            persist()
        }
    }
    
    private func getAlarmsDictRepresentation()->[PropertyReflectable.RepresentationType] {
        return alarms.map {$0.propertyDictRepresentation}
    }
    
    init() {
        alarms = getAlarms()
    }
    
    func persist() {
        
        ud.set(getAlarmsDictRepresentation(), forKey: persistKey)
        ud.synchronize()
        
    }
    
    func unpersist() {
        for key in ud.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }
    
    var count: Int {
        return alarms.count
    }
    
    //helper, get all alarms from Userdefaults
    private func getAlarms() -> [Alarm] {
        
        let array = UserDefaults.standard.array(forKey: persistKey)
        
        guard let alarmArray = array else{
            return [Alarm]()
        }
        if let dicts = alarmArray as? [PropertyReflectable.RepresentationType]{
            if dicts.first?.count == Alarm.propertyCount {
                return dicts.map{Alarm($0)}
            }
        }
        unpersist()
        return [Alarm]()
    }
    
    
    
}




