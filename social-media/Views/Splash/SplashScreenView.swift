//
//  SplashScreenView.swift
//  social-media
//
//  Created by Aman Tiwari on 30/08/23.
//

import SwiftUI

struct SplashScreenView: View {
    @State var isActive: Bool = false
    @State private var size = 0.7
    @State private var opacity = 0.4
    @EnvironmentObject var authVM:AuthViewModel
    var body: some View {
           if isActive {
               if authVM.isUserLoggedIn{
                   HomeScreenView()
               }else{
                   LoginView()
               }
           } else {
               ZStack{
                   Color.black.ignoresSafeArea(.all)
                   VStack{
                       
                       Image("brandLogo")
                           .resizable()
                           .frame(width: 340,height: 250)
                           .clipShape(RoundedRectangle(cornerRadius: 10))
    //                   Text("Dev Media")
    //                       .font(.system(size: 40))
    //                       .foregroundColor(.black)
    //                       .opacity(0.7)
    //                   Text("A social media platform for developers 👨‍💻")
                   }
                   .scaleEffect(size)
                   .opacity(opacity)
                   .onAppear{
                       withAnimation(.easeIn(duration: 1.0)){
                           self.size = 1.1
                           self.opacity = 1.0
                       }
                   }
                   .onAppear{
                       DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                           withAnimation{
                               self.isActive = true
                           }
                       }
                   }
                   .onAppear{
                       if !authVM.isUserLoggedIn && authVM.loggedInUserID.isEmpty {
                            Task{
    //                            await authVM.getUser()
                            }
                       }
                   }
               }
               .onAppear{
                   Task{
                       await authVM.getUser()
                   }
                   
               }
               
           }
       }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            SplashScreenView()
        }.environmentObject(AuthViewModel())
        
    }
}
