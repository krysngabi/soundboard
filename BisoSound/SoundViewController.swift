//
//  SoundViewController.swift
//  BisoSound
//
//  Created by Krys Ngabi on 6/16/20.
//  Copyright © 2020 Krys Ngabi. All rights reserved.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var playOutlet: UIButton!
    var audioRecorder : AVAudioRecorder? = nil
    var audioPlayer : AVAudioPlayer?
    var audioURL : URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpRecorder()
        
        playOutlet.isEnabled = false
        addButton.isEnabled = false
        

        // Do any additional setup after loading the view.
    }
    
    
    func setUpRecorder(){
        //Create an audio Session
        do {
            
        
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(AVAudioSession.Category.playAndRecord)
        try session.overrideOutputAudioPort(.speaker)
        try session.setActive(true)
        
        //Create URL for the audio file
        
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath,"audio.m4a"]
             audioURL = NSURL.fileURL(withPathComponents: pathComponents)
             print("##############################")
             print(audioURL)
             print("##############################")
            
        //Create Settings for the audio Recorder
            
            var settings : [String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject
            settings[AVSampleRateKey] = 44100.0 as AnyObject
            settings[AVNumberOfChannelsKey] = 2 as AnyObject
            
        // Create AudioRecorder object
        
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder?.prepareToRecord()
    }catch let error as NSError{
        print(error)
    }
    
    }

    
    @IBAction func recordTapped(_ sender: Any) {
        
        if audioRecorder!.isRecording {
            //stop the recording
            audioRecorder?.stop()
            recordButton.setTitle("Record", for: .normal)
            //change button title to Record
            playOutlet.isEnabled = true
            addButton.isEnabled = true
        } else {
            //start the recording
            audioRecorder?.record()
            recordButton.setTitle("Stop", for: .normal)
            //change button title to stop
        }
    }
    
    @IBAction func playTapped(_ sender: Any) {
        do {
        audioPlayer = try  AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer?.play()
        } catch {
            
        }
        }
    
    @IBAction func addTapped(_ sender: Any) {
        let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let sound = Sound(context:context)
        
        sound.name = txtName.text
        sound.audio = NSData(contentsOf: audioURL!) as Data?
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        txtName.text = ""
        navigationController?.popViewController(animated: true)
        
              
    }
    
}
