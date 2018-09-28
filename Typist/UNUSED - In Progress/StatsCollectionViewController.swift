//
//  StatsCollectionViewController.swift
//  Typist
//
//  Created by Simon Elhoej Steinmejer on 27/09/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

class StatsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout
{
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        setupCollectionView()
    }
    
    private func setupCollectionView()
    {
        collectionView.backgroundColor = .darkColor
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = false
    }
    
    
}










