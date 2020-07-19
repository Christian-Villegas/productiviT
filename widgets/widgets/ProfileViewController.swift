//
//  ProfileViewController.swift
//  widgets
//
//  Created by Christopher Cordero on 7/19/20.
//  Copyright © 2020 Christopher Cordero. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        bgView.layer.cornerRadius = 20
        bgView.layer.masksToBounds = true
        imageDisplay.layer.cornerRadius = 0.5 * imageDisplay.bounds.size.width
        imageDisplay.clipsToBounds = true

        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imageDisplay: UIImageView!
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    

}
