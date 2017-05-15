//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Ken Moody on 4/25/17.
//  Copyright © 2017 iMoodyStudios. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordButton: UIButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
       stopRecordButton.isEnabled = false
    }
    
    func configureUI(recording: Bool){
        //Set label
        recordingLabel.text =
            recording ? "Recording in progress" : "Tap to Record"
        
        //Set buttons
        recordButton.isEnabled = !recording
        stopRecordButton.isEnabled = recording
    }


    @IBAction func recordAudio(_ sender: Any) {
        configureUI(recording: true) // call method
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    
    
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(recording: false) // call method
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    // MARK: - Audio Recorder Delegate
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            
            let alertController = UIAlertController(
                title: "Houston, we have a problem!",
                message: "Record was not succesful!...Try Again",
                preferredStyle: UIAlertControllerStyle.alert
            )
            
            let cancelAction = UIAlertAction(
                title: "Cancel",
                style: UIAlertActionStyle.destructive) { (action) in
                    // ...
            }
            
            let confirmAction = UIAlertAction(
            title: "OK", style: UIAlertActionStyle.default) { (action) in
                // ...
            }
            
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
        
        print("Record was not succesful!")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

