//
//  HomeScreenView.swift
//  social-media
//
//  Created by Aman Tiwari on 30/08/23.
//

import SwiftUI

struct HomeScreenView: View {
    @EnvironmentObject var authVM:AuthViewModel
    var body: some View {
        if authVM.isUserLoggedIn && authVM.loggedInUserID.isEmpty{
            LoginView()
        }
        else{
            if !authVM.isUserOnboarded {
                OnboardView()
            }else{
                ZStack{
                    Color.black.ignoresSafeArea(.all)
                   FeedView()
                }
            }
           
            
            
        }
        
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeScreenView()
                
        }.environmentObject(AuthViewModel())
            .navigationBarHidden(true)
        
    }
}
