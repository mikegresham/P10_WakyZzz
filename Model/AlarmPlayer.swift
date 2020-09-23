//
//  AlarmPlayer.swift
//  WakyZzz
//
//  Created by Michael Gresham on 23/09/2020.
//  Copyright © 2020 Olga Volkova OC. All rights reserved.
//

import Foundation
import AVFoundation

enum AlarmSound: String {
    case low = "alarm_low"
    case high = "alarm_high"
    case evil = "alarm_evil"
}

class AlarmPlayer {
    
    var player: AVAudioPlayer?

    func playSound(_ soundName: AlarmSound) {
        guard let url = Bundle.main.url(forResource: soundName.rawValue, withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            player.numberOfLoops = 10
            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stopSound() {
        player?.stop()
    }
    
}
