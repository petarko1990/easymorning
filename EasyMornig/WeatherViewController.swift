//
//  WeatherViewController.swift
//  EasyMornig
//
//  Created by Petar Korda on 6/12/17.
//  Copyright © 2017 Cash Me Outside. All rights reserved.
//
//  fe12f4cbb5a6a0353d67f027c22d1698

//  http://api.openweathermap.org/data/2.5/weather?q=milan&units=metric&appid=f1f9721c61ca7d5808fd5475473677d7

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, SpotifyDelegate, SPTAudioStreamingDelegate {
    
    var getForecast = false
    var forecastForCity: String?
    var currentLocation: CLLocation?
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var notAvailableMsg: UILabel!
    
    @IBOutlet weak var conditionImg: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var conditionDesc: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var otherLabels: UIStackView!
    @IBOutlet weak var background: UIImageView!
    
    var degree: Int!
    var condition: String!
    var conditionId: Int!
    var conditionImgName: String!
    var pressure: Int!
    var humidity: Int!
    var wind: Int!
    
    var player: SPTAudioStreamingController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if getForecast {
            
            if forecastForCity != nil && forecastForCity != "" {
                fetchWeatherData()
            }
            else {
                
                getCurrentLocationAndData()
            }
        }
        else {
            //show unavailable
            self.notAvailable(msg: "You didn't select weather forecast to display..")
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setPlayer(player: SPTAudioStreamingController?) {
        self.player = player
    }
    
    func audioStreamingDidLogout(_ audioStreaming: SPTAudioStreamingController!) {
        try! player?.stop()
    }
    
    // Do any additional setup after loading the view.
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        if player != nil {
            player!.logout()
        }
        dismiss(animated: true, completion: nil)
    }
    

    func getCurrentLocationAndData() {
        
        
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                
                self.notAvailable(msg: "Restriction to use current location")
            case .authorizedAlways, .authorizedWhenInUse:
                
                    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                    currentLocation = locationManager.location
                    fetchWeatherDataCurrent()
            }
        } else {
            print("Location services are not enabled")
            self.notAvailable(msg: "Restriction to use current location")
        }

    }
    func setConditionImg(id: Int) -> String {
        switch id {
        case 800:
            return "clear"
        case 700...799, 801...809:
            return "cloud"
        case 300...599:
            return "rain"
        case 200...299, 900...999:
            return "storm"
        case 600...699:
            return "snow"
        default:
            return "clear"
        }
    }
    
    func fetchWeatherDataCurrent() {
        let urlRequest = URLRequest(url: URL(string: "http://api.openweathermap.org/data/2.5/weather?appid=f1f9721c61ca7d5808fd5475473677d7&units=metric&lat=\(currentLocation!.coordinate.latitude)&lon=\(currentLocation!.coordinate.longitude)")!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            if error==nil{
                do{
                    let json=try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
                    
                    
                    if let main=json["main"] as? [String: AnyObject]{
                        
                        if let temp=main["temp"] as? Int{
                            self.degree = temp
                        }
                        
                        if let pressure = main["pressure"] as? Int {
                            self.pressure = pressure
                        }
                        
                        if let humidity = main["humidity"] as? Int {
                            self.humidity = humidity
                        }
                        
                    }
                    
                    if let wind = json["wind"] as? [String: AnyObject] {
                        self.wind = wind["speed"] as! Int
                    }
                    
                    if let conditions = json["weather"] as? [[String:AnyObject]] {
                        self.condition = conditions[0]["description"] as! String
                        self.conditionId = conditions[0]["id"] as! Int
                        self.conditionImgName = self.setConditionImg(id: self.conditionId)
                        
                    }
                    
                    
                    
                    
                    
                    DispatchQueue.main.async {
                        
                            self.tempLabel.isHidden=false
                            self.conditionImg.isHidden=false
                            self.tempLabel.text="\(self.degree.description)°"
                            self.cityLabel.text="Current location"
                            self.conditionDesc.text = self.condition
                            self.conditionImg.image = UIImage(named: self.conditionImgName)
                            self.pressureLabel.text = "\(self.pressure.description) h/Pa"
                            self.windLabel.text = "\(self.wind.description) km/h"
                            self.humidityLabel.text = "\(self.humidity.description) %"
                            
                            
                        
                    }
                }
                catch let jsonError{
                    print(jsonError.localizedDescription)
                    
                }
                
            }
            
        }
        task.resume()
    }
    
    func fetchWeatherData() {
        let urlRequest = URLRequest(url: URL(string: "http://api.openweathermap.org/data/2.5/weather?appid=f1f9721c61ca7d5808fd5475473677d7&units=metric&q=\(forecastForCity!.replacingOccurrences(of: " ", with: "%20"))")!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            if error==nil{
                do{
                    let json=try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
                    
                    if let notFound = json["cod"] as? String {
                        if notFound == "404" {
                            self.getCurrentLocationAndData()
                            return
                        }
                    }
                    
                    if let main=json["main"] as? [String: AnyObject]{
                        
                        if let temp=main["temp"] as? Int{
                            self.degree = temp
                        }
                        
                        if let pressure = main["pressure"] as? Int {
                            self.pressure = pressure
                        }
                        
                        if let humidity = main["humidity"] as? Int {
                            self.humidity = humidity
                        }
                        
                    }
                    
                    if let wind = json["wind"] as? [String: AnyObject] {
                        self.wind = wind["speed"] as! Int
                    }
                    
                    if let conditions = json["weather"] as? [[String:AnyObject]] {
                        self.condition = conditions[0]["description"] as! String
                        self.conditionId = conditions[0]["id"] as! Int
                        self.conditionImgName = self.setConditionImg(id: self.conditionId)
                        
                    }
                    
                    
                    
                    DispatchQueue.main.async {
                        
                            self.tempLabel.isHidden=false
                            self.conditionImg.isHidden=false
                            self.tempLabel.text="\(self.degree.description)°"
                            self.cityLabel.text=self.forecastForCity
                            self.conditionDesc.text = self.condition
                            self.conditionImg.image = UIImage(named: self.conditionImgName)
                            self.pressureLabel.text = "\(self.pressure.description) h/Pa"
                            self.windLabel.text = "\(self.wind.description) km/h"
                            self.humidityLabel.text = "\(self.humidity.description) %"
                            
                            
                        
                    }
                }
                catch let jsonError{
                    print(jsonError.localizedDescription)
                    
                }
                
            }
            
        }
        task.resume()
    }
    
    func notAvailable(msg: String) {
        notAvailableMsg.isHidden = false
        notAvailableMsg.text = msg
        conditionImg.isHidden = true
        cityLabel.isHidden = true
        tempLabel.isHidden = true
        conditionDesc.isHidden = true
        humidityLabel.isHidden = true
        windLabel.isHidden = true
        pressureLabel.isHidden = true
        otherLabels.isHidden = true

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

