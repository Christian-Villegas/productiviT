//
//  Widget.swift
//  widgets
//
//  Created by Christopher Cordero on 6/29/20.
//  Copyright © 2020 Christopher Cordero. All rights reserved.
//

import UIKit

class Widget: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        self.title = ""
        // this holds the staying place of the widget also top left corner
        self.ogPosition = CGPoint(x: 0, y: 0)
        //this holds the staying center
        self.ogCenter = CGPoint(x: 0, y: 0)
        // size level goes up to 3
        self.size = 1
        //empty array of placeHolders the widget is on. This can be of size one (1 placeholder), size two (2 placeholders), or size 3 (4 placeholders).
        self.placeHoldersAccessed = []
        
        super.init(frame: frame)
        self.backgroundColor = .lightGray
        self.alpha = 0.5
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panView))
        self.addGestureRecognizer(panGesture)
        
        sizeButton.setTitle("change size", for: .normal)
        sizeButton.addTarget(self, action: #selector(changeSize), for: .touchUpInside)
        self.addSubview(sizeButton)
        
        delButton.setTitle("x", for: .normal)
        delButton.addTarget(self, action: #selector(deleteWidget), for: .touchUpInside)
        self.addSubview(delButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Delete Widget: At the click of a button located on the widget, removes the widget as well as clears it's access and empties the placeholders it was previously stored on.
    @objc func deleteWidget(sender: UIButton) {
        //edit button must be on
        if editOn == false {return} // returns if not in edit mode
        //prompts user with alert
        let alert = UIAlertController(title: "Are you sure?", message: "Deleting this widget will also delete all of its data.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {action in
            
            self.clearWPHA()
            for i in (0...(screenWidgets.count-1)){
                if screenWidgets[i] == self{
                    screenWidgets.remove(at: i) //remove from widget array
                    break
                }
            }
            
            self.removeFromSuperview()
            }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.present(alert, animated: true, completion: nil)
        }
    }
    
    //Change Size: At the click of a button located on the widget, this function will add the appropriate place holders to the widgets data and will also update the place holders to be full. The change in size also 
    @objc func changeSize(sender: UIButton) {
        if editOn == false {return} // returns if not in edit mode
        
        if(self.size == 1 && self.center.x == 108.5 && checkSizeAvailablility(start: self.placeHoldersAccessed[0], desiredSize: 2)) {
            self.frame = CGRect(x: self.frame.minX, y: self.frame.minY, width: 374.0, height: 177.0)
            self.placeHoldersAccessed.append(placeHolders.grid[self.getPlaceHolder(number: self.placeHoldersAccessed[0].number + 1).row][self.getPlaceHolder(number: self.placeHoldersAccessed[0].number + 1).column])
            placeHolders.grid[getPlaceHolder(number: self.placeHoldersAccessed[1].number).row][getPlaceHolder(number: self.placeHoldersAccessed[1].number).column].filled = true
            placeHolders.grid[getPlaceHolder(number: self.placeHoldersAccessed[1].number).row][getPlaceHolder(number: self.placeHoldersAccessed[1].number).column].widget = self
            let newX = self.calculateCoords(PHA: self.placeHoldersAccessed).x
            let newY = self.calculateCoords(PHA: self.placeHoldersAccessed).y
            self.ogCenter = CGPoint(x:newX, y:newY)
            self.size = 2
        } else if(self.size == 2 && self.ogPosition.x == CGFloat(placeHolders.grid[0][0].posX) && checkSizeAvailablility(start: self.placeHoldersAccessed[0], desiredSize: 3)) {
            self.frame = CGRect(x: self.frame.minX, y: self.frame.minY, width: 374.0, height: 362.0)
            self.placeHoldersAccessed.append(placeHolders.grid[self.getPlaceHolder(number: self.placeHoldersAccessed[0].number + 2).row][self.getPlaceHolder(number: self.placeHoldersAccessed[0].number + 2).column])
            self.placeHoldersAccessed.append(placeHolders.grid[self.getPlaceHolder(number: self.placeHoldersAccessed[0].number + 3).row][self.getPlaceHolder(number: self.placeHoldersAccessed[0].number + 3).column])
            placeHolders.grid[getPlaceHolder(number: self.placeHoldersAccessed[1].number).row][getPlaceHolder(number: self.placeHoldersAccessed[1].number).column].filled = true
            placeHolders.grid[getPlaceHolder(number: self.placeHoldersAccessed[1].number).row][getPlaceHolder(number: self.placeHoldersAccessed[1].number).column].widget = self
            placeHolders.grid[getPlaceHolder(number: self.placeHoldersAccessed[2].number).row][getPlaceHolder(number: self.placeHoldersAccessed[2].number).column].filled = true
            placeHolders.grid[getPlaceHolder(number: self.placeHoldersAccessed[2].number).row][getPlaceHolder(number: self.placeHoldersAccessed[2].number).column].widget = self
            placeHolders.grid[getPlaceHolder(number: self.placeHoldersAccessed[3].number).row][getPlaceHolder(number: self.placeHoldersAccessed[3].number).column].filled = true
            placeHolders.grid[getPlaceHolder(number: self.placeHoldersAccessed[3].number).row][getPlaceHolder(number: self.placeHoldersAccessed[3].number).column].widget = self
            let newX = self.calculateCoords(PHA: self.placeHoldersAccessed).x
            let newY = self.calculateCoords(PHA: self.placeHoldersAccessed).y
            self.ogCenter = CGPoint(x:newX, y:newY)
        } else {
            self.frame = CGRect(x: self.frame.minX, y: self.frame.minY, width: 177.0, height: 177.0)
            
            let temp = self.placeHoldersAccessed[0]
            self.clearWPHA()
            self.placeHoldersAccessed = [temp]
            placeHolders.grid[getPlaceHolder(number: self.placeHoldersAccessed[0].number).row][getPlaceHolder(number: self.placeHoldersAccessed[0].number).column].filled = true
            self.placeHoldersAccessed[0].filled = true
            self.placeHoldersAccessed[0].widget = self
            let newX = self.calculateCoords(PHA: self.placeHoldersAccessed).x
            let newY = self.calculateCoords(PHA: self.placeHoldersAccessed).y
            self.ogCenter = CGPoint(x:newX, y:newY)
            self.size = 1
        }
        placeHolders.gridPrint()
    }
   
    func getPlaceHolder(number: Int) -> (row: Int, column: Int){
        for row in 0...3{
            for column in 0...1 {
                if number == placeHolders.grid[row][column].number{
                    return (row, column)
                }
            }
        }
        return (0,0)
    }
    
    func clearWPHA(){
        for (index, _) in self.placeHoldersAccessed.enumerated() {
            placeHolders.grid[getPlaceHolder(number: placeHoldersAccessed[index].number).row][getPlaceHolder(number: placeHoldersAccessed[index].number).column].filled = false
            placeHolders.grid[getPlaceHolder(number: placeHoldersAccessed[index].number).row][getPlaceHolder(number: placeHoldersAccessed[index].number).column].widget = nil
            
            self.placeHoldersAccessed[index].filled = false
            self.placeHoldersAccessed[index].widget = nil
        }
    }
    
    func checkSizeAvailablility(start: PlaceHolder, desiredSize: Int) -> Bool{
        let number = start.number
        if(desiredSize == 2) {
            if(placeHolders.grid[getPlaceHolder(number: number + 1).row][getPlaceHolder(number:number + 1).column].filled == false){
                return true
            } else {return false}
        } else if(desiredSize == 3) {
            if((placeHolders.grid[getPlaceHolder(number: number + 1).row][getPlaceHolder(number:number + 1).column].filled == true) && (placeHolders.grid[getPlaceHolder(number: number + 2).row][getPlaceHolder(number:number + 2).column].filled == false) && (placeHolders.grid[getPlaceHolder(number: number + 3).row][getPlaceHolder(number:number + 3).column].filled == false)) {
                return true
            } else {return false}
        }
        return true
    }
    //FIX THIS SHIT
    func calculateCoords(PHA: [PlaceHolder]) -> (x: Double, y:Double){
        var x = 0.0
        var y = 0.0
        var count = 1
        for ph in PHA{
            print("The \(count) placeholder postion x is \(ph.posX) position y is \(ph.posY)")
            x += ph.xC
            y += ph.yC
            count += 1
        }
        x /= Double(PHA.count)
        y /= Double(PHA.count)
        print("Calculated x: \(x) Calculated y: \(y)")
        return(x, y)
    }
    
    @objc func panView(_ panGesture: UIPanGestureRecognizer) {
       
        if editOn == false {return} // returns if not in edit mode
        
        let translation = panGesture.translation(in: self)

        if let viewToDrag = panGesture.view {
            viewToDrag.center = CGPoint(x: viewToDrag.center.x + translation.x,
                y: viewToDrag.center.y + translation.y)
            panGesture.setTranslation(CGPoint(x: 0, y: 0), in: viewToDrag)
        }
        
        // the center x-coordinate for column zero
        let columnZero = placeHolders.grid[0][0].xC
        // the center x-coordinate for column one
        let columnOne = placeHolders.grid[0][1].xC
        // the center y-coordinate for row zero
        let rowZero = placeHolders.grid[0][0].yC
        // the center y-coordinate for row one
        let rowOne = placeHolders.grid[1][0].yC
        // the center y-coordinate for row two
        let rowTwo = placeHolders.grid[2][0].yC
        // the center y-coordinate for row three
        let rowThree = placeHolders.grid[3][0].yC
        // the center x-coordinate between the columns
        let columnMiddle = (columnZero + columnOne)/2
        // the center y-coordinate between rows 0 and 1 and the center x-coordinate
        let rowMiddleOne = (rowZero + rowOne)/2
        // the center y-coordinate between rows 1 and 2
        let rowMiddleTwo = (rowOne + rowTwo)/2
        // the center y-coordinate between rows 2 and 3
        let rowMiddleThree = (rowTwo + rowThree)/2
        // the center y-coordinate
        let middleY = (rowMiddleOne + rowMiddleOne)/2
        // the center x-coordinate for the panGesture
        let panGestureX = panGesture.view!.center.x
        // the center y-coordinate for the panGesture
        let panGestureY = panGesture.view!.center.y
        
        // size 1
        if(self.size == 1) {
            // row 0 column 0
            if(abs(columnZero - Double(panGestureX)) <= 98.5 && abs(rowZero - Double(panGestureY)) <= 98.5) && (translation.x == 0.0 && translation.y == 0.0) {
                // if the placeHolder is filled, we put the widget to its original position
                if(placeHolders.grid[0][0].filled == true) {
                    panGesture.view?.center = self.ogCenter
                } else {
                    // supposed to rewrite the array of placeHolders
                    self.clearWPHA()
                    
                    self.placeHoldersAccessed = [placeHolders.grid[0][0]]
                    placeHolders.grid[0][0].widget = self
                    panGesture.view?.center = CGPoint(x: columnZero, y: rowZero)
                    self.ogPosition = CGPoint(x: placeHolders.grid[0][0].posX, y: placeHolders.grid[0][0].posY)
                    self.ogCenter = CGPoint(x: columnZero, y: rowZero)
                    placeHolders.updateFilled()
                }
            // row 0 column 1
            } else if(abs(columnOne - Double(panGestureX)) <= 98.5 && abs(rowZero - Double(panGestureY)) <= 98.5 ) && (translation.x == 0.0 && translation.y == 0.0) {
                if(placeHolders.grid[0][1].filled == true) {
                    panGesture.view?.center = self.ogCenter
                } else {
                    self.clearWPHA()

                    self.placeHoldersAccessed = [placeHolders.grid[0][1]]
                    placeHolders.grid[0][1].widget = self
                    panGesture.view?.center = CGPoint(x: columnOne, y: rowZero)
                    self.ogPosition = CGPoint(x: placeHolders.grid[0][1].posX, y: placeHolders.grid[0][1].posY)
                    self.ogCenter = CGPoint(x: columnOne, y: rowZero)
                    placeHolders.updateFilled()
                }
            // row 1 column 0
            } else if(abs(columnZero - Double(panGestureX)) <= 98.5 && abs(rowOne - Double(panGestureY)) <= 98.5 ) && (translation.x == 0.0 && translation.y == 0.0) {
                if(placeHolders.grid[1][0].filled == true) {
                    panGesture.view?.center = self.ogCenter
                } else {
                    self.clearWPHA()

                    self.placeHoldersAccessed = [placeHolders.grid[1][0]]
                    placeHolders.grid[1][0].widget = self
                    panGesture.view?.center = CGPoint(x: columnZero, y: rowOne)
                    self.ogPosition = CGPoint(x: placeHolders.grid[1][0].posX, y: placeHolders.grid[1][0].posY)
                    self.ogCenter = CGPoint(x: columnZero, y: rowOne)
                    placeHolders.updateFilled()
                }
            // row 1 column 1
            } else if(abs(columnOne - Double(panGestureX)) <= 98.5 && abs(rowOne - Double(panGestureY)) <= 98.5 ) && (translation.x == 0.0 && translation.y == 0.0){
                if(placeHolders.grid[1][1].filled == true) {
                    panGesture.view?.center = self.ogCenter
                } else {
                    self.clearWPHA()

                    self.placeHoldersAccessed = [placeHolders.grid[1][1]]
                    placeHolders.grid[1][1].widget = self
                    panGesture.view?.center = CGPoint(x: columnOne, y: rowOne)
                    self.ogPosition = CGPoint(x: placeHolders.grid[1][1].posX, y: placeHolders.grid[1][1].posY)
                    self.ogCenter = CGPoint(x: columnOne, y: rowOne)
                    placeHolders.updateFilled()
                }
            // row 2 column 0
            } else if(abs(columnZero - Double(panGestureX)) <= 98.5 && abs(rowTwo - Double(panGestureY)) <= 98.5 ) && (translation.x == 0.0 && translation.y == 0.0){
            
                if(placeHolders.grid[2][0].filled == true) {
                    panGesture.view?.center = self.ogCenter
                } else {
                    self.clearWPHA()
                    self.placeHoldersAccessed = [placeHolders.grid[2][0]]
                    placeHolders.grid[2][0].widget = self
                    panGesture.view?.center = CGPoint(x: columnZero, y: rowTwo)
                    self.ogPosition = CGPoint(x: placeHolders.grid[2][0].posX, y: placeHolders.grid[2][0].posY)
                    self.ogCenter = CGPoint(x: columnZero, y: rowTwo)
                    placeHolders.updateFilled()
                }
            // row 2 column 1
            } else if(abs(columnOne - Double(panGestureX)) <= 98.5 && abs(rowTwo - Double(panGestureY)) <= 98.5 ) && (translation.x == 0.0 && translation.y == 0.0){
                
                if(placeHolders.grid[2][1].filled == true) {
                    panGesture.view?.center = self.ogCenter
                } else {
                    self.clearWPHA()

                    self.placeHoldersAccessed = [placeHolders.grid[2][1]]
                    placeHolders.grid[2][1].widget = self
                    panGesture.view?.center = CGPoint(x: columnOne, y: rowTwo)
                    self.ogPosition = CGPoint(x: placeHolders.grid[2][1].posX, y: placeHolders.grid[2][1].posY)
                    self.ogCenter = CGPoint(x: columnOne, y: rowTwo)
                    placeHolders.updateFilled()
                }
            // row 3 column 0
            } else if(abs(columnZero - Double(panGestureX)) <= 98.5 && abs(rowThree - Double(panGestureY)) <= 98.5 ) && (translation.x == 0.0 && translation.y == 0.0){
                
                if(placeHolders.grid[3][0].filled == true) {
                    panGesture.view?.center = self.ogCenter
                } else {
                    self.clearWPHA()
                    self.placeHoldersAccessed = [placeHolders.grid[3][0]]
                    placeHolders.grid[3][0].widget = self
                    panGesture.view?.center = CGPoint(x: columnZero, y: rowThree)
                    self.ogPosition = CGPoint(x: placeHolders.grid[3][0].posX, y: placeHolders.grid[3][0].posY)
                    self.ogCenter = CGPoint(x: columnZero, y: rowThree)
                    placeHolders.updateFilled()
                }
            // row 3 column 1
            } else if(abs(columnOne - Double(panGestureX)) <= 98.5 && abs(rowThree - Double(panGestureY)) <= 98.5 ) && (translation.x == 0.0 && translation.y == 0.0){
                    
                if(placeHolders.grid[3][1].filled == true) {
                    panGesture.view?.center = self.ogCenter
                } else {
                    self.clearWPHA()
                    
                    self.placeHoldersAccessed = [placeHolders.grid[3][1]]
                    placeHolders.grid[3][1].widget = self
                    panGesture.view?.center = CGPoint(x: columnOne, y: rowThree)
                    self.ogPosition = CGPoint(x: placeHolders.grid[3][1].posX, y: placeHolders.grid[3][1].posY)
                    self.ogCenter = CGPoint(x: columnOne, y: rowThree)
                    placeHolders.updateFilled()
                }
            } else if((abs(columnMiddle - Double(panGestureX)) > 197 || abs(middleY - Double(panGestureY)) > 200 )) && (translation.x == 0.0 && translation.y == 0.0) {
                panGesture.view?.center = self.ogCenter
            }
        // END OF SIZE 1 //
        } else if(size == 2) {
            // row 0
            if(abs(columnMiddle - Double(panGestureX)) <= 197 && abs(rowZero - Double(panGestureY)) <= 98.5 ) && (translation.x == 0.0 && translation.y == 0.0) {
                print(self.ogCenter)
                if(placeHolders.grid[0][0].filled == true || placeHolders.grid[0][1].filled == true) {
                    panGesture.view?.center = self.ogCenter
                } else {
                    self.clearWPHA()

                    self.placeHoldersAccessed = [placeHolders.grid[0][0], placeHolders.grid[0][1]]
                    placeHolders.grid[0][0].widget = self
                    panGesture.view?.center = CGPoint(x: columnMiddle, y: rowZero)
                    self.ogPosition = CGPoint(x: placeHolders.grid[0][0].posX, y: placeHolders.grid[0][0].posY)
                    self.ogCenter = CGPoint(x: columnMiddle, y: rowZero)
                    placeHolders.updateFilled()
                }
            // row 1
            } else if(abs(columnMiddle - Double(panGestureX)) <= 197 && abs(rowOne - Double(panGestureY)) <= 98.5 ) && (translation.x == 0.0 && translation.y == 0.0) {
                print(self.ogCenter)
                if(placeHolders.grid[1][0].filled == true || placeHolders.grid[1][1].filled == true) {
                    panGesture.view?.center = self.ogCenter
                } else {
                    self.clearWPHA()

                    self.placeHoldersAccessed = [placeHolders.grid[1][0], placeHolders.grid[1][1]]
                    placeHolders.grid[1][0].widget = self
                    panGesture.view?.center = CGPoint(x: columnMiddle, y: rowOne)
                    self.ogPosition = CGPoint(x: placeHolders.grid[1][0].posX, y: placeHolders.grid[1][0].posY)
                    self.ogCenter = CGPoint(x: columnMiddle, y: rowOne)
                    placeHolders.updateFilled()
                }
            // row 2
            } else if(abs(columnMiddle - Double(panGestureX)) <= 197 && abs(rowTwo - Double(panGestureY)) <= 98.5 ) && (translation.x == 0.0 && translation.y == 0.0) {
                print(self.ogCenter)
                if(placeHolders.grid[2][0].filled == true || placeHolders.grid[2][1].filled == true) {
                    panGesture.view?.center = self.ogCenter
                } else {
                    self.clearWPHA()

                    self.placeHoldersAccessed = [placeHolders.grid[2][0], placeHolders.grid[2][1]]
                    placeHolders.grid[2][0].widget = self
                    panGesture.view?.center = CGPoint(x: columnMiddle, y: rowTwo)
                    self.ogPosition = CGPoint(x: placeHolders.grid[2][0].posX, y: placeHolders.grid[2][0].posY)
                    self.ogCenter = CGPoint(x: columnMiddle, y: rowTwo)
                    placeHolders.updateFilled()
                }
            // row 3
            } else if(abs(columnMiddle - Double(panGestureX)) <= 197 && abs(rowThree - Double(panGestureY)) <= 98.5 ) && (translation.x == 0.0 && translation.y == 0.0) {
                
                if(placeHolders.grid[3][0].filled == true || placeHolders.grid[3][1].filled == true) {
                    panGesture.view?.center = self.ogCenter
                } else {
                    self.clearWPHA()
                    
                    self.placeHoldersAccessed = [placeHolders.grid[3][0], placeHolders.grid[3][1]]
                    placeHolders.grid[3][0].widget = self
                    panGesture.view?.center = CGPoint(x: columnMiddle, y: rowThree)
                    self.ogPosition = CGPoint(x: placeHolders.grid[3][0].posX, y: placeHolders.grid[3][0].posY)
                    self.ogCenter = CGPoint(x: columnMiddle, y: rowThree)
                    placeHolders.updateFilled()
                }
            } else if((abs(columnMiddle - Double(panGestureX)) > 197 || abs(middleY - Double(panGestureY)) > 200 )) && (translation.x == 0.0 && translation.y == 0.0) {
                panGesture.view?.center = self.ogCenter
            }
        // END OF SIZE 2 //
        } else if(size == 3) {
            // row 0 and 1 AND column 0 and 1
            if(abs(columnMiddle - Double(panGestureX)) <= 197 && abs(rowMiddleOne - Double(panGestureY)) <= 197 ) && (translation.x == 0.0 && translation.y == 0.0) {
                print("We've reached the first statemet")
                if((placeHolders.grid[0][0].filled == true || placeHolders.grid[0][1].filled == true) && (placeHolders.grid[1][0].filled == true || placeHolders.grid[1][1].filled == true)) {
                    panGesture.view?.center = self.ogCenter
                } else {
                    self.clearWPHA()
                    self.placeHoldersAccessed = [placeHolders.grid[0][0], placeHolders.grid[0][1], placeHolders.grid[1][0], placeHolders.grid[1][1]]
                    placeHolders.grid[0][0].widget = self
                    panGesture.view?.center = CGPoint(x: columnMiddle, y: rowMiddleOne)
                    self.ogPosition = CGPoint(x: placeHolders.grid[0][0].posX, y: placeHolders.grid[0][0].posY)
                    self.ogCenter = CGPoint(x: columnMiddle, y: rowMiddleOne)
                    placeHolders.updateFilled()
                }
            // row 1 and 2 AND column 0 and 1
            } else if(abs(columnMiddle - Double(panGestureX)) <= 197 && abs(rowMiddleTwo - Double(panGestureY)) <= 197 ) && (translation.x == 0.0 && translation.y == 0.0) {
                print("new if being called")
                if((placeHolders.grid[1][0].filled == true || placeHolders.grid[1][1].filled == true) && (placeHolders.grid[2][0].filled == true || placeHolders.grid[2][1].filled == true)) {
                    panGesture.view?.center = self.ogCenter
                } else {
                    self.clearWPHA()
                    
                    self.placeHoldersAccessed = [placeHolders.grid[1][0], placeHolders.grid[1][1], placeHolders.grid[2][0], placeHolders.grid[2][1]]
                    placeHolders.grid[1][0].widget = self
                    panGesture.view?.center = CGPoint(x: columnMiddle, y: rowMiddleTwo)
                    self.ogPosition = CGPoint(x: placeHolders.grid[1][0].posX, y: placeHolders.grid[1][0].posY)
                    self.ogCenter = CGPoint(x: columnMiddle, y: rowMiddleTwo)
                    placeHolders.updateFilled()
                }
            // row 2 and 3 AND column 0 and 1
            } else if(abs(columnMiddle - Double(panGestureX)) <= 197 && abs(rowMiddleThree - Double(panGestureY)) <= 197 ) && (translation.x == 0.0 && translation.y == 0.0) {
                print("We've reached the second statemet")
                if((placeHolders.grid[2][0].filled == true || placeHolders.grid[2][1].filled == true) && (placeHolders.grid[3][0].filled == true || placeHolders.grid[3][1].filled == true)) {
                    panGesture.view?.center = self.ogCenter
                } else {
                    self.clearWPHA()
                    
                    self.placeHoldersAccessed = [placeHolders.grid[2][0], placeHolders.grid[2][1], placeHolders.grid[3][0], placeHolders.grid[3][1]]
                    placeHolders.grid[2][0].widget = self
                    panGesture.view?.center = CGPoint(x: columnMiddle, y: rowMiddleThree)
                    self.ogPosition = CGPoint(x: placeHolders.grid[2][0].posX, y: placeHolders.grid[2][0].posY)
                    self.ogCenter = CGPoint(x: columnMiddle, y: rowMiddleThree)
                    placeHolders.updateFilled()
                }
            } else if((abs(columnMiddle - Double(panGestureX)) > 197 || abs(middleY - Double(panGestureY)) > 200)) && (translation.x == 0.0 && translation.y == 0.0) {
                panGesture.view?.center = self.ogCenter
            }
        } // END OF SIZE 3 //
    }
    
    
    
    //Data Members://
    var title: String
    let delButton = UIButton(frame: CGRect(x: 135, y: 4, width: 40.0, height: 40.0))
    let sizeButton = UIButton(frame: CGRect(x: 20.0, y: 20.0, width: 100.0, height: 40.0))
    var ogPosition: CGPoint
    var ogCenter: CGPoint
    var size: Int
    var placeHoldersAccessed: Array<PlaceHolder>
    
}
