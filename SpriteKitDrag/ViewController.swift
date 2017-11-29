//
//  ViewController.swift
//  SpriteKitDrag
//
//  Created by Aytekin Meral on 29/11/2017.
//  Copyright © 2017 com.aytek. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene(size: CGSize(width: view.bounds.size.width, height: 400))
        let skView = SKView(frame: CGRect(x: 0, y: 200, width: view.bounds.size.width, height: 400))
        skView.backgroundColor = .clear
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.presentScene(scene)
        
        self.view.addSubview(skView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

