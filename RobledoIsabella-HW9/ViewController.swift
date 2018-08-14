//
//  ViewController.swift
//  RobledoIsabella-HW9
//
//  Created by Robledo, Isabella B on 8/13/18.
//  Copyright © 2018 Robledo, Isabella B. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //let screenSize = UIScreen.main.bounds
    //let screenSize = UIScreen.main.bounds
    let boxHeight = UIScreen.main.bounds.height/19
    let boxWidth = UIScreen.main.bounds.width/9
    
    var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createLabel()
        initializeGestures()
        
    }
    
    func initializeGestures(){
        
//        let directions: [UISwipeGestureRecognizerDirection] = [.right, .left, .up, .down]
//        for direction in directions {
//            let gesture = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipe:"))
//            gesture.direction = direction
//            self.view.addGestureRecognizer(gesture)
//        }
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(recognizeSwipeGesture(recognizer:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(recognizeSwipeGesture(recognizer:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(recognizeSwipeGesture(recognizer:)))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(recognizeSwipeGesture(recognizer:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    
    func createLabel(){
       
        label = UILabel(frame: CGRect(x: 0, y: 0, width: boxWidth, height: boxHeight))
        print ("boxWidth: \(boxWidth)")
        print ("boxWidth: \(boxWidth)")
        label?.font = UIFont.preferredFont(forTextStyle: .footnote)
        // and set the text color too - remember good contrast
        label?.textColor = .black
        label?.backgroundColor = .green
        label?.center = self.view.center
        // this changed in Swift 3 (much better, no?)
        label?.textAlignment = .center
        label?.text = "start"
        self.view.addSubview(label!)
    }
    
    @IBAction func recognizeSwipeGesture(recognizer: UISwipeGestureRecognizer)
    {
        if let swipeGesture = recognizer as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                label?.text = "right"
                print(label?.center.x)
                print(label?.center.y)
                
            case UISwipeGestureRecognizerDirection.down:
                label?.text = "down"
            case UISwipeGestureRecognizerDirection.left:
                label?.text = "left"
            case UISwipeGestureRecognizerDirection.up:
                label?.text = "up"
            default:
                break
            }
        }
        
//        if recognizer.state == .ended {
//            label.text = "Swipe"
//
//            self.label.center.x = self.view.center.x
//
//            UIView.animate (withDuration: 1.0,
//                            animations: {
//                                self.label.center.x +=    self.view.bounds.width
//            })
//
//            self.label.center.x = self.view.center.x - self.view.bounds.width
//
//            UIView.animate (withDuration: 1.0,
//                            animations: {
//                                self.label.center.x += self.view.bounds.width
//            })
//        }
    }
    
    @IBAction func recognizeTapGesture(recognizer: UITapGestureRecognizer)
    {
        label?.text = "Tap"
        let colorRed: CGFloat = CGFloat(arc4random()) / CGFloat(RAND_MAX)
        let colorGreen: CGFloat = CGFloat(arc4random()) / CGFloat(RAND_MAX)
        let colorBlue: CGFloat = CGFloat(arc4random()) / CGFloat(RAND_MAX)
        label?.backgroundColor = UIColor(red: colorRed, green: colorGreen, blue: colorBlue, alpha: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

