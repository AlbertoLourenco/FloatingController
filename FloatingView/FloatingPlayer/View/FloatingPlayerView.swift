//
//  FloatingPlayerView.swift
//  FloatingView
//
//  Created by Alberto Lourenço on 3/17/20.
//  Copyright © 2020 Alberto Lourenço. All rights reserved.
//

import UIKit

protocol FloatingPlayerViewDelegate {
    
    func play(status: Bool)
}

class FloatingPlayerView: UIView {
    
    var isPlaying: Bool = false
    var delegate: FloatingPlayerViewDelegate?
    
    @IBOutlet var lblTitle: UILabel?
    @IBOutlet var lblSubtitle: UILabel?
    @IBOutlet var pvProgress: UIProgressView?
    @IBOutlet var btnPlayPause: UIButton?
    
    func loadNib(named: String) -> FloatingPlayerView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: named, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! FloatingPlayerView
    }
    
    @IBAction func playPause() {
        
        if isPlaying {
            self.btnPlayPause?.setImage(UIImage(systemName: "play.circle"), for: .normal)
        }else{
            self.btnPlayPause?.setImage(UIImage(systemName: "pause.circle"), for: .normal)
        }
        
        isPlaying = !isPlaying
        self.delegate?.play(status: isPlaying)
    }
}
