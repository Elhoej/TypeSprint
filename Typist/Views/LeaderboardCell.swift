//
//  LeaderboardCell.swift
//  Typist
//
//  Created by Simon Elhoej Steinmejer on 27/09/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

class LeaderboardCell: UITableViewCell
{
    let nameLabel: UILabel =
    {
        let label = UILabel()
        label.font = Appearance.titleFont(with: 16)
        label.textColor = .white
        
        return label
    }()
    
    let trophyImageView: UIImageView =
    {
        let iv = UIImageView(image: UIImage(named: "trophy")?.withRenderingMode(.alwaysTemplate))
        iv.contentMode = .scaleAspectFill
        iv.isHidden = true
        
        return iv
    }()
    
    let wpmLabel: UILabel =
    {
        let label = UILabel()
        label.font = Appearance.titleFont(with: 16)
        label.textColor = .white
        label.textAlignment = .right
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupViews()
    }
    
    private func setupViews()
    {
        addSubview(nameLabel)
        addSubview(wpmLabel)
        addSubview(trophyImageView)
        
        wpmLabel.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 12, paddingBottom: 0, width: 80, height: 40)
        wpmLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        trophyImageView.anchor(top: nil, left: nil, bottom: nil, right: wpmLabel.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 8, paddingBottom: 0, width: 34, height: 34)
        trophyImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        nameLabel.anchor(top: nil, left: leftAnchor, bottom: nil, right: trophyImageView.leftAnchor, paddingTop: 0, paddingLeft: 12, paddingRight: 8, paddingBottom: 0, width: 0, height: 40)
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
