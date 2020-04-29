//
//  FloatingViewController.swift
//  FloatingView
//
//  Created by Alberto Lourenço on 4/28/20.
//  Copyright © 2020 Alberto Lourenço. All rights reserved.
//

import UIKit

class FloatingViewController: UIViewController {

    private(set) var button: UIButton!
    
    private let window = FloatingWindow()

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
        
        let button = UIButton(type: .custom)
        button.setTitle("Floating", for: .normal)
        button.setTitleColor(UIColor.green, for: .normal)
        button.backgroundColor = UIColor.white
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.8
        button.layer.shadowOffset = CGSize.zero
        button.sizeToFit()
        button.frame = CGRect(origin: CGPoint(x: (UIScreen.main.bounds.width - button.bounds.size.width) / 2,
                                              y: ((UIScreen.main.bounds.height - button.bounds.size.height) / 2)),
                              size: button.bounds.size)
        button.autoresizingMask = []
        
        let view = UIView()
        view.addSubview(button)
        self.view = view
        
        self.button = button
        
        window.button = button
    }

//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//    }
}

private class FloatingWindow: UIWindow {
    
    var button: UIButton?

    init() {
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let button = button else { return false }
        let buttonPoint = convert(point, to: button)
        return button.point(inside: buttonPoint, with: event)
    }
}
