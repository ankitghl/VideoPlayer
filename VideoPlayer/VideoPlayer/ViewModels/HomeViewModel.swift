//
//  HomeViewModel.swift
//  VideoPlayer
//
//  Created by Ankit.G on 29/07/18.
//  Copyright © 2018 Ankit.Gohel. All rights reserved.
//

import UIKit

protocol HomeViewModelProtocol: class {
    var searchString: String { get set }
    
    func didReceiveData()
    func didFailToReceiveData(message: String)
}

class HomeViewModel: NSObject {

    //MARK:- Properties
    private var networkWrapper: NetworkWrapper = NetworkWrapper()
    private var searchData: SearchData?
    private let indexForPagination: Int = 2

    weak var delegate: HomeViewModelProtocol?
    var videos: [VideoListingViewModel]?

    //MARK:- Private Helper Methods

    private func getUrl() -> String {
        let searchAPI: SearchAPI = SearchAPI(searchTerm: delegate?.searchString ?? "",
                                             pageToken: searchData?.nextPageToken ?? "")
        return searchAPI.getURL()
    }
    
    private func getVideos() -> [VideoListingViewModel] {
        var videoArray: [VideoListingViewModel] = []

        if let _searchData: SearchData = searchData,
            let _videoItem: [Item] = _searchData.items {
        
            for item in _videoItem {
                if let _videoSnippet: Snippet = item.snippet {
                    var displayModel: VideoListingViewModel = VideoListingViewModel()
                    displayModel.description = _videoSnippet.descriptionField
                    displayModel.title = _videoSnippet.title
                    
                    if let _thumbnail: Thumbnail = _videoSnippet.thumbnails,
                        let _default: Default =  _thumbnail.defaultField,
                        let _url: String = _default.url {
                        displayModel.imgURL = _url
                    }
                    videoArray.append(displayModel)
                }
            }
        }
        return videoArray
    }

    private func getVideoItem(for index: Int) -> Item {
        var _videoItem: Item = Item(fromDictionary: [:])
        if let _videos: [Item] = searchData?.items {
            _videoItem = _videos[index]
        }
        return _videoItem
    }

    //MARK:- Getter Methods
    
    func checkAndGetNextVideos(index: Int) {
        guard (videos?.count)! < (searchData?.pageInfo.totalResults)! else {
            return
        }

        if (((videos?.count)! - indexForPagination) == index) {
            getListingData()
        }
    }

    func getVideo(for index: Int) -> VideoListingViewModel {
        var _displayModel: VideoListingViewModel = VideoListingViewModel()
        if let _videos: [VideoListingViewModel] = videos {
            _displayModel = _videos[index]
        }
        return _displayModel
    }
    
    func clearAllVideos() {
        searchData = nil
        videos?.removeAll()
    }
    
    func addDependencyForVideoController(for index: Int) -> VideoPlayerViewModel {
        let videoItem: Item = getVideoItem(for: index)
        let videoPlayerViewModel: VideoPlayerViewModel = VideoPlayerViewModel(videoItem: videoItem)
        return videoPlayerViewModel
    }
    
    //MARK:- API Calls

    func getListingData() {
        
        networkWrapper.callAPI(with: getUrl(),
                               onSuccess: { (response) in
                                if let _response = response as? [String : Any] {
                                    if let _error: [String: Any] = _response["error"] as? [String : Any],
                                        let _message: String = _error["message"] as? String{
                                        self.delegate?.didFailToReceiveData(message: _message)
                                    } else {
                                        let _searchData: SearchData = SearchData(fromDictionary: _response)
                                        
                                        if let _prevPageToken: String = _searchData.prevPageToken,
                                            let _items: [Item] = _searchData.items,
                                            _items.count > 0 {
                                            self.searchData?.items.append(contentsOf: _items)
                                            self.searchData?.nextPageToken = _searchData.nextPageToken
                                            self.searchData?.prevPageToken = _prevPageToken
                                        } else {
                                            self.searchData = _searchData
                                            
                                        }
                                        self.videos = self.getVideos()
                                        self.delegate?.didReceiveData()
                                    }
                                } else {
                                    self.delegate?.didFailToReceiveData(message: Constants.AppVariables.jsonError)
                                    
                                }
        }, onFailure: { (errorMessage) in
            self.delegate?.didFailToReceiveData(message: Constants.AppVariables.apiError)
        })
    }

}
