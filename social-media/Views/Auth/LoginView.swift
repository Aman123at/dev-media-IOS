//
//  LoginView.swift
//  social-media
//
//  Created by Aman Tiwari on 30/08/23.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authVM:AuthViewModel
    @EnvironmentObject var globalAlertVM:GlobalAlertViewModel
    @State var email:String = ""
    @State var password:String = ""
    

    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea(.all)
            Image("dev")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .opacity(0.2)
                .overlay {
                    VStack{
                      
                        Text("Login")
                            .foregroundColor(.white)
                            .bold()
                            .font(.system(size: 45))
                        VStack{
                            HStack{
                                Text("＠")
                                    .bold()
                                    .foregroundColor(.white)
                                    .font(.system(size: 35))
                                    
                                TextField("Email", text: $email)
                                    .foregroundColor(.white)
                                    .disableAutocorrection(true)
                                    .textInputAutocapitalization(.never)
                                    .frame(width: 320)
                                    .modifier(PlaceholderStyle(showPlaceHolder: email.isEmpty,
                                        placeholder: "Email"))
      
                            }.padding(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 100)
                                        .stroke(Color.green, lineWidth: 4)
                                )
                                
                            Spacer().frame(height: 20)
                            HStack{
                                Text("＊")
                                    .bold()
                                    .foregroundColor(.white)
                                    .font(.system(size: 35))
                                    
                                SecureField("Password", text: $password)
                                    .foregroundColor(.white)
                                    .disableAutocorrection(true)
                                    .textInputAutocapitalization(.never)
                                    .frame(width: 320)
                                    .modifier(PlaceholderStyle(showPlaceHolder: password.isEmpty,
                                        placeholder: "Password"))
                                    
                                    
                            }.padding(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 100)
                                        .stroke(Color.green, lineWidth: 4)
                                )
                           
                        }.padding()
                        
                        Spacer().frame(height: 30)
                        
                        Text("LOGIN")
                            .foregroundColor(.white)
                            .bold()
                            .padding(.vertical,20)
                            .padding(.horizontal,160)
                            .background(RoundedRectangle(cornerRadius: 100).fill(Color.green))
                            .onTapGesture {
                                handleLogin()
                            }
                        
                        Rectangle().fill(Color.white.opacity(0.5)).frame(height: 3).padding(.top,35).overlay {
                            Text("OR").foregroundColor(.black).bold().padding().background(RoundedRectangle(cornerRadius: 100).fill(Color.white.opacity(0.9)))
                                .offset(y:15)
                        }.padding()
                        
                        HStack{
                            Image("google")
                                .resizable()
                                .frame(width: 60,height: 60)
                                .clipShape(Circle())
                            Spacer().frame(width:60)
                            Image("github")
                                .resizable()
                                .frame(width: 60,height: 60)
                                .clipShape(Circle())
                            Spacer().frame(width:60)
                            Image("link")
                                .resizable()
                                .frame(width: 60,height: 60)
                                .clipShape(Circle())
                        }.padding(.top,30)
                        
                        NavigationLink{
                            SignupView()
                        }label: {
                            Text("Not registerd? Signup here")
                                .bold()
                                .foregroundColor(.white).padding(.top,40)
                        }.navigationBarHidden(true)
                       
  
                    }
                }
        }
        .alert(isPresented: $globalAlertVM.showError, content: getAlert)
        
       
    }
    
    func handleLogin(){
        if emailValidation() && passwordValidation() {
            Task{
                let logindata = LoginModel(email: email, password: password)
                await authVM.loginUser(userData:logindata,globalAlertObj:globalAlertVM)
            }
        }
    }
    
    func emailValidation()->Bool{
       if email.isEmpty{
           globalAlertVM.toggleShowError()
           globalAlertVM.setAlertErrorMessage("All fields are required!")
           return false
       }else if !email.contains("@") || !email.contains("."){
           globalAlertVM.toggleShowError()
           globalAlertVM.setAlertErrorMessage("Email is not valid!")
           return false
       }
       return true
   }
   func passwordValidation()->Bool{
       if password.isEmpty{
           globalAlertVM.toggleShowError()
           globalAlertVM.setAlertErrorMessage("All fields are required!")
           return false
       }else if password.count<8{
           globalAlertVM.toggleShowError()
           globalAlertVM.setAlertErrorMessage("Password must be alteast 8 characters!")
           return false
       }
       return true
   }
    func getAlert() -> Alert {
        return Alert(title: Text(globalAlertVM.alertErrorMessage))
   }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView()
        }.environmentObject(AuthViewModel())
            .environmentObject(GlobalAlertViewModel())
        
    }
}



public struct PlaceholderStyle: ViewModifier {
    var showPlaceHolder: Bool
    var placeholder: String

    public func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            if showPlaceHolder {
                Text(placeholder)
                    .foregroundColor(.gray)
                    .bold()
            }
            content
            .foregroundColor(Color.white)
           
        }
    }
}
