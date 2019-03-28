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
    
    // Time Formatter
    
    let time = Date()
    let timeFormatter = DateFormatter()
    var currentTime = String()
    
    
    // Home Screen labels & play button outlets

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var homePageDescriptionLabelOne: UILabel!
    @IBOutlet weak var homePageDescriptionLabelTwo: UILabel!
    @IBOutlet weak var homePageDescriptionLabelThree: UILabel!
    @IBOutlet weak var homePageDescriptionLabelFour: UILabel!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    
    // Home Screen action buttons
    
    
    
    // Functions for ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeFormatter.dateFormat = "HH:mm"
        currentTime = timeFormatter.string(from: time)
        
        print("TODAY DATE \(currentTime)")
        
        firebaseReference = Database.database().reference().child("videos")
        firebaseReference.observe(DataEventType.value, with: {(snapshot) in
            
            if snapshot.childrenCount > 0 {
                self.videoStruct.removeAll()
                for video in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let Object = video.value as? [String: AnyObject]
                    let videoTitle = Object?["title"]
                    let videoLink = Object?["link"]
                    
                    let video = Videos(Title: videoTitle as? String, link: videoLink as? String)
                    
                    self.videoStruct.append(video)
                }
                
            }
            
        })
        
    }
    
    // AVPlayer functionality

    @IBAction func PressToPlayButton(_ sender: Any) {
        
        // Time range for allowed video play
        
        let startTime = "08:00"
        let endTime = "13:00"
        let timeRange = startTime ... endTime
        
        if timeRange.contains(currentTime) {
            
            // Getting video URL and creating the player
            
            guard let videoURL = URL(string: videoStruct[randomNumber].link!) else {
                return
            }
            let player = AVPlayer(url: videoURL)
            controller.player = player
            
            NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
            
            hideHomePageButtons()
            
            present(controller, animated: true) {
                player.play()
            }
            
        } else {
            performSegue(withIdentifier: "cannotPlaySegue", sender: self)
        }
        
    }
    
    @objc func videoDidEnd(notification: NSNotification) {
        controller.dismiss(animated: true, completion: {
            self.performSegue(withIdentifier: "endPageSegue", sender: self)
        })

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func hideHomePageButtons() {
        homePageDescriptionLabelOne.isHidden = true
        homePageDescriptionLabelTwo.isHidden = true
        homePageDescriptionLabelThree.isHidden = true
        homePageDescriptionLabelFour.isHidden = true
        aboutButton.isHidden = true
        infoButton.isHidden = true
        playButton.isHidden = true
    }

}

