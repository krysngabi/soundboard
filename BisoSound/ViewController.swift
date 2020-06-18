//
//  ViewController.swift
//  BisoSound
//
//  Created by Krys Ngabi on 6/16/20.
//  Copyright © 2020 Krys Ngabi. All rights reserved.
//

import UIKit

import AVFoundation

class ViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var tabView: UITableView!
    
    var audioPlayer : AVAudioPlayer?
    
    var sounds : [Sound] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tabView.dataSource = self
        tabView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
       
        do {
        sounds = try context.fetch(Sound.fetchRequest())
        tabView.reloadData()
        } catch {
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return sounds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let sound = sounds[indexPath.row]
        cell.textLabel?.text = sound.name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let sound = sounds[indexPath.row]
        do {
            audioPlayer = try AVAudioPlayer (data: sound.audio!)
            audioPlayer?.play()
        } catch {
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let sound = sounds[indexPath.row]
            context.delete(sound)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                   sounds = try context.fetch(Sound.fetchRequest())
                   tabView.reloadData()
                   } catch {
                       
                   }
            
        }
    }


}

