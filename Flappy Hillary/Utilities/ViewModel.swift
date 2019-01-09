//
//  ViewModel.swift
//  Flappy Hillary
//
//  Created by Gabriel I Leyva Merino on 1/9/18.
//  Copyright © 2018 Will Clark. All rights reserved.
//

import Foundation
import Alamofire

class ViewModel: NSObject {

    var bookUrl: String!
    var shareUrl: String!
    
    func getUrls() {
      bookUrl = ""
      shareUrl = ""
      self.getUrl(apiCall: "getBookUrl")
      self.getUrl(apiCall: "getShareUrl")
    }
    
    private func getUrl(apiCall: String) {
        let url = "https://us-central1-swamp-war.cloudfunctions.net/" + apiCall
        Alamofire.request(url).responseData { response in            
            if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                if apiCall == "getBookUrl" {
                    self.bookUrl = utf8Text
                } else {
                    self.shareUrl = utf8Text
                }
            }
        }
        
    }
    
    
}
