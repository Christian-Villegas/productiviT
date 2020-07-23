//
//  User.swift
//  widgets
//
//  Created by Christopher Cordero on 7/19/20.
//  Copyright © 2020 Christopher Cordero. All rights reserved.
//

import Foundation
import UIKit

class User {
    
    //Data Members//
    var name: String = ""
    let email: String = ""
    var password: String = ""
    var nameLabel = UILabel(frame: CGRect(x: 28, y: 141, width: 200, height: 21))
    var emailLabel = UILabel(frame: CGRect(x: 28, y: 141, width: 200, height: 21))
    var profileImage = UIImage()
    var profilePicDisplay = UIImageView(frame: CGRect(x: 28, y: 141, width: 50, height: 50))
    
    
    //constructor
    init(){
        self.profilePicDisplay.layer.cornerRadius = 0.5 * profilePicDisplay.bounds.size.width
        self.profilePicDisplay.clipsToBounds = true
        
        
        
        
        
    }


    
    
    
    
    
    
    
    
    
    
    
    
}
