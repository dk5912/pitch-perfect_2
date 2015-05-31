//
//  RecordAudioViewController.swift
//  Udacity Pitch Perfect
//
//  Created by Dilip K Kothamasu on 5/26/15.
//  Copyright (c) 2015 AT&T. All rights reserved.
//
// Future changes
//  1. Can do away the changes with only two buttons. 
//     Intially show pause image, once tapped, change to resume image.
//     When resume image is tapped then change to pause image.
//     Record and Pause can be performed based on the image of the button


import UIKit
import AVFoundation


class RecordAudioViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet var stopBtn: UIButton!
    @IBOutlet var recordingLbl: UILabel!
    @IBOutlet var recordBtn: UIButton!
    @IBOutlet var resumeBtn: UIButton!
    @IBOutlet var pauseBtn: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        resetAllComponents()
    }
    
    func resetAllComponents() {
        recordBtn.enabled = true
        recordingLbl.text = "Tap to Record"
        stopBtn.hidden = true
        pauseBtn.hidden = true
        resumeBtn.hidden = true
    }


    @IBAction func startAudioRecording(sender: UIButton) {
        /*
         * When microphone button is tapped
            1. Show Stop button
            2. Show pause button but enable it
            3. Show resume button but disable it
         */
        
        recordBtn.enabled = false
        recordingLbl.text = "Recording in progress..."
        stopBtn.hidden = false
        pauseBtn.hidden = false
        
        resumeBtn.enabled = false
        resumeBtn.hidden = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()        
    }
    
    @IBAction func pauseAudioRecording(sender: UIButton) {
        /*
        * When microphone button is tapped
            1. No change to Stop button
            2. Disable Pause button
            3. Enable Resume button
            4. Pause the audio recording.
        */
        
        pauseBtn.enabled = false
        resumeBtn.enabled = true
        
        audioRecorder.pause()
        recordingLbl.text = "Recording is paused."
    }
    
    @IBAction func resumeAudioRecording(sender: UIButton) {
        /*
        * When microphone button is tapped
            1. No change to Stop button
            2. Enable Pause button
            3. Disable Resume button
            4. Resume the audio recording.
        */
        
        pauseBtn.enabled = true
        resumeBtn.enabled = false
        
        audioRecorder.record()
        recordingLbl.text = "Recording in progress..."
    }
    
    @IBAction func stopAudioRecording(sender: UIButton) {
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag) {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            let alert = UIAlertView()
            alert.title = "Alert"
            alert.message = "There was an issue in recording audio. Please try again."
            alert.addButtonWithTitle("OK")
            alert.show()
            resetAllComponents()
        }
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording") {
            let playAudioVC:PlayAudioViewController = segue.destinationViewController as! PlayAudioViewController
            
            let data = sender as! RecordedAudio
            playAudioVC.receivedAudio = data
        }
    }
}