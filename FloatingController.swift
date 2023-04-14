//
//  FloatingController.swift
//  FloatingController
//
//  Created by Alberto Lourenço on 1/4/20.
//  Copyright © 2020 Alberto Lourenço. All rights reserved.
//

import UIKit

fileprivate struct FUIContants {
    static let height: CGFloat = 65
    static let padding: CGFloat = 20
}

final class FloatingController: UIViewController {
    
    private let window = FloatingControllerWindow()
    private lazy var vwFloating: UIView = {
        return placeholderView()
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        window.windowLevel = UIWindow.Level(rawValue: CGFloat.greatestFiniteMagnitude)
        window.isHidden = false
        window.rootViewController = self
    }
    
    func config(view customView: UIView? = nil,
                size: CGSize = .zero) {
        
        if let view = customView {
            vwFloating = view
        }
        window.addSubview(vwFloating)
        
        let customSize = size != .zero ? size : CGSize(width: (UIScreen.main.bounds.width - (FUIContants.padding * 2)),
                                                       height: FUIContants.height)
        
        let frame = calculateFrame(size)
        
        vwFloating.frame = CGRect(origin: CGPoint(x: (UIScreen.main.bounds.width - customSize.width) / 2,
                                                  y: UIScreen.main.bounds.height),
                                  size: customSize)
        
        UIView.animate(withDuration: 0.8,
                       delay: 1,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0.6) { [weak self] in
            guard let self = self else { return }
            self.vwFloating.alpha = 1
            self.vwFloating.frame = frame
        }
    }
    
    private func placeholderView() -> UIView {
        
        let view = UIView()
        view.alpha = 0
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.backgroundColor = .systemPink
        
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        label.textAlignment = .center
        label.text = "Your custom view here."
        label.frame = CGRect(origin: .zero,
                             size: CGSize(width: UIScreen.main.bounds.width - (FUIContants.padding * 2),
                                          height: FUIContants.height))
        
        view.addSubview(label)
        
        return view
    }
    
    private func calculateFrame(_ customSize: CGSize = .zero) -> CGRect {
        
        let width = customSize != .zero ? customSize.width : UIScreen.main.bounds.width - (FUIContants.padding * 2)
        
        var size = CGSize(width: width,
                          height: FUIContants.height)
        if customSize != .zero {
            size = customSize
        }
        
        let point = CGPoint(x: (UIScreen.main.bounds.width - size.width) / 2,
                            y: UIScreen.main.bounds.height - (size.height + window.safeAreaInsets.bottom))
        
        return CGRect(origin: point, size: size)
    }
}

fileprivate final class FloatingControllerWindow: UIWindow {
    
    var view: UIView?
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate override func point(inside point: CGPoint,
                                    with event: UIEvent?) -> Bool {
        guard let view = view else { return false }
        let viewPoint = convert(point, to: view)
        return view.point(inside: viewPoint, with: event)
    }
}
