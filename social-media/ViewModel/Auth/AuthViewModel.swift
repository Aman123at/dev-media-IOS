//
//  AuthViewModel.swift
//  social-media
//
//  Created by Aman Tiwari on 30/08/23.
//

import Foundation
import Appwrite

class AuthViewModel: ObservableObject{
    @Published var activeUserInfo: UserInfoModel = UserInfoModel(userName: "", fullName: "", email: "", userId: "", connections: [], posts: [], fromOauth: false, oauthName: "", headline: "", location: "", profileImgId: "")
    @Published var isUserLoggedIn:Bool = false
    @Published var loggedInUserID:String = ""
    @Published var isUserOnboarded:Bool = false
  
    let appwriteService = AppwriteService()
    init(){}
    
    func getUser()async{
        do{
            let user = try await appwriteService.account.get()
                if user.status {
                    DispatchQueue.main.async {
                        self.isUserLoggedIn = true
                        self.loggedInUserID = user.id
                    }
                    
                    await isUserOnboarded(user.id)
                }
         
        }catch{
            print(error.localizedDescription,"Error calling getuser")
        }
 
    }
    
    func fetchUserInfo()async{
        do{
            let userInfoResponse = try await appwriteService.database.getDocument(databaseId: appwriteService.socialDbId, collectionId: appwriteService.usersCollectionId, documentId: self.loggedInUserID)
            var extracted:[String:Any] = [:]
            for (key,value) in userInfoResponse.data {
                switch key {
                        case "userName":
                            extracted["userName"] = value.value
                        case "oauthName":
                            extracted["oauthName"] = value.value
                        case "userId":
                            extracted["userId"] = value.value
                        case "location":
                            extracted["location"] = value.value
                        case "profileImgId":
                            extracted["profileImgId"] = value.value
                        case "email":
                            extracted["email"] = value.value
                        case "posts":
                            extracted["posts"] = value.value
                        case "headline":
                            extracted["headline"] = value.value
                        case "fullName":
                            extracted["fullName"] = value.value
                        case "connections":
                            extracted["connections"] = value.value
                        case "fromOauth":
                            extracted["fromOauth"] = value.value
                        default:
                            print("")
                }

            }
            
            let userName = extracted["userName"] as? String ?? ""
            let oauthName = extracted["oauthName"] as? String ?? ""
            let userId = extracted["userId"] as? String ?? ""
            let location = extracted["location"] as? String ?? ""
            let profileImgId = extracted["profileImgId"] as? String ?? ""
            let email = extracted["email"] as? String ?? ""
            let posts = extracted["posts"] as? [String] ?? []
            let headline = extracted["headline"] as? String ?? ""
            let fullName = extracted["fullName"] as? String ?? ""
            let connections = extracted["connections"] as? [String] ?? []
            let fromOauth = extracted["fromOauth"] as? Bool ?? false
            
            let userInformation = UserInfoModel(userName: userName, fullName: fullName, email: email, userId: userId, connections: connections, posts: posts, fromOauth: fromOauth, oauthName: oauthName, headline: headline, location: location, profileImgId: profileImgId)
            DispatchQueue.main.async {
                self.activeUserInfo = userInformation
            }
            
        }catch{
            print("Enable to fetch userinfo",error.localizedDescription)
        }
    }
    
    func isUserOnboarded(_ userID:String) async -> Void {
        do{
            let onboardResponse = try await appwriteService.database.listDocuments(databaseId: appwriteService.socialDbId, collectionId: appwriteService.usersCollectionId,queries: [Query.equal("userId", value:userID)])
            if onboardResponse.total>0{
                let docData = onboardResponse.documents[0].data
                for (key,value) in docData {
                    
                    if key=="isOnboarded" {
                        let onboard = value.value as? Bool ?? false
                        DispatchQueue.main.async {
                            self.isUserOnboarded = onboard
                        }
                    }
                }
            }

            
        }catch{
            print("Unable to fetch Onboard",error.localizedDescription)
        }
    }
    
    func onBoardUpdate(location:String="",headline:String="",profileImage:Data,globalAlertObj:GlobalAlertViewModel) async {
        if profileImage.isEmpty{
            globalAlertObj.setAlertErrorMessage("Profile picture is required!")
            globalAlertObj.toggleShowError()
            return
        }
        let fileId :String = UUID().uuidString
        do{
            let _ = try await appwriteService.storage.createFile(bucketId: appwriteService.profilePictureBucketId, fileId: fileId, file: InputFile.fromData(profileImage, filename: "profile-\(self.loggedInUserID)-\(arc4random_uniform(1000)).png", mimeType: "image/png"))
        }catch{
            print(error.localizedDescription)
        }
        do{
            let updateResponse = try await appwriteService.database.updateDocument(databaseId: appwriteService.socialDbId, collectionId: appwriteService.usersCollectionId, documentId: self.loggedInUserID,data: ["location":location,"headline":headline,"isOnboarded":true,"profileImgId":fileId] as [String : Any])
            if !updateResponse.id.isEmpty{
                await self.getUser()
            }
            
        }catch{
            globalAlertObj.setAlertErrorMessage(error.localizedDescription)
            globalAlertObj.toggleShowError()
            print("Unable to onboard update",error.localizedDescription)
        }
    }
    
    func registerUser(userData:SignUpModel,globalAlertObj:GlobalAlertViewModel)async{
        do{
            // create a new account
            let userResponse = try await appwriteService.account.create(userId: userData.userId, email: userData.email, password: userData.password,name: userData.fullName)
            if userResponse.status {
                // register user in database
                let requestData:[String:Any] = [
                    "userId":userData.userId,
                    "userName":userData.userName,
                    "email":userData.email,
                    "fromOauth":false,
                    "oauthName":"",
                    "fullName":userData.fullName,
                    "isOnboarded":false,
                    "location":"",
                    "headline":"Hello Developers, Welcome to Dev Media 👋🏻"
                ]
                do{
                  let dbResponse = try await appwriteService.database.createDocument(
                        databaseId: appwriteService.socialDbId,
                        collectionId: appwriteService.usersCollectionId,
                        documentId: userData.userId,
                        data: requestData
                        )
                    
                    if dbResponse.id.count>0{
                        DispatchQueue.main.async {
                            self.isUserLoggedIn = true
                        }
                    }
                }catch{
                    globalAlertObj.setAlertErrorMessage(error.localizedDescription)
                    globalAlertObj.toggleShowError()
                    print("Error while inserting to db",error.localizedDescription)
                }
                
            }
        }catch{
            globalAlertObj.setAlertErrorMessage(error.localizedDescription)
            globalAlertObj.toggleShowError()
            print("Something went wrong",error.localizedDescription)
        }
    }
    
    func loginUser(userData:LoginModel,globalAlertObj:GlobalAlertViewModel)async{
        do{
            let loginData = try await appwriteService.account.createEmailSession(email: userData.email, password: userData.password)
            if loginData.current {
                DispatchQueue.main.async {
                    self.isUserLoggedIn = true
                    self.loggedInUserID = loginData.userId
                }
                await isUserOnboarded(loginData.userId)
            }
        }catch{
            globalAlertObj.setAlertErrorMessage(error.localizedDescription)
            globalAlertObj.toggleShowError()
            print("Error in login",error.localizedDescription)
        }
    }
    
    func logoutUser()async{
        do{
            let _ = try await appwriteService.account.deleteSessions()
            DispatchQueue.main.async {
                self.isUserLoggedIn = false
                self.loggedInUserID = ""
            }
            
        }catch{
            print("Error in logout",error.localizedDescription)
        }
    }
    
}
