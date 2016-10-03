//
//  ViewController.swift
//  MicToSpeakers
//
//  Created by Oskar Jönsson on 2016-09-09.
//  Copyright © 2016 Oskar Jönsson. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    var engine = AVAudioEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let input = engine.inputNode!
        let mixer = engine.mainMixerNode
        
        
        let bus = 0
        let inputFormat = input.inputFormat(forBus: bus)
        engine.connect(input, to: mixer, format: inputFormat)
        
        try! engine.start()

    }
}
