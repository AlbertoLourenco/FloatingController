//
//  ViewController.swift
//  FloatingView
//
//  Created by Alberto Lourenço on 1/4/20.
//  Copyright © 2020 Alberto Lourenço. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, FloatingPlayerDelegate {
    
    //-----------------------------------------------------------------------
    //  MARK: - UIViewController
    //-----------------------------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        let audio = Audio(url: Bundle.main.url(forResource: "audio", withExtension: "mp3")!,
                          title: "Lorem Ipsum",
                          subtitle: "dolor sit amet",
                          stream: false)

        let player = FloatingPlayer()
        player.config(queue: [audio], delegate: self)
    }

    //-----------------------------------------------------------------------
    //  MARK: - FloatingPlayer Delegate
    //-----------------------------------------------------------------------

    func playerStoped() {

    }

    func playerLoading(loading: Bool) {

    }

    func playerPaused(audio: Audio) {

    }

    func playerPlaying(audio: Audio) {

    }

    func playerFailed(error: AVPlayerItemErrorLog) {

    }
}
