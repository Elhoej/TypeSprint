//
//  LeaderboardTableViewController.swift
//  Typist
//
//  Created by Simon Elhoej Steinmejer on 27/09/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit
import Firebase

class LeaderboardTableViewController: UITableViewController
{
    let cellId = "cellId"
    var leaderboardEntries = [LeaderboardEntry]()
    var leaderboardEntiresDictionary = [String: LeaderboardEntry]()
    var timer: Timer?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.7)
        setupTableView()
        fetchLeaderboard()
    }
    
    func fetchLeaderboard()
    {
        Database.database().reference().child("leaderboard").observe(.childAdded) { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any]
            {
                let leaderboardEntry = LeaderboardEntry(dictionary: dictionary)
                self.leaderboardEntiresDictionary[snapshot.key] = leaderboardEntry
                self.attemptReloadOfTable()
            }
        }
    }
    
    private func attemptReloadOfTable()
    {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    @objc func handleReloadTable()
    {
        self.leaderboardEntries = Array(self.leaderboardEntiresDictionary.values)
        
        self.leaderboardEntries.sort { (entry1, entry2) -> Bool in
            
            return (entry1.wpm?.int32Value)! > (entry2.wpm?.int32Value)!
        }
        
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
    private func setupTableView()
    {
        tableView.allowsSelection = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .darkColor
        tableView.register(LeaderboardCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return leaderboardEntries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! LeaderboardCell
        
        let entry = leaderboardEntries[indexPath.row]
        
        cell.nameLabel.text = entry.name
        if let wpmInt = entry.wpm?.intValue
        {
            cell.wpmLabel.text = "wpm: \(String(wpmInt))"
        }
        
        checkIfTopThree(cell: cell, row: indexPath.row)
        
        return cell
    }
    
    private func checkIfTopThree(cell: LeaderboardCell, row: Int)
    {
        switch row {
        case 0:
            cell.trophyImageView.tintColor = .goldColor
            cell.trophyImageView.isHidden = false
        case 1:
            cell.trophyImageView.tintColor = .silver
            cell.trophyImageView.isHidden = false
        case 2:
            cell.trophyImageView.tintColor = .bronze
            cell.trophyImageView.isHidden = false
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
}
