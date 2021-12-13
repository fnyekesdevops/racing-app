//
//  GameDelegate.swift
//  carRaceUIKit
//
//  Created by Vadim Zhuravlenko on 3.08.21.
//

import UIKit

protocol GameDelegate {
    func showTrafficObject(_ object: Object)
    func moveTrafficObject()
}
