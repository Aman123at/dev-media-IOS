//
//  SignupView.swift
//  social-media
//
//  Created by Aman Tiwari on 30/08/23.
//

import SwiftUI

struct SignupView: View {
    @State var userName = ""
    @State var fullName = ""
    @State var password = ""
    @State var confirmPassword = ""
    @State var email = ""
    @State var isNextPage:Bool = false
    @EnvironmentObject var authVM:AuthViewModel
    @EnvironmentObject var globalAlertVM:GlobalAlertViewModel
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea(.all)
       
                Image("dev")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.2)
                    .overlay {
                        ScrollView{
                            VStack{
                               Text("Sign Up")
                                    .foregroundColor(.white)
                                    .bold()
                                    .font(.system(size: 45))
                                if isNextPage{
                                    Text(email)
                                        .foregroundColor(.gray)
                                        .padding(8)
                                        .font(.system(size: 25))
                                        .bold()
                                }
                                
                                VStack{
                                    if !isNextPage{
                                        HStack{
                                            Text("🧑🏼")
                                                .bold()
                                                .foregroundColor(.white)
                                                .font(.system(size: 35))
                                                
                                            TextField("", text: $userName)
                                                .foregroundColor(.white)
                                                .textInputAutocapitalization(.never)
                                                .disableAutocorrection(true)
                                                .frame(width: 310)
                                                .modifier(PlaceholderStyle(showPlaceHolder: userName.isEmpty,
                                                                           placeholder: "User Name"))
                
                                        }.padding(10)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 100)
                                                    .stroke(Color.green, lineWidth: 4)
                                            )
                                            
                                        Spacer().frame(height: 20)
                                        HStack{
                                            Text("👨‍💻")
                                                .bold()
                                                .foregroundColor(.white)
                                                .font(.system(size: 35))
                                                
                                            TextField("", text: $fullName)
                                                .foregroundColor(.white)
                                                .textInputAutocapitalization(.never)
                                                .disableAutocorrection(true)
                                                .frame(width: 310)
                                                .modifier(PlaceholderStyle(showPlaceHolder: fullName.isEmpty,
                                                    placeholder: "Full Name"))
                
                                        }.padding(10)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 100)
                                                    .stroke(Color.green, lineWidth: 4)
                                            )
                                            
                                        Spacer().frame(height: 20)
                                        HStack{
                                            Text("＠")
                                                .bold()
                                                .foregroundColor(.white)
                                                .font(.system(size: 35))
                                                
                                            TextField("", text: $email)
                                                .foregroundColor(.white)
                                                .disableAutocorrection(true)
                                                .textInputAutocapitalization(.never)
                                                .frame(width: 310)
                                                .modifier(PlaceholderStyle(showPlaceHolder: email.isEmpty,
                                                                           placeholder: "Email"))
                
                                        }.padding(10)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 100)
                                                    .stroke(Color.green, lineWidth: 4)
                                            )
                                    }

                                    if isNextPage{
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
                                                .autocorrectionDisabled(true)
                                                .frame(width: 310)
                                                .modifier(PlaceholderStyle(showPlaceHolder: password.isEmpty,
                                                    placeholder: "Password"))
      
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
                                                
                                            SecureField("", text: $confirmPassword)
                                                .foregroundColor(.white)
                                                .disableAutocorrection(true)
                                                .textInputAutocapitalization(.never)
                                                .autocorrectionDisabled(true)
                                                .frame(width: 310)
                                                .modifier(PlaceholderStyle(showPlaceHolder: confirmPassword.isEmpty,
                                                                           placeholder: "Confirm Password"))
                                                
                                                
                                        }.padding(10)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 100)
                                                    .stroke(Color.green, lineWidth: 4)
                                            )
                                    }
                                 

                                }
                                
                                Spacer().frame(height: 30)
                                
                                Text(isNextPage ? "REGISTER":"NEXT →")
                                    .foregroundColor(.white)
                                    .bold()
                                    .padding(.vertical,20)
                                    .padding(.horizontal,155)
                                    .background(RoundedRectangle(cornerRadius: 100).fill(Color.green))
                                    .onTapGesture {
                                        if isNextPage{
                                            handleRegister()
                                        }else{
                                            if userNameValidation() && fullNameValidation() && emailValidation(){
                                                isNextPage.toggle()
                                            }
                                           
                                        }
                                    }
                                
                                if isNextPage{
                                    Text("← BACK")
                                        .foregroundColor(.white)
                                        .bold()
                                        .padding(.vertical,20)
                                        .padding(.horizontal,160)
                                        .background(RoundedRectangle(cornerRadius: 100).fill(Color.purple))
                                        .onTapGesture {
                                            isNextPage.toggle()
                                        }
                                }

                                if !isNextPage{
                                    Rectangle().fill(Color.white.opacity(0.5)).frame(height: 3).padding(.top,35).overlay {
                                        Text("OR").foregroundColor(.black).bold().padding().background(RoundedRectangle(cornerRadius: 100).fill(Color.white.opacity(0.9)))
                                            .offset(y:15)
                                    }.padding(.bottom,10)
                                        .padding(.top,10)
                                       
                                    
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
                                    }.padding(.top,20)

                                }
                                
                                NavigationLink{
                                    LoginView()
                                }label: {
                                    Text("Already a user? Login here")
                                        .bold()
                                        .foregroundColor(.white).padding(.top,20)
                                }.navigationBarHidden(true)
                               
         
                            }
                        }
                    }
    
        }
        .alert(isPresented: $globalAlertVM.showError, content: getAlert)
       
    }
    
    func handleRegister(){
        if userNameValidation() && fullNameValidation() && emailValidation() && passwordValidation() {
            Task{
                let signupdata = SignUpModel(userName: userName, fullName: fullName, email: email, password: password)
                await authVM.registerUser(userData:signupdata,globalAlertObj: globalAlertVM)
            }
        }
    }
    
    func userNameValidation()->Bool{
        if userName.isEmpty  {
            globalAlertVM.toggleShowError()
            globalAlertVM.setAlertErrorMessage("All fields are required!")
            return false
        }else if userName.count<5{
            globalAlertVM.toggleShowError()
            globalAlertVM.setAlertErrorMessage("User name should be more than 5 letters!")
            return false
        }
        return true
    }
    func fullNameValidation()->Bool{
        if fullName.isEmpty  {
            globalAlertVM.toggleShowError()
            globalAlertVM.setAlertErrorMessage("All fields are required!")
            return false
        }else if fullName.count<3{
            globalAlertVM.toggleShowError()
            globalAlertVM.setAlertErrorMessage("Full name should be more than 3 letters!")
            return false
        }
        return true
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
            globalAlertVM.setAlertErrorMessage("Password should be more than 8 letters!")
            return false
        }else if password != confirmPassword{
            globalAlertVM.toggleShowError()
            globalAlertVM.setAlertErrorMessage("Password and Confirm Password doesn't matches!")
            return false
        }
        return true
    }
     func getAlert() -> Alert {
         return Alert(title: Text(globalAlertVM.alertErrorMessage))
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignupView()
        }.environmentObject(AuthViewModel())
            .environmentObject(GlobalAlertViewModel())
       
    }
}
