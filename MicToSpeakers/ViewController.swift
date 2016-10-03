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
    var recordingSession = AVAudioSession.sharedInstance()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        try! recordingSession.setMode(AVAudioSessionModeVoiceChat)
        try! recordingSession.setActive(true)
        try! recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try! recordingSession.setPreferredSampleRate(8000) // Human voice can only make sounds at this samplerate
        
        let input = engine.inputNode!
        let mixer = engine.mainMixerNode
        
        
        let bus = 0
        let inputFormat = input.inputFormat(forBus: bus)
        engine.connect(input, to: mixer, format: inputFormat)
        
        try! engine.start()

    }
}
