//
//  SpeakerTalkTypeCell.swift
//  DEVit
//
//  Created by Athanasios Theodoridis on 28/10/2016.
//  Copyright © 2016 devitconf. All rights reserved.
//

import Foundation
import UIKit

class SpeakerTalkTypeCell: UITableViewCell {
    
    @IBOutlet weak var activeSessionIndicatorView: ActiveSessionIndicatorView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startingTimeLabel: UILabel!
    @IBOutlet weak var speakerNameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var profilePicImageView: SpeakerProfileImageView!
    @IBOutlet weak var giveFeedbackLabel: UILabel!
    
    // MARK: - Private Properties
    private lazy var DateManager = {
        DateFormatterManager.sharedFormatter
    }()
    
    private lazy var ModelsManager = {
        FirebaseManager.sharedInstance
    }()
    
    // MARK: - Public Properties
    public var talk: Talk?  {
        didSet {
            _setupCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        _configureCell()
    }
    
    // MARK: - Private Methods
    private func _configureCell() {
        
        backgroundColor = Colors.lightBlue
        titleLabel.textColor = Colors.darkBlue
        startingTimeLabel.textColor = Colors.darkGray
        speakerNameLabel.textColor = Colors.lightGray
        durationLabel.textColor = Colors.lightGray
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        
    }
    
    private func _setupCell() {
        
        if let startTime = talk!.startTime {
            
            startingTimeLabel.text = DateManager.dateWith_Hmm_formatAsString(fromDate: startTime)
            
            let timeResult = DateManager.isCurrentTimeWithinTimeRange(startingTime: startTime,
                                                                      duration: talk!.duration!)
            let ratingDeadline = DateManager.isCurrentTimeWithinTimeRange(startingTime: startTime,
                                                                          duration: Constants.Config.ratingDeadlineInMinutes) // 2hrs after the presentation
            
            // current time is during the talk
            if timeResult == .withinRange {
                activeSessionIndicatorView.setActive()
            // current time is earlier than the talk has started
            }  else if  timeResult == .earlier || timeResult == .later {
                activeSessionIndicatorView.setInactive()
            } else if timeResult == .later {
                activeSessionIndicatorView.setInactive()
            }
            
            if timeResult == .later && (ratingDeadline == .withinRange || ratingDeadline == .earlier) {
                giveFeedbackLabel.isHidden = false
            } else {
                giveFeedbackLabel.isHidden = true
            }
            
        }

        titleLabel.text = talk!.name!
        speakerNameLabel.text = talk!.speaker!.name
        durationLabel.text = "\(talk!.duration!) m"
        
        profilePicImageView.setImageFromFirebaseStorage(withFilename: talk!.speaker!.id!,
                                                        andStorageReferece: ModelsManager.speakerProfilePicsRef)
        
        
    }
}
