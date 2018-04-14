//
//  FirstViewController.swift
//  Music App
//
//  Created by Piyotr Kao on 2018-04-13.
//  Copyright © 2018 Piyotr Kao. All rights reserved.
//

import UIKit
import AVFoundation

var songs:[String] = []
var audioPlayer = AVAudioPlayer()
var thisSong = 0
var audioPlaying = false
var synthesizer = AVSpeechSynthesizer()

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AVSpeechSynthesizerDelegate {
    
    @IBOutlet weak var songTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = songs[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do
        {
            let audioPath = Bundle.main.path(forResource: songs[indexPath.row], ofType: ".mp3")
            try audioPlayer = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
            thisSong = indexPath.row
            audioPlayer.enableRate = true
            audioPlaying = true
            let utterance = AVSpeechUtterance(string: songs[thisSong])
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            synthesizer.speak(utterance)
        }
        catch
        {
            print("Table tap error!")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        synthesizer.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        getSongsByName()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getSongsByName()
    {
        print("hello")
        let folderUrl = URL(fileURLWithPath: Bundle.main.resourcePath!)
        do
        {
            let songPath = try FileManager.default.contentsOfDirectory(at: folderUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            
            for song in songPath
            {
                var mySong = song.absoluteString
                
                if mySong.contains(".mp3")
                {
                    let findString = mySong.components(separatedBy: "/")
                    mySong = findString[findString.count-1]
                    mySong = mySong.replacingOccurrences(of: "%20", with: " ")
                    mySong = mySong.replacingOccurrences(of: ".mp3", with: "")
                    songs.append(mySong)
                }
            }
            
            songTableView.reloadData()
        }
        catch
        {
            
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        audioPlayer.play()
    }
}

