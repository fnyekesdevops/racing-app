//
//  GameMenu.swift
//  carRaceUIKit
//
//  Created by Vadim Zhuravlenko on 29.07.21.
//

import UIKit

class GameMenu: UIViewController {
    
    var countDown: Int = 1
    var stopEverything: Bool = true
    
    
    @IBOutlet weak var BestScore: UILabel!
    @IBOutlet weak var startGameButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startGameButton.addShadow(radius: 5, color: .green)
        startGameButton.addCornerRadius(20)
        startGameButton.addGradient(colors: [UIColor.yellow.cgColor, UIColor.purple.cgColor], locations: [0.2, 0.7])
        BestScore.text = "Best score: \(UserSettings.score!)"
    }
    
    
    @IBAction func startGameButton(_ sender: Any) {
        
        let gameScene = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameSceneViewController")
        self.navigationController?.pushViewController(gameScene, animated: false)
    }
    
    
    
    
}
