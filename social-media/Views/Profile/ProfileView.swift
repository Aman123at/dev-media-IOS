//
//  ProfileView.swift
//  social-media
//
//  Created by Aman Tiwari on 02/09/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authVM:AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea(.all)
            VStack{
                HStack{
                    Image(systemName: "chevron.left").foregroundColor(.white)
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                        }
                    Spacer()
                    Text("MyProfile").foregroundColor(.white)
                        .font(.system(size: 30)).fontWeight(.bold)
                    Spacer()
                    HStack{
                        Text("Logut").foregroundColor(.red).bold()
                            .font(.system(size: 20))
                        Image(systemName: "power").foregroundColor(.red).bold()
                    }.onTapGesture {
                        Task{
                            await authVM.logoutUser()
                        }
                    }
                }.padding(.bottom)
            }
        }.navigationBarHidden(true)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView()
        }.environmentObject(AuthViewModel())
       
    }
}
