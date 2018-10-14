//
//  AnimationDurationCell.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 14/10/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

public class AnimationDurationCell: UITableViewCell {
    
    // MARK: - Internal properties
    
    private static let titleHeight: CGFloat = 20.0
    private static let titleTopMargin: CGFloat = 20.0
    private static let titleLeftMargin: CGFloat = 15.0
    
    private static let durationSliderTopMargin: CGFloat = 20.0
    private static let durationSliderBottomMargin: CGFloat = -3.0
    private static let durationSliderLeftMargin: CGFloat = 15.0
    private static let durationSliderWidth: CGFloat = 210.0
    
    private static let durationLabelBottomMargin: CGFloat = -3.0
    private static let durationLabelRightMargin: CGFloat = 3.0
    private static let durationLabelLeftMargin: CGFloat = 5.0
    
    private static let secondsLabelBottomMargin: CGFloat = -3.0
    private static let secondsLabelRightMargin: CGFloat = -15.0
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Duration"
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var durationSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.value = 0.00
        return slider
    }()
    
    private lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\(durationSlider.value)"
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var secondsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "secs"
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }()
    
    // MARK: - External properties
    
    /// A delegate to modify the model
    public var delegate: SceneBackgroundColorDelegate?
    
    // MARK: - Setup
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addSubview(titleLabel)
        addSubview(durationSlider)
        addSubview(durationLabel)
        addSubview(secondsLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: AnimationDurationCell.titleLeftMargin),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: AnimationDurationCell.titleTopMargin),
            titleLabel.heightAnchor.constraint(equalToConstant: AnimationDurationCell.titleHeight),
            
            durationSlider.leftAnchor.constraint(equalTo: leftAnchor, constant: AnimationDurationCell.durationSliderLeftMargin),
            durationSlider.widthAnchor.constraint(equalToConstant: AnimationDurationCell.durationSliderWidth),
            durationSlider.topAnchor.constraint(equalTo: titleLabel
                .bottomAnchor, constant: AnimationDurationCell.durationSliderTopMargin),
            
            durationLabel.rightAnchor.constraint(equalTo: secondsLabel.leftAnchor, constant: AnimationDurationCell.durationLabelRightMargin),
            durationLabel.leftAnchor.constraint(equalTo: durationSlider.rightAnchor, constant: AnimationDurationCell.durationLabelLeftMargin),
            durationLabel.centerYAnchor.constraint(equalTo: durationSlider.centerYAnchor),
            durationLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: AnimationDurationCell.durationLabelBottomMargin),
            
            secondsLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: AnimationDurationCell.secondsLabelRightMargin),
            secondsLabel.centerYAnchor.constraint(equalTo: durationLabel.centerYAnchor),
            secondsLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: AnimationDurationCell.secondsLabelBottomMargin),
        ])
    }
    
    // MARK: - Dependency injection
    
    /// The model contains data used to populate the view.
//    public var model: SceneInspectorViewModel? {
//        didSet {
//            if let model = model {
//
//            }
//        }
//    }
    
}
