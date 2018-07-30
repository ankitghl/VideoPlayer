//
//  VideoListingCell.swift
//  VideoPlayer
//
//  Created by Ankit.G on 29/07/18.
//  Copyright © 2018 Ankit.Gohel. All rights reserved.
//

import UIKit

struct VideoListingViewModel {
    var imgURL: String?
    var title: String?
    var description: String?
    
    //MARK : - Helper Methods
    
    func downloadImage( onSuccess:@escaping (Data)->() ) {
        let networkWrapper = NetworkWrapper()
        networkWrapper.downloadImage(urlstring: imgURL!, onSuccess: { (responseImageData) in
            onSuccess(responseImageData)
            
        }, onFailure: { (errorMessage) in
            
        })
    }

}

class VideoListingCell: UITableViewCell {

    //MARK : - Outlets

    @IBOutlet weak var imgThumbnail: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    //MARK : - Properties
    
    var displayModel: VideoListingViewModel? {
        didSet {
            labelTitle.text = displayModel?.title
            labelDescription.text = displayModel?.description
//            if let _imgData: Data = displayModel?.imgURL {
//                imgIcon.image = UIImage(data: _imgData)
//                self.hideLoadingState()
//            }
        }
    }

    // MARK:- View Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        imgThumbnail.image = nil
    }

    
}
