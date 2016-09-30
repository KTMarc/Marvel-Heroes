//
//  TextPresentable.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 30/9/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import UIKit

protocol TextPresentable {
    var text: String { get }
    var textColor: UIColor { get }
    var font: UIFont { get }
}
