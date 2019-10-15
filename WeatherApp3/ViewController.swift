//
//  ViewController.swift
//  WeatherApp3
//
//  Created by Student on 15.10.2019.
//  Copyright © 2019 Student. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var curr = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        temperatura.text = "Temp"
        
        let url = URL(string: "/static/img/weather/png/64/hr.png")!
        
        let session = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in DispatchQueue.main.async {
            
            if error == nil && data != nil {
                self.ikona.image = UIImage(data: data!)
            }
            }}
        )
        

        session.resume()
        nextBtn.isEnabled = true
        
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

