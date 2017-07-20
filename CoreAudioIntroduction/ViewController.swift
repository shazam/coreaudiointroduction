//
//  ViewController.swift
//  CoreAudioIntroduction
//
//  Created by Nikita.Kardakov on 20/07/2017.
//  Copyright © 2017 Shazam. All rights reserved.
//

import Cocoa
import AVFoundation

class ViewController: NSViewController {

    let audioEngine = AVAudioEngine()
    let playerNode = AVAudioPlayerNode()
    let delayNode = AVAudioUnitDelay()
    let distortionNode = AVAudioUnitDistortion()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioEngine.attach(playerNode)
        audioEngine.attach(delayNode)
        audioEngine.attach(distortionNode)
        
        let audioFileURL = Bundle.main.url(forResource: "cow", withExtension: "caf")
        guard let audioFile = try? AVAudioFile(forReading: audioFileURL!) else {
            print("Can't open this file")
            return
        }
        
        audioEngine.connect(playerNode, to: delayNode, format: audioFile.processingFormat)
        audioEngine.connect(delayNode, to: distortionNode, format: audioFile.processingFormat)
        audioEngine.connect(distortionNode, to: audioEngine.mainMixerNode, format: audioFile.processingFormat)
        
        do {
            try audioEngine.start()
            playerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
            playerNode.play()
        } catch {
            print("Can't start audio engine.")
        }
    }
}

