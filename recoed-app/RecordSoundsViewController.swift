//
//  RecordSoundsViewController.swift
//  recoed-app
//
//  Created by  ashwaq marzouq on 10/06/1444 AH.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController  , AVAudioRecorderDelegate{
    
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var stoprecord: UIButton!
    @IBOutlet weak var taplabel: UILabel!
    @IBOutlet weak var recordbutton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        stoprecord.isEnabled=false
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "stopRecording" {
                let playSounds = segue.destination as! PlaySoundsViewController
                let recorAudioURL = sender as! URL
                playSounds.recordedAudioURL = recorAudioURL
            }
        }
    

    @IBAction func recoredAudio(_ sender: Any) {
       
        configureUI(enableRecording: true)
        
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))

        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate=self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stoprecording(_ sender: Any) {
        taplabel.text="tap to recored"
        recordbutton.isEnabled=true
        stoprecord.isEnabled=false
        audioRecorder.stop()
           let audioSession = AVAudioSession.sharedInstance()
           try! audioSession.setActive(false)
        
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            performSegue(withIdentifier:"stopRecording", sender: audioRecorder.url)
        }else {print ("print was not successful")}
    }
    
    func configureUI(enableRecording: Bool)
    {
        recordbutton.isEnabled = !enableRecording
        stoprecord.isEnabled = enableRecording
        taplabel.text = enableRecording ? "Recording in Progress" : "Tap to Record"
    }


}

