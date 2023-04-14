//
//  ViewController.swift
//  Demo
//
//  Created by Alberto Lourenço on 1/4/20.
//  Copyright © 2020 Alberto Lourenço. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    let floating = FloatingController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //--------------------------------
        //  Placeholder view
        //--------------------------------
        
        floating.config()
        
        //--------------------------------
        //  Custom view
        //--------------------------------
        
//        let customView = UIView()
//        customView.backgroundColor = .yellow
//
//        floating.config(view: customView,
//                        size: CGSize(width: 220, height: 90))
    }
}
