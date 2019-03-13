//
//  RadioPlayVC.swift
//  RadioTest
//
//  Created by Amir Daliri on 11.03.2019.
//  Copyright © 2019 AmirDaliri. All rights reserved.
//

import UIKit
import MediaPlayer

protocol NowPlayingViewControllerDelegate: class {
    func didPressPlayingButton()
    func didPressStopButton()
    func didPressNextButton()
    func didPressPreviousButton()
}

class RadioPlayVC: UIViewController {

    weak var delegate: NowPlayingViewControllerDelegate?

    // MARK: - IBOutlet
    
    @IBOutlet weak var albumHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var albumImageView: SpringImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playingButton: UIButton!
    @IBOutlet weak var songLabel: SpringLabel!
    @IBOutlet weak var stationDescLabel: UILabel!
    @IBOutlet weak var volumeParentView: UIView!
    
    // MARK: - Properties
    
    var currentRadio: RadioList!
    var currentTrack: Track!
    
    var newStation = true
    var nowPlayingImageView: UIImageView!
    let radioPlayer = FRadioPlayer.shared
    
    var mpVolumeSlider: UISlider?
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // I'm Here...
        
        // Create Now Playing BarItem
        createNowPlayingAnimation()
        
        // Set AlbumArtwork Constraints
        optimizeForDeviceSize()
        
        // Set View Title
        self.title = currentRadio.name
        
        // Set UI
        albumImageView.image = currentTrack.artworkImage
        stationDescLabel.text = currentRadio.desc
        stationDescLabel.isHidden = currentTrack.artworkLoaded
        
        // Check for station change
        newStation ? stationDidChange() : playerStateDidChange(radioPlayer.state, animate: false)
        
        // Setup volumeSlider
        setupVolumeSlider()
    }
    

    // MARK: - Setup Methode

    func setupVolumeSlider() {
        // Note: This slider implementation uses a MPVolumeView
        // The volume slider only works in devices, not the simulator.
        for subview in MPVolumeView().subviews {
            guard let volumeSlider = subview as? UISlider else { continue }
            mpVolumeSlider = volumeSlider
        }
        
        guard let mpVolumeSlider = mpVolumeSlider else { return }
        
        volumeParentView.addSubview(mpVolumeSlider)
        
        mpVolumeSlider.translatesAutoresizingMaskIntoConstraints = false
        mpVolumeSlider.leftAnchor.constraint(equalTo: volumeParentView.leftAnchor).isActive = true
        mpVolumeSlider.rightAnchor.constraint(equalTo: volumeParentView.rightAnchor).isActive = true
        mpVolumeSlider.centerYAnchor.constraint(equalTo: volumeParentView.centerYAnchor).isActive = true
        
        mpVolumeSlider.setThumbImage(#imageLiteral(resourceName: "slider-ball"), for: .normal)
    }
    
    func stationDidChange() {
        radioPlayer.radioURL = URL(string: currentRadio.streamURL)
        albumImageView.image = currentTrack.artworkImage
        stationDescLabel.text = currentRadio.desc
        stationDescLabel.isHidden = currentTrack.artworkLoaded
        title = currentRadio.name
    }
    
    // MARK: - Action Methode
    
    @IBAction func playingPressed(_ sender: Any) {
        delegate?.didPressPlayingButton()
    }
    
    @IBAction func stopPressed(_ sender: Any) {
        delegate?.didPressStopButton()
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        let songToShare = "I'm listening to \(currentTrack.title) on \(currentRadio.name) via Swift Radio Pro"
        let activityViewController = UIActivityViewController(activityItems: [songToShare, currentTrack.artworkImage!], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: view.center.x, y: view.center.y, width: 0, height: 0)
        activityViewController.popoverPresentationController?.sourceView = view
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        
        activityViewController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed:Bool, returnedItems:[Any]?, error: Error?) in
            if completed {
                // do something on completion if you want
            }
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: - Load Data Methode
    
    func load(station: RadioList?, track: Track?, isNewStation: Bool = true) {
        guard let station = station else { return }
        
        currentRadio = station
        currentTrack = track
        newStation = isNewStation
    }
    
    func updateTrackMetadata(with track: Track?) {
        guard let track = track else { return }
        
        currentTrack.artist = track.artist
        currentTrack.title = track.title
        
        updateLabels()
    }
    
    // Update track with new artwork
    func updateTrackArtwork(with track: Track?) {
        guard let track = track else { return }
        
        // Update track struct
        currentTrack.artworkImage = track.artworkImage
        currentTrack.artworkLoaded = track.artworkLoaded
        
        albumImageView.image = currentTrack.artworkImage
        
        if track.artworkLoaded {
            // Animate artwork
            albumImageView.animation = "wobble"
            albumImageView.duration = 2
            albumImageView.animate()
            stationDescLabel.isHidden = true
        } else {
            stationDescLabel.isHidden = false
        }
        
        // Force app to update display
        view.setNeedsDisplay()
    }
    
    private func isPlayingDidChange(_ isPlaying: Bool) {
        playingButton.isSelected = isPlaying
        startNowPlayingAnimation(isPlaying)
    }
    
    func playbackStateDidChange(_ playbackState: FRadioPlaybackState, animate: Bool) {
        
        let message: String?
        
        switch playbackState {
        case .paused:
            message = "Station Paused..."
            self.playingButton.setImage(#imageLiteral(resourceName: "btn-play"), for: .normal)
        case .playing:
            message = nil
            self.playingButton.setImage(#imageLiteral(resourceName: "btn-pause"), for: .normal)
        case .stopped:
            message = "Station Stopped..."
            self.playingButton.setImage(#imageLiteral(resourceName: "btn-play"), for: .normal)
        }
        
        updateLabels(with: message, animate: animate)
        isPlayingDidChange(radioPlayer.isPlaying)
    }
    
    func playerStateDidChange(_ state: FRadioPlayerState, animate: Bool) {
        
        let message: String?
        
        switch state {
        case .loading:
            message = "Loading Station ..."
        case .urlNotSet:
            message = "Station URL not valide"
        case .readyToPlay, .loadingFinished:
            playbackStateDidChange(radioPlayer.playbackState, animate: animate)
            self.playingButton.setImage(#imageLiteral(resourceName: "btn-pause"), for: .normal)
            return
        case .error:
            message = "Error Playing"
        }
        
        updateLabels(with: message, animate: animate)
    }
    
    // MARK: - UI Methode
    
    func optimizeForDeviceSize() {
        
        // Adjust album size to fit iPhone 4s, 6s & 6s+
        let deviceHeight = self.view.bounds.height
        
        if deviceHeight == 480 {
            albumHeightConstraint.constant = 106
            view.updateConstraints()
        } else if deviceHeight == 667 {
            albumHeightConstraint.constant = 230
            view.updateConstraints()
        } else if deviceHeight > 667 {
            albumHeightConstraint.constant = 260
            view.updateConstraints()
        }
    }
    
    func updateLabels(with statusMessage: String? = nil, animate: Bool = true) {
        
        guard let statusMessage = statusMessage else {
            // Radio is (hopefully) streaming properly
            songLabel.text = currentTrack.title
            artistLabel.text = currentTrack.artist
            shouldAnimateSongLabel(animate)
            return
        }
        
        // There's a an interruption or pause in the audio queue
        
        // Update UI only when it's not aleary updated
        guard songLabel.text != statusMessage else { return }
        
        songLabel.text = statusMessage
        artistLabel.text = currentRadio.name
        
        if animate {
            songLabel.animation = "flash"
            songLabel.repeatCount = 3
            songLabel.animate()
        }
    }
    
    // MARK: - Animation Methode
    
    func shouldAnimateSongLabel(_ animate: Bool) {
        // Animate if the Track has album metadata
        guard animate, currentTrack.title != currentRadio.name else { return }
        
        // songLabel animation
        songLabel.animation = "zoomIn"
        songLabel.duration = 1.5
        songLabel.damping = 1
        songLabel.animate()
    }
    
    func createNowPlayingAnimation() {
        
        // Setup ImageView
        nowPlayingImageView = UIImageView(image: UIImage(named: "NowPlayingBars-3"))
        nowPlayingImageView.autoresizingMask = []
        nowPlayingImageView.contentMode = UIView.ContentMode.center
        
        // Create Animation
        nowPlayingImageView.animationImages = AnimationFrames.createFrames()
        nowPlayingImageView.animationDuration = 0.7
        
        // Create Top BarButton
        let barButton = UIButton(type: .custom)
        barButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        barButton.addSubview(nowPlayingImageView)
        nowPlayingImageView.center = barButton.center
        
        let barItem = UIBarButtonItem(customView: barButton)
        self.navigationItem.rightBarButtonItem = barItem
    }
    
    func startNowPlayingAnimation(_ animate: Bool) {
        animate ? nowPlayingImageView.startAnimating() : nowPlayingImageView.stopAnimating()
    }
    
}
