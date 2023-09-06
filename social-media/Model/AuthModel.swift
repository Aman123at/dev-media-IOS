//
//  AuthModel.swift
//  social-media
//
//  Created by Aman Tiwari on 30/08/23.
//

import Foundation


struct SignUpModel{
    let userName:String
    let fullName:String
    let email:String
    let password:String
    let userId:String = UUID().uuidString
}

struct LoginModel{
    let email:String
    let password:String
}

struct UserInfoModel{
    let userName:String
    let fullName:String
    let email:String
    let userId:String
    let connections:[String]
    let posts:[String]
    let fromOauth:Bool
    let oauthName:String
    let headline:String
    let location:String
    let profileImgId:String
}
