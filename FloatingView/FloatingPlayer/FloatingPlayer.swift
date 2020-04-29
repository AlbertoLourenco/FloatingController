//
//  FloatingPlayer.swift
//  FloatingView
//
//  Created by Alberto Lourenço on 1/4/20.
//  Copyright © 2020 Alberto Lourenço. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

protocol FloatingPlayerDelegate {
    
    func playerStoped()
    func playerLoading(loading: Bool)
    func playerPaused(audio: Audio)
    func playerPlaying(audio: Audio)
    func playerFailed(error: AVPlayerItemErrorLog)
}

class FloatingPlayer: UIViewController, FloatingPlayerViewDelegate {
    
    private var playingAudio: Audio?
    private var queue: Array<Audio> = []
    private var delegate: FloatingPlayerDelegate?
    
    private var timer = Timer()
    private var timerDuration = 0
    
    private var isPlaying = false
    private var player: AVPlayer?
    
    private var addedObserves = false
    private var observerRegistered = false
    
    private var vwPlayer: UIView!
    
    private let window = FloatingPlayerWindow()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        
        window.windowLevel = UIWindow.Level(rawValue: CGFloat.greatestFiniteMagnitude)
        window.isHidden = false
        window.rootViewController = self
    }
    
    override func loadView() {
        
        let vwFloating = FloatingPlayerView().loadNib(named: "FloatingPlayerView")
        vwFloating.delegate = self
        vwFloating.sizeToFit()
        vwFloating.frame = CGRect(origin: CGPoint(x: 15, y: UIScreen.main.bounds.height - 120),
                                  size: CGSize(width: UIScreen.main.bounds.width - 30, height: 100))
        vwFloating.clipsToBounds = true
        vwFloating.layer.cornerRadius = 15
        vwFloating.autoresizingMask = []
        
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize.zero
        
        view.addSubview(vwFloating)
        
        self.view = view
        
        self.window.view = vwFloating
    }

    func config(queue: Array<Audio>, delegate: FloatingPlayerDelegate?, customView view: FloatingPlayerView? = nil) {
        
        self.configUI(view: view)
        
        self.queue = queue
        self.delegate = delegate

        let controlCenter = MPRemoteCommandCenter.shared()
        controlCenter.nextTrackCommand.isEnabled = queue.count > 1
//        controlCenter.previousTrackCommand.isEnabled = queue.count > 1
        
        NotificationCenter.default.removeObserver(self)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(stop),
                                               name: Notification.Name(rawValue: "AudioPlayerState_Stop"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleRemoteControl),
                                               name: Notification.Name(rawValue: "AudioPlayerState_Control"),
                                               object: nil)
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    
    private func configUI(view: FloatingPlayerView?) {
        
        if let v = view {
            v.delegate = self
            self.addFloatingPlayerSubview(view: v)
        }else{
            
            let vwFloating = FloatingPlayerView().loadNib(named: "FloatingPlayerView")
            vwFloating.delegate = self
            vwFloating.frame = CGRect(origin: CGPoint(x: 15, y: UIScreen.main.bounds.height - 120),
                                      size: CGSize(width: UIScreen.main.bounds.width - 30, height: 100))
            vwFloating.clipsToBounds = true
            vwFloating.layer.cornerRadius = 15
            
            self.addFloatingPlayerSubview(view: vwFloating)
        }
    }
    
    private func addFloatingPlayerSubview(view: FloatingPlayerView) {

        window.addSubview(view)
        
//        if #available(iOS 13, *) {
//            UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.addSubview(view)
//            UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.bringSubviewToFront(view)
//        }else{
//            UIApplication.shared.keyWindow?.addSubview(view)
//            UIApplication.shared.keyWindow?.bringSubviewToFront(view)
//        }
    }
    
    func reset() {
        
        timer.invalidate()
        timer = Timer()
        
        timerDuration = 0
        
        delegate?.playerStoped()
        
        removePlayerObservers()
        
        player?.pause()
        player = nil
    }
    
    func play() {
        
        if let audio = queue.first {

            if !isPlaying {
                
                isPlaying = true

                let item = AVPlayerItem(url: audio.url)
                player = AVPlayer(playerItem: item)
                player?.volume = 1.0
            }

            player?.play()
            self.delegate?.playerPlaying(audio: audio)

            timer = Timer.scheduledTimer(timeInterval: 1,
                                         target: self,
                                         selector: #selector(updateTimer),
                                         userInfo: nil,
                                         repeats: true)
            
            player?.currentItem?.addObserver(self,
                                             forKeyPath: "playbackLikelyToKeepUp",
                                             options: NSKeyValueObservingOptions(rawValue: 0),
                                             context: nil)
        }
    }
    
    func pause() {
        
        player?.pause()
        
        if let audio = playingAudio {
            self.delegate?.playerPaused(audio: audio)
        }
        
        self.clearLockScreenAlbumInfo()
    }
    
    func seek(to time: Int) {
        
        player?.seek(to: CMTimeMake(value: Int64(time), timescale: 1))
    }
    
    @objc func stop() {
        
        self.delegate?.playerStoped()
        
        countFlag = 0
        player = nil
        playingAudio = nil
        isPlaying = false
        addedObserves = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func removePlayerObservers() {
        
        player?.currentItem?.removeObserver(self,
                                            forKeyPath: "playbackLikelyToKeepUp",
                                            context: nil)
    }
    
    @objc func updateTimer() {
        timerDuration += 1
    }
    
    func eraseTimer() {
        
        timer.invalidate()
        timer = Timer()
        
        timerDuration = 0
    }
    
    func setRadioLockScreenAlbumCover() {
        
//        let albumArt = MPMediaItemArtwork(boundsSize: CGSize.init(width: 300, height: 300)) { (size) -> UIImage in
//            return UIImage(named: "radio-bg-logo-iphone")!
//        }
//        let songInfo: Dictionary<String, Any> = [MPMediaItemPropertyTitle : MCLocalization.string(forKey: "lbl_hallelujah_network"),
//                                                 MPMediaItemPropertyAlbumTitle : MCLocalization.string(forKey: "lbl_live"),
//                                                 MPMediaItemPropertyArtist : MCLocalization.string(forKey: "lbl_family_network"),
//                                                 MPMediaItemPropertyArtwork : albumArt]
//        MPNowPlayingInfoCenter.default().nowPlayingInfo = songInfo
    }
    
    func clearLockScreenAlbumInfo() {
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
    }
    
    var countFlag = 0
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        
        self.eraseTimer()
        
        if let _ = player?.currentItem,
            let _ = object as? AVPlayerItem,
            keyPath == "playbackLikelyToKeepUp" {
            
            if countFlag == 0 {
                
                countFlag = 1
                player?.play()
                isPlaying = true
                
            }else{
                
                if let audio = playingAudio {
                    self.delegate?.playerPlaying(audio: audio)
                }
                
                countFlag = 0
                self.removePlayerObservers()
            }
            
//            if isRadio {
//
//                self.delegate?.playerPlaying()
//
//                countFlag = 0
//                self.removePlayerObservers()
//            }
        }else{
            countFlag = 0
            
            self.handleException()
        }
    }
    
    private func handleException() {
        
        if let error = player?.currentItem?.errorLog() {
            
            self.delegate?.playerFailed(error: error)
        }
    }
    
    @objc func handleRemoteControl(notification: Notification) {
        
        if let event = notification.object as? UIEvent,
            event.type == .remoteControl,
            (event.subtype == .remoteControlTogglePlayPause || event.subtype == .remoteControlPlay || event.subtype == .remoteControlPause) {
            
            if isPlaying {
                self.pause()
            }else{
                self.play()
            }
        }
    }
    
    //-----------------------------------------------------------------------
    //  MARK: - FloatingPlayerView Delegate
    //-----------------------------------------------------------------------
    
    func play(status: Bool) {
        
        if status {
            self.play()
        }else{
            self.pause()
        }
    }
}

private class FloatingPlayerWindow: UIWindow {
    
    var view: FloatingPlayerView?
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let view = view else { return false }
        let viewPoint = convert(point, to: view)
        return view.point(inside: viewPoint, with: event)
    }
}
