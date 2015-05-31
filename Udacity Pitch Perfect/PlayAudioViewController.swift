//
//  PlayAudioViewController.swift
//  Udacity Pitch Perfect
//
//  Created by Dilip K Kothamasu on 5/26/15.
//  Copyright (c) 2015 AT&T. All rights reserved.
//

import UIKit
import AVFoundation

class PlayAudioViewController: UIViewController {
    
    var receivedAudio: RecordedAudio!
    var audioPlayer: AVAudioPlayer!
    
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    var audioPlayerNode: AVAudioPlayerNode!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        audioEngine = AVAudioEngine()
        
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func playFast(sender: UIButton) {
        self.playAudioWithRate(2.0)
    }

    @IBAction func playSlow(sender: UIButton) {
        self.playAudioWithRate(0.5)
    }
    
    @IBAction func stopPlay(sender: UIButton) {
        stopAllAudioPlayers()
    }
    
    func playAudioWithRate(rate: Float) {
        stopAllAudioPlayers()
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    func stopAllAudioPlayers() {
        audioPlayer.stop()
        audioPlayer.prepareToPlay()
        audioPlayer.currentTime = 0.0
        
        audioPlayerNode.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    
    @IBAction func playInDarthvaderPitch(sender: UIButton) {
        stopAllAudioPlayers()
        playAudioWithPitch(-1000)
    }
    
    @IBAction func playInChipmunkPitch(sender: UIButton) {
        stopAllAudioPlayers()
        playAudioWithPitch(1000)
    }
    
    func playAudioWithPitch(pitch: Float) {
        stopAllAudioPlayers()
        
        var pitchEffect = AVAudioUnitTimePitch()
        pitchEffect.pitch = pitch
        audioEngine.attachNode(pitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: pitchEffect, format: nil)
        audioEngine.connect(pitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
}
