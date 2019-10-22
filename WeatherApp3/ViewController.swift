//
//  ViewController.swift
//  WeatherApp3
//
//  Created by Student on 15.10.2019.
//  Copyright © 2019 Student. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    let locationManager = CLLocationManager()
    
    var curr = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways){
            locationManager.requestLocation()
        }
        
        temperatura.text = "Temp"
        
        let url = URL(string: "/static/img/weather/png/64/hr.png")!
        
        let session = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in DispatchQueue.main.async {
            
            if error == nil && data != nil {
                self.ikona.image = UIImage(data: data!)
            }
        }
            
    }
    )
        

        session.resume()
        nextBtn.isEnabled = true
        
}

    
    
    func retriveCurrentLocation(){
        let status = CLLocationManager.authorizationStatus()
        
        if(status == .denied || status == .restricted || !CLLocationManager.locationServicesEnabled()){
            // show alert to user telling them they need to allow location data to use some feature of your app
            return
        }
        
        // if haven't show location permission dialog before, show it to user
        if(status == .notDetermined){
            locationManager.requestWhenInUseAuthorization()
            
            // if you want the app to retrieve location data even in background, use requestAlwaysAuthorization
            // locationManager.requestAlwaysAuthorization()
            return
        }
        
        // at this point the authorization status is authorized
        // request location data once
        locationManager.requestLocation()
        
        // start monitoring location data and get notified whenever there is change in location data / every few seconds, until stopUpdatingLocation() is called
        // locationManager.startUpdatingLocation()
    }
    @IBOutlet weak var temperatura: UILabel!
    @IBOutlet weak var ikona: UIImageView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBAction func Next(_ sender: Any) {
        if curr == 7{
            nextBtn.isEnabled = false
        }
        else{
            curr = curr + 1
            print("Next!")
        }
    }
    @IBOutlet weak var Data: UILabel!
    @IBAction func Prev(_ sender: Any) {
        if curr == -7{ PrevBtn.isEnabled = false }
        else{
            curr = curr - 1
            print("Prev!")
        }
    }
    @IBOutlet weak var PrevBtn: UIButton!
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("location manager authorization status changed")
        
        switch status {
        case .authorizedAlways:
            print("user allow app to get location data when app is active or in background")
        case .authorizedWhenInUse:
            print("user allow app to get location data only when app is active")
        case .denied:
            print("user tap 'disallow' on the permission dialog, cant get location data")
        case .restricted:
            print("parental control setting disallow location data")
        case .notDetermined:
            print("the location permission dialog haven't shown before, user haven't tap allow/disallow")
        }
    }
}

