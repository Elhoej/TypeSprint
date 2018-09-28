//
//  StatsView.swift
//  Typist
//
//  Created by Simon Elhoej Steinmejer on 27/09/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit
import SwiftChart

class StatsView: UIView
{
    var wpmDoubles = [Double]()
    {
        didSet
        {
            let lastSixElements = Array(wpmDoubles.suffix(8))
            let series = ChartSeries(lastSixElements)
            if let averageWpm = averageWpm
            {
                series.colors = (above: UIColor.correctGreen, below: UIColor.incorrectRed, zeroLevel: Double(averageWpm)
                )
            }
            series.area = true

            wpmChart.add(series)
        }
    }
    var averageWpm: Int?
    {
        didSet
        {
            guard let averageWpm = averageWpm else { return }
            let attributedString = NSMutableAttributedString(string: "\(averageWpm)", attributes: [NSAttributedString.Key.font: Appearance.titleFont(with: 60), NSAttributedString.Key.foregroundColor: UIColor.white])
            attributedString.append(NSAttributedString(string: " avg. wpm\n", attributes: [NSAttributedString.Key.font: Appearance.titleFont(with: 16), NSAttributedString.Key.foregroundColor: UIColor.white]))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.string.count))
            
            averageWpmLabel.attributedText = attributedString
        }
    }
    
    let averageWpmLabel: UILabel =
    {
        let label = UILabel()
        label.numberOfLines = 0
        
        return label
    }()
    
    let wpmChart: Chart =
    {
        let chart = Chart(frame: .zero)
        chart.labelFont = Appearance.titleFont(with: 13)
        chart.axesColor = UIColor.init(white: 0.9, alpha: 0.6)
        chart.hideHighlightLineOnTouchEnd = true
        chart.gridColor = UIColor.init(white: 0.9, alpha: 0.6)
        chart.labelColor = .white
        
        return chart
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        backgroundColor = .darkColor
        layer.cornerRadius = 22
        
        setupViews()
    }
    
    private func setupViews()
    {
        addSubview(averageWpmLabel)
        addSubview(wpmChart)
        
        averageWpmLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 8, paddingRight: 8, paddingBottom: 0, width: 0, height: 90)
        wpmChart.anchor(top: averageWpmLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 8, paddingRight: 8, paddingBottom: -64, width: 0, height: 0)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
