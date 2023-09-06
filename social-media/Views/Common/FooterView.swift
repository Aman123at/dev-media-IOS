//
//  FooterView.swift
//  social-media
//
//  Created by Aman Tiwari on 02/09/23.
//

import SwiftUI

struct FooterView: View {
    var body: some View {
        ZStack{
            Color.black.opacity(0.7).ignoresSafeArea(.all)
            HStack(spacing:30){
                NavigationLink{
                    HomeScreenView()
                }label: {
                    Image(systemName: "house.fill")
                        .foregroundColor(.white)
                        .imageScale(.large)
                        .font(.system(size: 25))
                }
                
                
                NavigationLink{
                    SearchView()
                }label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                        .imageScale(.large)
                        .font(.system(size: 25))
                }
                
                NavigationLink{
                    PostAddView()
                }label: {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(.white)
                        .imageScale(.large)
                        .font(.system(size: 25))
                }
                
                NavigationLink{
                    ChatView()
                }label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .imageScale(.large)
                        .font(.system(size: 25))
                }
                
                NavigationLink{
                    ProfileView()
                }label: {
                    Image(systemName: "person.fill")
                        .foregroundColor(.white)
                        .imageScale(.large)
                        .font(.system(size: 25))
                }
                
            }
                
        }
    }
}

struct FooterView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FooterView()
        }
        
    }
}
