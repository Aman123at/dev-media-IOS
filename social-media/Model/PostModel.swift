//
//  PostModel.swift
//  social-media
//
//  Created by Aman Tiwari on 03/09/23.
//

import Foundation

struct PostAddModel{
    let postId :String =  UUID().uuidString
    let postDesc:String
    let postImages:[Data]
    var creationTime:String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        return formattedDate
    }
}

struct PostItemModel{
    let postImages:[String]
    let creationTime:String
    let userId:String
    let postId:String
    let comments:[String]
    let likes:[String]
    let postDesc:String
    let userName:String
    let createrProfileImage:String
}

