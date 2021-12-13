//
//  GameManager.swift
//  carRaceUIKit
//
//  Created by Vadim Zhuravlenko on 31.07.21.
//

import Foundation
import UIKit

class Game {
    
    var delegate: GameDelegate?
    let view = UIView()
    var stopEverything = true
    var countDown: Int = 1
    var score = 0
    
    var mainCar = Car(health: 100)
    
    let objects = [Object(damage: 20, name: "rock"), Object(damage: 30, name: "greenCar"), Object(damage: 30, name: "orangeCar"), Object(damage: 20, name: "tree")]
    
    var trafficObjects = [Object]()
    
    
    func randomTrafficObject() -> Object? {
        guard let randomObject = objects.randomElement() else { return nil }
        
        self.trafficObjects.append(randomObject)
        
        return randomObject
    }
    
    @objc func randomTraffic() {
        guard let randomObject = self.randomTrafficObject() else { return }
        
        delegate?.showTrafficObject(randomObject)
    }
    
    @objc func moveTraffic() {
        for _ in self.trafficObjects {
            delegate?.moveTrafficObject()
        }
    }
    
}
