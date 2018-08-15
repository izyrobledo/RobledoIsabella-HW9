//
//  ViewController.swift
//  RobledoIsabella-HW9
//  EID: ibr79
//  Course: CS371L
//  Created by Robledo, Isabella B on 8/13/18.
//  Copyright © 2018 Robledo, Isabella B. All rights reserved.
//

import UIKit
import Foundation

/* this struct holds all the global variables I use as well as their semaphores.
 Because the program is multithreaded, it's necessary to call wait() and signal()
 around every access and change to one of these global variables */
struct box {
    static let boundSema = DispatchSemaphore(value: 1)
    static var row = 9
    static var col = 4
    static let directionSema = DispatchSemaphore(value: 1)
    static var currentDirection = "start"
    static let boxHeight = UIScreen.main.bounds.height/19
    static let boxWidth = UIScreen.main.bounds.width/9
}

class ViewController: UIViewController {
    
    /* the label is initialized and set to 1/19th of the height of the screen and 1/9th of the width */
    var label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/9, height: UIScreen.main.bounds.height/19))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createLabel()
        initializeGestures()
        
    }
    /* where my label is initially created, programmatically */
    func createLabel(){
        box.boundSema.wait()
        box.row = 9
        box.col = 4
        box.boundSema.signal()
        label.backgroundColor = .green
        label.center = self.view.center
        self.view.addSubview(label)
    }
    
    /* where all my gestures are initialized and added to the gesture recognizer*/
    func initializeGestures(){
        
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

        let tap = UITapGestureRecognizer(target: self, action: #selector(recognizeTapGesture(recognizer:)))
        self.view.addGestureRecognizer(tap)
    }
    
    /* where all my the swipe gestures are recognized. This method pretty much just relies on move to do all the heavy lifting */
    @IBAction func recognizeSwipeGesture(recognizer: UISwipeGestureRecognizer)
    {
        DispatchQueue.global(qos: .userInteractive).async{
        let swipeGesture = recognizer as UISwipeGestureRecognizer
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                box.directionSema.wait()
                box.currentDirection = "right"
                self.move (direction: "right", xInc: box.boxWidth, yInc: 0.0, colInc: 1, rowInc: 0, hitBound: [-1, -1, 8, -1])
            case UISwipeGestureRecognizerDirection.down:
                box.directionSema.wait()
                box.currentDirection = "down"
                self.move (direction: "down", xInc: 0.0, yInc: box.boxHeight, colInc: 0, rowInc: 1, hitBound: [18, -1, -1, -1])
            case UISwipeGestureRecognizerDirection.left:
                box.directionSema.wait()
                box.currentDirection = "left"
                self.move (direction: "left", xInc: -box.boxWidth, yInc: 0.0, colInc: -1, rowInc: 0, hitBound: [-1, -1, -1, 0])
            case UISwipeGestureRecognizerDirection.up:
                box.directionSema.wait()
                box.currentDirection = "up"
                self.move (direction: "up", xInc: 0.0, yInc: -box.boxHeight, colInc: 0, rowInc: -1, hitBound: [-1, 0, -1, -1])
            default:
                break
            }
        }
    }
    
    /* This function does all the moving. originally I had this block of code for every direction, but
     I decided to make it cleaner by making one function that would take the direction of the current
     move (swipe or tap) as well as the amount it should be moved in the x and y direction, the amount
     of rows and columns it moved and an array that has the bounds for each move (I didn't check for
     all the bounds everytime because that would mean that the block wouldn't allow more swipes or
     movement once it reached an edge) */
    func move (direction: String, xInc: CGFloat, yInc: CGFloat, colInc: Int, rowInc: Int , hitBound: [Int]){
        box.directionSema.signal()
        box.boundSema.wait()
        while (!(box.row == hitBound[0] || box.row == hitBound[1] || box.col == hitBound[2] || box.col == hitBound[3])){
            box.boundSema.signal()
            usleep(300000)
            box.directionSema.wait()
            if (box.currentDirection == direction){
                box.boundSema.wait()
                DispatchQueue.main.async {
                    if (!(box.row == hitBound[0] || box.row == hitBound[1] || box.col == hitBound[2] || box.col == hitBound[3])){
                        UIView.animate (withDuration: 0.3, animations: {
                            self.label.center.x += xInc
                            self.label.center.y += yInc
                            box.row += rowInc
                            box.col += colInc
                        })
                    }
                }
                box.boundSema.signal()
            } // end of if
            box.directionSema.signal()
            box.boundSema.wait() // last line of while loop
        }
        box.boundSema.signal()
        
        /* realized after a long while that if I changed the color to red OUTSIDE of my while loop
         it wouldn't change prematurely */
        DispatchQueue.main.async{
            self.label.backgroundColor = .red
            box.directionSema.wait()
            box.currentDirection = "end"
            box.directionSema.signal()
        }
    }
    
    /* the function that recognizes taps. the block is set back to the middle and set back to green
     before it I call move in the "down" direction */
    @IBAction func recognizeTapGesture(recognizer: UITapGestureRecognizer)
    {
        DispatchQueue.global(qos: .userInteractive).async {
            box.boundSema.wait()
            box.row = 9
            box.col = 4
            box.boundSema.signal()
            DispatchQueue.main.async{
                self.label.backgroundColor = .green
                self.label.center = self.view.center
            }
            box.directionSema.wait()
            box.currentDirection = "down"
            self.move(direction: "down", xInc: 0.0, yInc: box.boxHeight, colInc: 0, rowInc: 1, hitBound: [18, -1, -1, -1])
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

