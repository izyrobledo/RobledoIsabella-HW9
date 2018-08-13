//
//  ViewController.swift
//  RobledoIsabella-HW9
//
//  Created by Robledo, Isabella B on 8/13/18.
//  Copyright © 2018 Robledo, Isabella B. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 41, height: 35))

    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        
        createLabel()
        initializeGestures()
        
       
    }
    
    func initializeGestures(){
        
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(recognizeSwipeGesture(recognizer:)))
        swipeRecognizer.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRecognizer)
        
//        let edgePanRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(recognizeEdgePanGesture(recognizer:)))
//        edgePanRecognizer.edges = UIRectEdge.left
//        self.view.addGestureRecognizer(edgePanRecognizer)
    }
    
    
    func createLabel(){
        // CGRectMake has been deprecated - and should be let, not var
        //let label = UILabel(frame: CGRect(x: 0, y: 0, width: 41, height: 35))
        // you will probably want to set the font (remember to use Dynamic Type!)
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        // and set the text color too - remember good contrast
        label.textColor = .black
        label.backgroundColor = .green
        label.center = self.view.center
        // this changed in Swift 3 (much better, no?)
        label.textAlignment = .center
        label.text = ""
        self.view.addSubview(label)
    }
    
    @IBAction func recognizeSwipeGesture(recognizer: UISwipeGestureRecognizer)
    {
        if recognizer.state == .ended {
            label.text = "Swipe"
            
            self.label.center.x = self.view.center.x
            
            UIView.animate (withDuration: 1.0,
                            animations: {
                                self.label.center.x +=    self.view.bounds.width
            })
            
            self.label.center.x = self.view.center.x - self.view.bounds.width
            
            UIView.animate (withDuration: 1.0,
                            animations: {
                                self.label.center.x += self.view.bounds.width
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

