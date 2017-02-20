//
//  ViewController.swift
//  Colors
//
//  Created by David de Tena on 20/02/2017.
//  Copyright © 2017 David de Tena. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var btnSwitch: UIButton!
    @IBOutlet weak var imgKnobBase: UIImageView!
    @IBOutlet weak var imgKnob: UIImageView!
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgKnob.isHidden = true
        imgKnobBase.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        btnSwitch.setImage(#imageLiteral(resourceName: "img_switch_off"), for: .normal)
        btnSwitch.setImage(UIImage(named:"img_switch_on"), for: .selected)
    }
    
    
    @IBAction func btnSwitchPressed(_ sender: UIButton) {
        btnSwitch.isSelected = !btnSwitch.isSelected
        
        if btnSwitch.isSelected {
            // Show imgKnob
            imgKnob.isHidden = false
            imgKnobBase.isHidden = false
            view.backgroundColor = UIColor(hue: 0.5, saturation: 0.5, brightness: 0.75, alpha: 1.0)
        }
        else{
            // Dark gray background
            view.backgroundColor = UIColor(hue: 0.5, saturation: 0, brightness: 0.2, alpha: 1.0)
            imgKnob.isHidden = true
            imgKnobBase.isHidden = true
        }
    }
}

