//
//  AppwriteService.swift
//  social-media
//
//  Created by Aman Tiwari on 30/08/23.
//

import Foundation
import Appwrite

class AppwriteService {
    let socialDbId:String = "64eedd00c492d435b9cb"
    let usersCollectionId:String = "64eedd0a336c336d8ba2"
    let postsCollectionId:String = "64eedd371e6515904aef"
    let notificationCollectionId:String = "64eeddbf6197e97b8141"
    let postImagesBucketId:String = "64f41ddbb6a00e378bfd"
    let profilePictureBucketId:String = "64f471ca2ea289f560b8"
    let client:Client = Client()
        .setEndpoint("https://cloud.appwrite.io/v1")
        .setProject("64eed0320a7d14e49928")
    var database:Databases
    var account:Account
    var storage:Storage
    init(){
        database = Databases(client)
        account = Account(client)
        storage = Storage(client)
            
    }
}
