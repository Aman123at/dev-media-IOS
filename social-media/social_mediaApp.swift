//
//  social_mediaApp.swift
//  social-media
//
//  Created by Aman Tiwari on 30/08/23.
//

import SwiftUI

@main
struct social_mediaApp: App {
    @StateObject var authviewmodel:AuthViewModel = AuthViewModel()
    @StateObject var globalalertviewmodel:GlobalAlertViewModel = GlobalAlertViewModel()
    @StateObject var postviewmodel:PostViewModel = PostViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationView{
                SplashScreenView()
            }.environmentObject(authviewmodel)
                .environmentObject(globalalertviewmodel)
                .environmentObject(postviewmodel)
            
        }
    }
}
