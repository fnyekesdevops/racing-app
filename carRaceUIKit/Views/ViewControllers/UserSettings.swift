//
//  UserSettings.swift
//  carRaceUIKit
//
//  Created by Vadim Zhuravlenko on 10.08.21.
//

import Foundation


final class UserSettings {
    
    private enum SettingsKeys: String {
        case score
    }
    
    static var score: Int! {
        get {
            return UserDefaults.standard.integer(forKey: SettingsKeys.score.rawValue)
        } set {
            let defaults = UserDefaults.standard
            let key = SettingsKeys.score.rawValue
            if let score = newValue {
                defaults.set(score, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
}
