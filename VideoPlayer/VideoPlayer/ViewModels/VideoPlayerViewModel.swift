//
//  ViewPlayerViewModel.swift
//  VideoPlayer
//
//  Created by Ankit.G on 30/07/18.
//  Copyright © 2018 Ankit.Gohel. All rights reserved.
//

import UIKit

protocol VideoPlayerViewModelProtocol: class {
    func didReceiveData()
    func didFailToReceiveData(message: String)
}

class VideoPlayerViewModel: NSObject {

    //MARK:- Properties
    private var networkWrapper: NetworkWrapper = NetworkWrapper()
    private var videoItem: Item?

    private var channelSearchData: SearchData?
    private let indexForPagination: Int = 2
    
    weak var delegate: VideoPlayerViewModelProtocol?
    var videos: [VideoListingViewModel]?

    //MARK:- Initialisers
    init(videoItem: Item) {
        self.videoItem = videoItem
    }

    //MARK:- Private Helper Methods
    
    private func getUrl() -> String {
        let _channelID: String = getChannelID()
        let channelAPI: ChannelAPI = ChannelAPI(channelID: _channelID, pageToken: channelSearchData?.nextPageToken ?? "")
        return channelAPI.getURL()
    }

    private func getChannelID() -> String {
        var channelID: String = ""
        if let _snippet: Snippet = videoItem?.snippet, let _channelID: String = _snippet.channelId {
            channelID = _channelID
        }
        return channelID
    }

    private func getVideos() -> [VideoListingViewModel] {
        var videoArray: [VideoListingViewModel] = []
        
        if let _searchData: SearchData = channelSearchData,
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
        if let _videos: [Item] = channelSearchData?.items {
            _videoItem = _videos[index]
        }
        return _videoItem
    }

    //MARK:- Getter Methods
    func getTitle() -> String {
        var title: String = ""
        if let _snippet: Snippet = videoItem?.snippet,
            let _channelTitle: String = _snippet.title {
            title = _channelTitle
        }
        return title
    }
    
    func getVideoID() -> String {
        var videoId: String = ""
        if let _id: Id = videoItem?.id, let _videoID: String = _id.videoId {
            videoId = _videoID
        }
        return videoId
    }
    
    func checkAndGetNextVideos(index: Int) {
        guard (videos?.count)! < (channelSearchData?.pageInfo.totalResults)! else {
            return
        }
        if (((videos?.count)! - indexForPagination) == index) {
            getChannelVideos()
        }
    }

    func getVideo(for index: Int) -> VideoListingViewModel {
        var _displayModel: VideoListingViewModel = VideoListingViewModel()
        if let _videos: [VideoListingViewModel] = videos {
            _displayModel = _videos[index]
        }
        return _displayModel
    }

    func addDependencyForVideoController(for index: Int) -> VideoPlayerViewModel {
        let videoItem: Item = getVideoItem(for: index)
        let videoPlayerViewModel: VideoPlayerViewModel = VideoPlayerViewModel(videoItem: videoItem)
        return videoPlayerViewModel
    }

    //MARK:- API Calls
    
    func getChannelVideos() {
        
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
                                            self.channelSearchData?.items.append(contentsOf: _items)
                                            self.channelSearchData?.nextPageToken = _searchData.nextPageToken
                                            self.channelSearchData?.prevPageToken = _prevPageToken
                                        } else {
                                            self.channelSearchData = _searchData
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
