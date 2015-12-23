//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by DboyLiao on 12/20/15.
//  Copyright © 2015 co.spe3d. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var darthvaderButton: UIButton!
    
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let audioPath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3")
        let audioPath = receivedAudio.filePathURL?.path
        print("audioPath: ", audioPath)
        
        if let path = audioPath {
            let pathURL = NSURL(fileURLWithPath: path)
            audioPlayer = try! AVAudioPlayer(contentsOfURL: pathURL)
            audioPlayer.enableRate = true
        } else {
            print("No audio file found.")
        }
        audioEngine = AVAudioEngine()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func playWithPitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let unitTimePitch = AVAudioUnitTimePitch()
        let player = AVAudioPlayerNode()
        let audioFile = try! AVAudioFile(forReading: receivedAudio.filePathURL)
        unitTimePitch.pitch = pitch
        audioEngine.attachNode(player)
        audioEngine.attachNode(unitTimePitch)
        
        audioEngine.connect(player, to: unitTimePitch, format: nil)
        audioEngine.connect(unitTimePitch, to: audioEngine.outputNode, format: nil)
        
        player.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        do {
            try audioEngine.start()
            player.play()    // non-blocking playing.
        } catch {
            print("Something goes wrong! %@", error)
        }
    }
    
    func playAudio(audioPlayer: AVAudioPlayer?, rate: Float = 1.0){
        if let audioPlayer = audioPlayer {
            audioPlayer.stop()
            audioPlayer.currentTime = 0.0
            audioPlayer.rate = rate
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        }
    }
    
    @IBAction func playSnail(sender: UIButton) {
        self.playAudio(audioPlayer, rate: 0.5)
    }
    
    @IBAction func playFast(sender: UIButton) {
        self.playAudio(audioPlayer, rate: 1.5)
    }
    
    @IBAction func playChipmunk(sender: UIButton) {
        self.playWithPitch(1000.0)
    }
    
    @IBAction func playDarthvader(sender: UIButton) {
        self.playWithPitch(-750.0)
    }
    
    @IBAction func stopPlay(sender: UIButton) {
        if let audioPlayer = audioPlayer {
            audioPlayer.stop()
            audioPlayer.currentTime = 0
        }
        audioEngine.stop()
    }
}
