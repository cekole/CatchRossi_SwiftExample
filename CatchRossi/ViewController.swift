//
//  ViewController.swift
//  CatchRossi
//
//  Created by Cenk Duran on 25.01.2023.
//

import UIKit

class ViewController: UIViewController {

    var score = 0
    var timer = Timer()
    var imgTimer = Timer()
    var counter = 20
    let randomInt = Int.random(in: 1...9)
    var images = [UIImageView?]()
    var shownImage : UIImageView?
    var highScore = 0
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var highScoreTitle: UILabel!
    
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var img5: UIImageView!
    @IBOutlet weak var img6: UIImageView!
    @IBOutlet weak var img7: UIImageView!
    @IBOutlet weak var img8: UIImageView!
    @IBOutlet weak var img9: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        highScoreLabel.text = UserDefaults.standard.value(forKey: "high_score") as? String
        timerLabel.text = String(counter)
        scoreLabel.text = "Score: \(score)"
        gestureInit()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(decrementTimer), userInfo: nil, repeats: true)
        imgTimer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(hideImages), userInfo: nil, repeats: true)
    }
    
    @objc func incrementScore() {
        score += 1
        scoreLabel.text = "Score: \(score)"
    }
    
    @objc func decrementTimer() {
        counter -= 1
        timerLabel.text = "\(counter)"
        if counter < 0 {
            timer.invalidate()
            imgTimer.invalidate()
            timerLabel.text = "Time is up!"
            
            highScore = Int(highScoreLabel.text ?? "0") ?? 0
            if score > highScore {
                highScoreLabel.text = "\(score)"
            }
            
            UserDefaults.standard.set(highScoreLabel.text, forKey: "high_score")
            let alert = UIAlertController(title: "Time Is Up", message: "Do You Want To Play Again?", preferredStyle: UIAlertController.Style.alert)
            let yesButton = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {_ in
                self.restart()
            }
            let noButton = UIAlertAction(title: "No", style: UIAlertAction.Style.default) {_ in
                self.shownImage?.isUserInteractionEnabled = false
            }
            
            alert.addAction(noButton)
            alert.addAction(yesButton)
            self.present(alert, animated: true)
        }
        
    }
    
    func restart() {
        score = 0
        counter = 20
        scoreLabel.text = "Score: \(score)"
        timerLabel.text = String(counter)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(decrementTimer), userInfo: nil, repeats: true)
        imgTimer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(hideImages), userInfo: nil, repeats: true)
        hideImages()
    }
    
    @objc func hideImages() {
        for image in images {
            image?.isHidden = true
        }
        let random = Int(arc4random_uniform(UInt32(images.count - 1)))
        shownImage = images[random]
        shownImage?.isHidden = false
    }
    
    func gestureInit() {
        images = [img1,img2,img3,img4,img5,img6,img7,img8,img9]
        for image in images {
            image?.isUserInteractionEnabled = true
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(incrementScore))
            image?.addGestureRecognizer(recognizer)
        }
        hideImages()
    }
}

