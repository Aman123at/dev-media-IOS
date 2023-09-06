//
//  PostViewModel.swift
//  social-media
//
//  Created by Aman Tiwari on 02/09/23.
//

import Foundation
import Appwrite
class PostViewModel:ObservableObject{
    @Published var postItems:[PostItemModel] = []
    let appwriteService = AppwriteService()
    init(){}
    
    func createPost(_ postAddData:PostAddModel,loginUserId:String,loginUserName:String,loginUserProfileImg:String,globalAlertObj:GlobalAlertViewModel) async ->Void  {
        // if image is available then push to storage
        var imageFileIds:[String] = []
        if !postAddData.postImages.isEmpty{
            for image in postAddData.postImages{
                let fileId :String = UUID().uuidString
                do{
                    let _ = try await appwriteService.storage.createFile(bucketId: appwriteService.postImagesBucketId, fileId: fileId, file: InputFile.fromData(image, filename: "myfile-\(postAddData.postId)-\(arc4random_uniform(1000)).png", mimeType: "image/png"))
                    imageFileIds.append(fileId)
                }catch{
                    print("Error in adding images to storage",error.localizedDescription)
                }
            }
        }
        
        let requestData:[String:Any] = [
            "postId":postAddData.postId,
            "postDesc":postAddData.postDesc,
            "postImages":imageFileIds,
            "creationTime":postAddData.creationTime,
            "userId":loginUserId,
            "userName":loginUserName,
            "createrProfileImage":loginUserProfileImg
        ]
        do{
            let postCreateRes = try await appwriteService.database.createDocument(databaseId: appwriteService.socialDbId, collectionId: appwriteService.postsCollectionId, documentId: UUID().uuidString, data: requestData)
            if !postCreateRes.id.isEmpty{
                let postItem = PostItemModel(postImages: imageFileIds, creationTime: postAddData.creationTime, userId: loginUserId, postId: postAddData.postId, comments: [], likes: [], postDesc: postAddData.postDesc,userName: loginUserName,createrProfileImage: loginUserProfileImg)
                DispatchQueue.main.async {
                    self.postItems.append(postItem)
                    globalAlertObj.setAlertErrorMessage("Post added successfully.")
                    globalAlertObj.toggleShowError()
                }
            }
        }catch{
            print("Error in create Post",error.localizedDescription)
            globalAlertObj.setAlertErrorMessage("Unable to add post! Please retry")
            globalAlertObj.toggleShowError()
        }
       

       
    }
    
    func getPosts()async{
        do{
            let postsResponse = try await appwriteService.database.listDocuments(databaseId: appwriteService.socialDbId, collectionId: appwriteService.postsCollectionId)
            if postsResponse.total>0{
                DispatchQueue.main.async {
                    self.postItems = []
                }
               
                for doc in postsResponse.documents{
                    var extracted:[String:Any] = [:]
                    for (key,value) in doc.data {
                        switch key {
                                case "postImages":
                                    extracted["postImages"] = value.value
                                case "creationTime":
                                    extracted["creationTime"] = value.value
                                case "userId":
                                    extracted["userId"] = value.value
                                case "postId":
                                    extracted["postId"] = value.value
                                case "comments":
                                    extracted["comments"] = value.value
                                case "likes":
                                    extracted["likes"] = value.value
                                case "postDesc":
                                    extracted["postDesc"] = value.value
                                case "userName":
                                    extracted["userName"] = value.value
                                case "createrProfileImage":
                                    extracted["createrProfileImage"] = value.value
                                default:
                                    print("")
                        }
 
                    }
                    let postImages = extracted["postImages"] as? [String] ?? []
                    let creationTime = extracted["creationTime"] as? String ?? ""
                    let userId = extracted["userId"] as? String ?? ""
                    let postId = extracted["postId"] as? String ?? ""
                    let comments = extracted["comments"] as? [String] ?? []
                    let likes = extracted["likes"] as? [String] ?? []
                    let postDesc = extracted["postDesc"] as? String ?? ""
                    let userName = extracted["userName"] as? String ?? ""
                    let createrProfileImage = extracted["createrProfileImage"] as? String ?? ""
                    
                    let postItem = PostItemModel(postImages: postImages, creationTime: creationTime, userId: userId, postId: postId, comments: comments, likes: likes, postDesc: postDesc,userName: userName,createrProfileImage: createrProfileImage)
                    DispatchQueue.main.async {
                        self.postItems.append(postItem)
                    }
                    
                }
            }
            
        }catch{
            print(error.localizedDescription)
        }
    }
}
