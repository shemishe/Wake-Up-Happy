//
//  ViewController.swift
//  Wake Up Happy
//
//  Created by Sherman Shi on 3/11/19.
//  Copyright © 2019 Sherman Shi. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseDatabase
import AVKit

class ViewController: UIViewController {
    
    var videoStruct = [Videos]()
    
    var firebaseReference: DatabaseReference!
    
    let controller = AVPlayerViewController()
    
    var randomNumber = Int.random(in: 0...2)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        firebaseReference = Database.database().reference().child("videos")
        
        firebaseReference.observe(DataEventType.value, with: {(snapshot) in
            
            if snapshot.childrenCount > 0 {
                
                self.videoStruct.removeAll()
                
                for video in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let Object = video.value as? [String: AnyObject]
                    let Title = Object?["Title"]
                    let videolink = Object?["link"]
                    
                    let video = Videos(Title: Title as? String, link: videolink as? String)
                    
                    self.videoStruct.append(video)
                    
                    print(self.randomNumber)
                    
                }
                
            }
            
        })
        
    }

    @IBAction func PressToPlayButton(_ sender: Any) {
        
        guard let videoURL = URL(string: videoStruct[randomNumber].link!) else {
            
            return
            
        }
        
        let player = AVPlayer(url: videoURL)
        
        controller.player = player
        
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        present(controller, animated: true) {
            
            player.play()
            
        }
        
    }
    
    @objc func videoDidEnd(notification: NSNotification) {
        
        controller.dismiss(animated: true, completion: nil)
        
    }

}

