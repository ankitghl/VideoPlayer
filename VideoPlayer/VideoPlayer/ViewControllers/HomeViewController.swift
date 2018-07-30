//
//  HomeViewController.swift
//  VideoPlayer
//
//  Created by Ankit.G on 29/07/18.
//  Copyright © 2018 Ankit.Gohel. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, HomeViewModelProtocol, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    //MARK:- Outlets

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK:- Private Properties
    private let cellIdentifierForVideoListing: String = "VideoListingCell"
    private let searchController = UISearchController(searchResultsController: nil)

    private var viewModel: HomeViewModel?

    var searchString: String = ""

    //MARK:- View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = Constants.AppVariables.appName
        registerCell()
        customiseSearchBar()
        
        viewModel = HomeViewModel()
        viewModel?.delegate = self
        
        fetchAllVideos()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Private Helpers
    
    private func registerCell() {
        tableView.register(UINib(nibName: cellIdentifierForVideoListing, bundle: nil), forCellReuseIdentifier: cellIdentifierForVideoListing)
    }

    private func customiseSearchBar() {
        //Setup Search Controller
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.barStyle = .black
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.searchBarStyle = .prominent
        navigationItem.searchController = searchController
    }
    
    private func showLoadingState() {
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingState() {
        activityIndicator.stopAnimating()
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: Constants.AppVariables.appName, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func fetchAllVideos() {
        showLoadingState()
        viewModel?.getListingData()
    }
    
    //MARK:- Home View Model Protocol Methods
    
    func didReceiveData() {
        hideLoadingState()
        tableView.reloadData()
    }
    
    func didFailToReceiveData(message: String) {
        hideLoadingState()
        showAlert(message: message)
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

    //MARK: SEARCH BAR DELEGATE

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        //Show Cancel
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.tintColor = .white
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        //Hide Cancel
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        
        guard let term = searchBar.text , term.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false else {
            return
        }
        
        viewModel?.clearAllVideos()
        searchString = term
        viewModel?.getListingData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        //Hide Cancel
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = ""
        searchBar.resignFirstResponder()
        
        if searchBar.text != searchString {
            viewModel?.clearAllVideos()
            searchString = ""
            fetchAllVideos()
        }
    }
}
