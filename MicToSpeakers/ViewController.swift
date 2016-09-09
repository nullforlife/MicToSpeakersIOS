//
//  ViewController.swift
//  MicToSpeakers
//
//  Created by Oskar Jönsson on 2016-09-09.
//  Copyright © 2016 Oskar Jönsson. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate, AVCaptureAudioDataOutputSampleBufferDelegate {
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var captureSession: AVCaptureSession!
    var microphone: AVCaptureDevice!
    var inputDevice: AVCaptureDeviceInput!
    var outputDevice: AVCaptureAudioDataOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do{
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setMode(AVAudioSessionModeVoiceChat)
            try recordingSession.setPreferredSampleRate(44000.00)
            try recordingSession.setPreferredIOBufferDuration(0.2)
            try recordingSession.setActive(true)
            
            recordingSession.requestRecordPermission() { [unowned self] (allowed: Bool) -> Void in
                DispatchQueue.main.async {
                    if allowed {
                        
                        do{
                            self.microphone = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)
                            try self.inputDevice = AVCaptureDeviceInput.init(device: self.microphone)
                            
                            self.outputDevice = AVCaptureAudioDataOutput()
                            self.outputDevice.setSampleBufferDelegate(self, queue: DispatchQueue.main)
                            
                            self.captureSession = AVCaptureSession()
                            self.captureSession.addInput(self.inputDevice)
                            self.captureSession.addOutput(self.outputDevice)
                            self.captureSession.startRunning()
                        }
                        catch let error {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        
        var audioBufferList = AudioBufferList(
            mNumberBuffers: 1,
            mBuffers: AudioBuffer(mNumberChannels: 0,
                                  mDataByteSize: 0,
                                  mData: nil)
        )
        
        var blockBuffer: CMBlockBuffer?
        
        var osStatus = CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(
            
            sampleBuffer,
            nil,
            &audioBufferList,
            MemoryLayout<AudioBufferList>.size,
            nil,
            nil,
            UInt32(kCMSampleBufferFlag_AudioBufferList_Assure16ByteAlignment),
            &blockBuffer
        )
        
        do {
            var data: NSMutableData = NSMutableData.init()
            for i in 0..<audioBufferList.mNumberBuffers {
                
                var audioBuffer = AudioBuffer(
                    mNumberChannels: audioBufferList.mBuffers.mNumberChannels,
                    mDataByteSize: audioBufferList.mBuffers.mDataByteSize,
                    mData: audioBufferList.mBuffers.mData
                )
                
                let frame = audioBuffer.mData?.load(as: Float32.self)
                data.append(audioBuffer.mData!, length: Int(audioBuffer.mDataByteSize))
                
            }
            
            var dataFromNsData = Data.init(referencing: data)
            var avAudioPlayer: AVAudioPlayer = try AVAudioPlayer.init(data: dataFromNsData)
            avAudioPlayer.prepareToPlay()
            avAudioPlayer.play()
        }
        catch let error {
            print(error.localizedDescription)
            //prints out The operation couldn’t be completed. (OSStatus error 1954115647.)
        }
    }
}
