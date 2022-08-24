//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    var counter: Int? = nil
    var timer = Timer()
    var originalTime: Int?
    var AudioPlayer: AVAudioPlayer?
    enum sounds { case alarm, cowbell }
    var lastSound: sounds = sounds.cowbell


    @IBOutlet weak var BackgroundColor: UIControl!
    @IBOutlet weak var TimerStartValue: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TimerStartValue.keyboardType = .decimalPad
        TimerStartValue.text = "5"
        TimerStartValue.textAlignment = .center
        setColors(color: .black)
        TimerStartValue.textColor = .white
    }
    
    @IBAction func startTimer(_ sender: Any) {
        if (lastSound == sounds.alarm && AudioPlayer != nil) {
            if (AudioPlayer!.isPlaying) {
                AudioPlayer?.stop()
                setColors(color: .black)
                TimerStartValue.textColor = .white
                TimerStartValue.text = String(originalTime ?? 5)
                return
            }
        }
        TimerStartValue.isEnabled = false
        if (!timer.isValid) {
            originalTime = Int(TimerStartValue.text!) ?? 5
        }
        TimerStartValue.textColor = .black
        counter = originalTime
        TimerStartValue.text = String(counter!)
        setColors(color: .green)
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounter() {
        if counter! > 1 {
            if (counter! == 3 || counter! == 2) {
                lastSound = sounds.cowbell
                playSound(sound: "cowbell")
                setColors(color: .orange)
            }
            print("\(counter!) seconds remaining")
            counter! -= 1
            TimerStartValue.text = String(counter!)
        }
        else {
            TimerStartValue.text = "0"
            playSound(sound: "alarm_sound")
            lastSound = sounds.alarm
            setColors(color: .red)
            timer.invalidate()
            TimerStartValue.isEnabled = true
        }
    }
    
    func playSound(sound: String) {
        let soundFileURL = Bundle.main.url(
            forResource: sound, withExtension: "mp3")
        do {
            AudioPlayer = try AVAudioPlayer(contentsOf: soundFileURL!)
            AudioPlayer?.delegate = self
        }
        catch {
            print("peepee")
        }
        AudioPlayer?.play()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if (lastSound == sounds.alarm) {
            setColors(color: .black)
            TimerStartValue.text = String(originalTime ?? 5)
            TimerStartValue.textColor = .white
        }
    }
    
    func setColors(color: UIColor) {
        view.backgroundColor = color
        TimerStartValue.backgroundColor = color
    }
}


