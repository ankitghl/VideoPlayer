//
//  VideoPlayerViewController.swift
//  VideoPlayer
//
//  Created by Ankit.G on 30/07/18.
//  Copyright © 2018 Ankit.Gohel. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class VideoPlayerViewController: UIViewController, YTPlayerViewDelegate, VideoPlayerViewModelProtocol, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var videoPlayerView: YTPlayerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableFooterView: UIView!
    @IBOutlet weak var activityIndicatorFooter: UIActivityIndicatorView!
    
    //MARK:- Private Properties
    var viewModel: VideoPlayerViewModel?
    private let cellIdentifierForVideoListing: String = "VideoListingCell"

    //MARK:- View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel?.getTitle()
        viewModel?.delegate = self
        
        adjustNavigationBar()
        registerCell()
        setUpVideoPlayer()
        fetchAllVideos()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Private Helpers
    
    private func registerCell() {
        tableView.register(UINib(nibName: cellIdentifierForVideoListing, bundle: nil), forCellReuseIdentifier: cellIdentifierForVideoListing)
    }

    private func setUpVideoPlayer() {
        if let _viewModel: VideoPlayerViewModel = viewModel {
            videoPlayerView.delegate = self

            let videoID: String = _viewModel.getVideoID()
            videoPlayerView.load(withVideoId: videoID)
            showLoadingState(for: activityIndicator)
        } else {
            showAlert(message: "Channel ID Invalid")
        }
    }
    
    private func adjustNavigationBar() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                                style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem!.title = ""
    }
    
    private func showLoadingState(for indicator: UIActivityIndicatorView) {
        indicator.startAnimating()
    }
    
    private func hideLoadingState(for indicator: UIActivityIndicatorView) {
        indicator.stopAnimating()
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: Constants.AppVariables.appName, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    private func fetchAllVideos() {
        showChannelLoadingState()
        viewModel?.getChannelVideos()
    }

    private func showChannelLoadingState() {
        tableView.tableFooterView = tableFooterView
        showLoadingState(for: activityIndicatorFooter)
    }
    
    private func hideChannelLoadingState() {
        tableView.tableFooterView = nil
        hideLoadingState(for: activityIndicatorFooter)
    }
    //MARK:- Tableview Datasource and Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _rows: Int = viewModel?.videos?.count {
            return _rows
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: VideoListingCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierForVideoListing,
                                                                      for: indexPath) as? VideoListingCell {
            cell.selectionStyle = .none
            cell.displayModel = viewModel?.getVideo(for: indexPath.row)
            
            cell.displayModel?.downloadImage(onSuccess: { (imageData) in
                cell.imgThumbnail.image = UIImage(data: imageData)
            })
            viewModel?.checkAndGetNextVideos(index: indexPath.row)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard: UIStoryboard = UIStoryboard(name: Constants.StoryboardNames.main, bundle: nil)
        if let _videoPlayer: VideoPlayerViewController = storyboard.instantiateViewController(withIdentifier: "VideoPlayerViewController") as? VideoPlayerViewController {
            _videoPlayer.viewModel = viewModel?.addDependencyForVideoController(for: indexPath.row)
            navigationController?.pushViewController(_videoPlayer, animated: true)
        }
    }

    //MARK:- YTPlayerView Delegate Methods

    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        hideLoadingState(for: activityIndicator)
    }
    
    func playerView(_ playerView: YTPlayerView, receivedError error: YTPlayerError) {
        hideLoadingState(for: activityIndicator)
    }
    
    //MARK:- VideoPlayerViewModel Delegate Methods

    func didReceiveData() {
        hideLoadingState(for: activityIndicatorFooter)
        tableView.reloadData()
    }
    
    func didFailToReceiveData(message: String) {
        hideLoadingState(for: activityIndicatorFooter)
        showAlert(message: message)
    }
}
