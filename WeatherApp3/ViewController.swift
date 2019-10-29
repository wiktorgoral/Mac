//
//  ViewController.swift
//  WeatherApp3
//
//  Created by Student on 15.10.2019.
//  Copyright © 2019 Student. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate{
    
    let locationManager:CLLocationManager = CLLocationManager()
    
    var curr = 0
    var max = 0
    var latiude = CLLocationDegrees()
    var longitiude = CLLocationDegrees()
    var woeid = Int()
    var weathers = NSArray()
    var weather = NSDictionary()
    @IBOutlet weak var tworca: UILabel!
    @IBOutlet weak var ikona: UIImageView!
    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var temperatura: UILabel!
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var rain: UILabel!
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var prevButton: UIButton!
    @IBAction func prevAction(_ sender: Any) {
        if self.curr != 0 {
            curr-=1
            self.updateView()
        }
    }
    
    @IBOutlet weak var nextButton: UIButton!
    @IBAction func nextAction(_ sender: Any) {
        if self.curr != self.max{
            curr+=1
            self.updateView()
        }
    }
    
    
    
    func getWoeid(completion: @escaping ( _ result: Int) -> () ){
        
        locationManager.requestWhenInUseAuthorization()
        var w = Int()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            
            let url = URL(string: "https://www.metaweather.com/api/location/search/?lattlong=\(latiude),\(longitiude)")!
            let session = URLSession.shared.dataTask(with: url, completionHandler:  { (data, response, error) -> Void in DispatchQueue.main.async {
                if let data = data {
                    if let cities = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)as? NSArray {
                        if let city = cities!.firstObject as? NSDictionary{
                            w = (city.value(forKey: "woeid") as? Int)!
                            completion(w)
                        }
                    }
                }
                }
            }
            )
            session.resume()
        }
        
    }
    
    
    
    func getWeather(woeid:Int, completion: @escaping ( _ result: NSArray)->()){
        var weathers:NSArray = NSArray()
        let url = URL(string: "https://www.metaweather.com/api/location/\(woeid)/")!
        let session = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) -> Void in DispatchQueue.main.async {
            if let data = data{
                if let all = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)as? NSDictionary {
                    weathers = all!.value(forKey: "consolidated_weather") as! NSArray
                    completion(weathers)
                }
            }
            }
        }
        )
        session.resume()
    }
    func getImage(short: String, completion: @escaping ( _ result: UIImage)->()){
        var image = UIImage()
        let url = URL(string: "https://www.metaweather.com/static/img/weather/png/64/\(short).png")!
        let session = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) -> Void in DispatchQueue.main.async {
            if let data = data{
                image = UIImage(data: data)!
                completion(image)
                }
            }
        }
        )
        session.resume()
    }
    
    func updateView(){
        if self.curr==0{
            self.prevButton.isEnabled=false
        }
        else if self.curr==self.max{
            self.nextButton.isEnabled=false
        }
        else{
            self.nextButton.isEnabled=true
            self.prevButton.isEnabled=true
        }
        self.weather = self.weathers[self.curr] as! NSDictionary
        self.getImage(short:  self.weather.value(forKey: "weather_state_abbr") as! String){(value2) in
            self.ikona.image = value2
            self.data.text = "Date \(String(describing: self.weather.value(forKey: "applicable_date") as! String))"
            self.type.text = "Type \(String(describing: self.weather.value(forKey: "weather_state_name") as! String))"
            self.temperatura.text = "Tempreture \(String(format:"%.0f", self.weather.value(forKey: "min_temp") as! Double))℃ - \(String(format:"%.0f", self.weather.value(forKey: "max_temp") as! Double))℃"
            self.wind.text = "Wind \(String(self.weather.value(forKey: "wind_direction_compass") as! String)) \(String(format:"%.0f", self.weather.value(forKey: "wind_speed") as! Double)) mph"
            self.rain.text = "Humidity \(String(describing: self.weather.value(forKey: "humidity") as! Int))%"
            self.pressure.text = "Pressure \(String(describing: self.weather.value(forKey: "air_pressure") as! Int)) mbar"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWoeid(){(value) in
            self.woeid = value
            self.getWeather(woeid: self.woeid){(value1) in
                self.weathers = value1
                self.max = self.weathers.count - 1
                if self.weathers.firstObject != nil{
                    self.updateView()
                }
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for currentLocation in locations{
            self.longitiude = currentLocation.coordinate.longitude
            self.latiude = currentLocation.coordinate.latitude
        }
    }
}
