//
//  Audio.swift
//  FloatingView
//
//  Created by Alberto Lourenço on 3/17/20.
//  Copyright © 2020 Alberto Lourenço. All rights reserved.
//

import Foundation

struct Audio {
    
    var url: URL
    var title: String
    var subtitle: String
    var stream: Bool
    var duration: Int = 0
}

extension Audio: Equatable {
    static public func ==(first: Audio, second: Audio) -> Bool {
        return first.url == second.url
    }
}
