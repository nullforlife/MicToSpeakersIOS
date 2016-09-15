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
        let player = AVAudioPlayerNode()
        engine.attachNode(player)
        
        
        let bus = 0
        let inputFormat = input.inputFormatForBus(bus)
        engine.connect(player, to: engine.mainMixerNode, format: inputFormat)
        
        input.installTap(onBus: bus, bufferSize: 2048, format: inputFormat, block: {
            (buffer: AVAudioPCMBuffer!, time: AVAudioTime!) -> Void in
            
            let audioBuffer = self.typetobinary(buffer)
            stream.write(audioBuffer, maxLength: audioBuffer.count)
        })

    
        try! engine.start()
        player.play()
    }
}