//
//  RecordSoundViewController.swift
//  PitchPerfect
//
//  Created by DboyLiao on 12/16/15.
//  Copyright © 2015 co.spe3d. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        recordButton.enabled = true
        stopButton.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        // show recoding in progress
        recordButton.hidden = true
        recordButton.enabled = false
        recordLabel.hidden = false
        stopButton.hidden = false
        
        //TODO: save the record
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        
//      //Use Date as name (BAD practice!)
//        let currentDateTime = NSDate()
//        let formatter = NSDateFormatter()
//        formatter.dateFormat = "ddMMyyyy-HHmmss"
//        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        
//      //Use UUID as name (Good one except that you should take care of deleting unneccessary files.)
//        let recordName = NSUUID().UUIDString + ".wav"
        
//      //Use the same name (Good in this application for there should be only one active record.)
        let recordName = "record_voice.wav"
        let filePath = NSURL.fileURLWithPathComponents([dirPath, recordName])
        
        
        // sharedInstance is a singleton which plays an intermediate role between your app and hardware.
        let session = AVAudioSession.sharedInstance()
        
//        let session2 = AVAudioSession.sharedInstance()
//        print("the same?:", session == session2)  // Yes! It is really a singleton.
        
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        print(audioRecorder.url)
        print("recording audio to " + audioRecorder.url.path!)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            recordedAudio = RecordedAudio()
            recordedAudio.filePathURL = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else {
            print("Something goes wrong. The record is not sucessfully saved.")
            
        }
    }

    @IBAction func stopRecord(sender: UIButton) {
        audioRecorder.stop()
        
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
        print("stop recording....")
        
        recordButton.hidden = false
        recordButton.enabled = true
        recordLabel.hidden = true
        stopButton.hidden = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecording" {
            let playSoundVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundVC.receivedAudio = data
        }
    }
}

