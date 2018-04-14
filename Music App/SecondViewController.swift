//
//  SecondViewController.swift
//  Music App
//
//  Created by Piyotr Kao on 2018-04-13.
//  Copyright © 2018 Piyotr Kao. All rights reserved.
//

import UIKit
import AVFoundation

class SecondViewController: UIViewController {
    var speed:[Float] = [1.0, 2.0, 0.5]
    
    var currentSpeed = 0;
    
    @IBOutlet weak var label_songName: UILabel!
    @IBOutlet weak var songImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var speedButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationTimeLabel: UILabel!
    
    @IBAction func Play(_ sender: Any) {
        if !audioPlayer.isPlaying
        {
            audioPlayer.play()
            changePlayButtonTitle()
        }
        else
        {
            audioPlayer.pause()
            changePlayButtonTitle()
        }
    }
    
    @IBAction func speed(_ sender: Any) {
        if (currentSpeed < speed.count - 1)
        {
            currentSpeed += 1
        }
        else
        {
            currentSpeed = 0
        }
        audioPlayer.rate = speed[currentSpeed]
        audioPlayer.stop()
        audioPlayer.play()
        speedButton.setTitle(String(format: "x%.1f", speed[currentSpeed]), for: .normal)
    }
    
    @IBAction func prev(_ sender: Any) {
        if thisSong >= 1
        {
            playSong(songToPlay: songs[thisSong - 1])
            thisSong -= 1
            label_songName.text = songs[thisSong]
        }
    }
    
    @IBAction func next(_ sender: Any) {
        if thisSong < songs.count - 1
        {
            playSong(songToPlay: songs[thisSong + 1])
            thisSong += 1
            label_songName.text = songs[thisSong]
        }
    }
    
    @IBAction func sliderVolume(_ sender: UISlider) {
        audioPlayer.volume = sender.value
    }
    
    func playSong(songToPlay: String)
    {
        do
        {
            let audioPath = Bundle.main.path(forResource: songToPlay, ofType: ".mp3")
            try audioPlayer = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
            audioPlayer.enableRate = true
            
            let utterance = AVSpeechUtterance(string: songToPlay)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            synthesizer.speak(utterance)
            
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateAudioProgressView), userInfo: nil, repeats: true)
            progressView.setProgress(Float(audioPlayer.currentTime/audioPlayer.duration), animated: false)
            
            durationTimeLabel.text = audioPlayer.duration.description
            currentTimeLabel.text = audioPlayer.currentTime.description
        }
        catch
        {
            print("Table tap error!")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if audioPlaying {
            playButton.isEnabled = true;
            speedButton.isEnabled = true;
            prevButton.isEnabled = true;
            nextButton.isEnabled = true;
            volumeSlider.isEnabled = true;
            
            changePlayButtonTitle()
            label_songName.text = songs[thisSong]
            
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateAudioProgressView), userInfo: nil, repeats: true)
            progressView.setProgress(Float(audioPlayer.currentTime/audioPlayer.duration), animated: false)
        }
        else
        {
            playButton.isEnabled = false;
            speedButton.isEnabled = false;
            prevButton.isEnabled = false;
            nextButton.isEnabled = false;
            volumeSlider.isEnabled = false;
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changePlayButtonTitle()
    {
        if !audioPlayer.isPlaying
        {
            playButton.setTitle("Play", for: .normal)
        }
        else
        {
            playButton.setTitle("Pause", for: .normal)
        }
    }
    
    @objc func updateAudioProgressView()
    {
        if audioPlayer.isPlaying
        {
            // Update progress
            progressView.setProgress(Float(audioPlayer.currentTime/audioPlayer.duration), animated: true)
            currentTimeLabel.text = audioPlayer.currentTime.description
        }
    }


}

