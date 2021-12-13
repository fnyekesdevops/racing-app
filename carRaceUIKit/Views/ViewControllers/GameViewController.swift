//
//  ViewController.swift
//  carRaceUIKit
//
//  Created by Vadim Zhuravlenko on 29.07.21.
//

import UIKit

class ViewController: UIViewController {

    private var game = Game()
    
    
    @IBOutlet weak var leftRoad: UIView!
    @IBOutlet weak var rightRoad: UIView!
    @IBOutlet weak var blueCar: UIImageView?
    @IBOutlet weak var centerRoad: UIStackView!
    
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    
    @IBOutlet weak var centerRoadTopCOnstraint: NSLayoutConstraint!
    
    var countDown: Int = 1
    var trafficObjects = [UIImageView]()
    var score = 0
    
    private var countdownTimer: Timer?
    private var randomtrafficTimer: Timer?
    private var movetrafficTimer: Timer?
    private var moveroadTimer: Timer?
    private var ifInterserctsTimer: Timer?
    private var checkScoreTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        game.delegate = self
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(moveCar(_:)))
        blueCar?.isUserInteractionEnabled = true
        blueCar?.addGestureRecognizer(panGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        countdownTimer = Timer.scheduledTimer(timeInterval: TimeInterval(1),
                                              target: self,
                                              selector: #selector(startCountDown),
                                              userInfo: nil,
                                              repeats: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        stopTimers()
    }
    
    
    @objc func moveCar(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .began || gesture.state == .changed {
            let translation = gesture.translation(in: gesture.view)
            let changeX = (gesture.view?.center.x)! + translation.x
            let changeY = (gesture.view?.center.y)! + translation.y
            gesture.view?.center = CGPoint(x: changeX, y: changeY)
            gesture.setTranslation(CGPoint.zero, in: gesture.view)
        }
    }
    
    
    @objc func startCountDown() {
    let countDownLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        countDownLabel.center = self.view.center
        countDownLabel.textAlignment = .center
        countDownLabel.text = String(countDown)
        countDownLabel.textColor = UIColor.green
        countDownLabel.font = UIFont(name: "AvenirNext-Bold", size: 200)
        view.addSubview(countDownLabel)
        
        let deadTime = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: deadTime, execute: {
            countDownLabel.removeFromSuperview()
        })
        
        if countDown < 4 {
            countDown += 1
        } else {
            countDownLabel.removeFromSuperview()
            
            countdownTimer?.invalidate()
            
            startGame()
        }
    }
    
    private func startGame() {
        randomtrafficTimer = Timer.scheduledTimer(timeInterval: TimeInterval(1.5),
                                                  target: self,
                                                  selector: #selector(randomTraffic),
                                                  userInfo: nil,
                                                  repeats: true)
        movetrafficTimer = Timer.scheduledTimer(timeInterval: TimeInterval(0.1),
                                                target: self,
                                                selector: #selector(moveTraffic),
                                                userInfo: nil,
                                                repeats: true)
        ifInterserctsTimer = Timer.scheduledTimer(timeInterval: TimeInterval(0.1), target: self, selector: #selector(ifIntersects), userInfo: nil, repeats: true)
        moveroadTimer = Timer.scheduledTimer(timeInterval: TimeInterval(0.5),
                                             target: self,
                                             selector: #selector(moveRoad),
                                             userInfo: nil,
                                             repeats: true)
        checkScoreTimer = Timer.scheduledTimer(timeInterval: TimeInterval(1),
                                              target: self,
                                              selector: #selector(checkScore),
                                              userInfo: nil,
                                              repeats: true)
    }
    
    @objc func moveTraffic() {
        for element in self.trafficObjects {
            element.frame.origin.y += 30
        }
    }
    
    @objc func randomTraffic() {
        guard let trafficObject = game.randomTrafficObject() else { return }
        
        let objectImage = UIImage(named: trafficObject.name)
        let imageView = //UIImageView(image: objectImage)
        UIImageView(frame: CGRect(x: rightView.frame.midX, y: 0, width: 50, height: 100))
        imageView.image = objectImage
        
        let random = Int.random(in: 1..<10)
        if random <= 4 {
            imageView.center = CGPoint(x: rightView.frame.midX, y: 0)
        } else {
            imageView.center = CGPoint(x: leftView.frame.midX, y: 0)
        }
        self.trafficObjects.append(imageView)
        view.addSubview(imageView)
        
    }
    
    
    @objc func ifIntersects() {
        for element in self.trafficObjects {
            if blueCar?.frame.intersects(element.frame) == true {
                showAlert()
            }
        }
    }
    
    
    func showAlert() {
        let alert = UIAlertController(title: "Game over! :(", message: "try again", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Go to menu", style: .default) { _ in
            self.navigationController?.popToRootViewController(animated: false)
        }
        let no = UIAlertAction(title: "Try again", style: .cancel) { _ in
            self.restartGame()
        }
        alert.addAction(ok)
        alert.addAction(no)
        self.present(alert, animated: false)
        stopTimers()
        
    }
    
    @objc func moveRoad() {
        self.centerRoadTopCOnstraint.constant -= 40
        UIView.animate(withDuration: 0.5, delay: 0, options: .repeat) {
            self.view.layoutIfNeeded()
        }
    }
    
    func stopTimers() {
        randomtrafficTimer?.invalidate()
        moveroadTimer?.invalidate()
        ifInterserctsTimer?.invalidate()
        movetrafficTimer?.invalidate()
        checkScoreTimer?.invalidate()
    }
    
    @objc func checkScore() {
        if ((movetrafficTimer?.isEqual(true)) != nil) {
            score += 1
            saveScore()
        }
}
    private func saveScore() {
        UserSettings.score = score
    }
    
    func restartGame() {
        self.score = 0
        self.countDown = 1
        self.countdownTimer = Timer.scheduledTimer(timeInterval: TimeInterval(1),
                                              target: self,
                                              selector: #selector(self.startCountDown),
                                              userInfo: nil,
                                              repeats: true)
        for element in trafficObjects {
            element.removeFromSuperview()
        }
        self.trafficObjects.removeAll()
    }
}

extension ViewController: GameDelegate {
    func showTrafficObject(_ object: Object) {
        let objectImage = UIImage(named: object.name)
        let imageView = UIImageView(frame: CGRect(x: rightView.frame.midX, y: 0, width: 50, height: 100))
        imageView.image = objectImage

        let random = Int.random(in: 1..<10)
        if random <= 4 {
            imageView.center = CGPoint(x: rightView.frame.midX, y: 0)
        } else {
            imageView.center = CGPoint(x: leftView.frame.midX, y: 0)
        }
        self.trafficObjects.append(imageView)
        view.addSubview(imageView)
    }

    func moveTrafficObject() {
        for element in self.trafficObjects {
            element.frame.origin.y += 30
        }
    }
    
    
}
