//
//  OnboardView.swift
//  social-media
//
//  Created by Aman Tiwari on 30/08/23.
//

import SwiftUI
import PhotosUI
struct OnboardView: View {
    @EnvironmentObject var authVM:AuthViewModel
    @EnvironmentObject var globalAlertVM:GlobalAlertViewModel
    @State private var selectedItems: PhotosPickerItem?
    @State private var selectedPhotoData: Data = Data()
    @State var location:String = ""
    @State var heading:String = ""
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
                      
                        Text("Update Profile")
                            .foregroundColor(.white)
                            .bold()
                            .font(.system(size: 45))
                        
                        
                        
                        PhotosPicker(selection: $selectedItems,
                                     matching: .images){
                            if let image = UIImage(data: selectedPhotoData) {
                                VStack{
                                    Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 100,height: 100)
                                    Image(systemName: "pencil.circle.fill")
                                        .font(.system(size: 35))
                                        .foregroundColor(.white)
                                        .offset(x: 35,y:-35)
                                }
                               
                         
                                }
                            if selectedItems == nil {
                                VStack{
                                    Image(systemName: "person")
                                        .font(.system(size: 100))
                                        .frame(width: 100,height: 100)
                                    Image(systemName: "pencil.circle.fill")
                                        .font(.system(size: 30))
                                        .foregroundColor(.white)
                                        .offset(x: 35,y:-30)
                                }
                            }
                           
                           
                            
                        }.onChange(of: selectedItems) { newValue in
                            Task {
                                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                                    
                                    selectedPhotoData = data
                                }
                            }
                        }
                        
                        
                        VStack{
                            HStack{
                                Text("📍")
                                    .bold()
                                    .foregroundColor(.white)
                                    .font(.system(size: 35))
                                    
                                TextField("", text: $location)
                                    .foregroundColor(.white)
                                    .disableAutocorrection(true)
                                    .textInputAutocapitalization(.never)
                                    .frame(width: 320)
                                    .modifier(PlaceholderStyle(showPlaceHolder: location.isEmpty,
                                        placeholder: "Enter Location"))
      
                            }.padding(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 100)
                                        .stroke(Color.green, lineWidth: 4)
                                )
                                
                            Spacer().frame(height: 20)
                            HStack{
                                Text("👤")
                                    .bold()
                                    .foregroundColor(.white)
                                    .font(.system(size: 35))
                                    
                                TextField("", text: $heading)
                                    .foregroundColor(.white)
                                    .disableAutocorrection(true)
                                    .textInputAutocapitalization(.never)
                                    .frame(width: 320)
                                    .modifier(PlaceholderStyle(showPlaceHolder: heading.isEmpty,
                                        placeholder: "Enter Headline"))
                                    
                                    
                            }.padding(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 100)
                                        .stroke(Color.green, lineWidth: 4)
                                )
                           
                        }.padding()
                        
                        Spacer().frame(height: 30)
                        
                        Text("UPDATE")
                            .foregroundColor(.white)
                            .bold()
                            .padding(.vertical,20)
                            .padding(.horizontal,160)
                            .background(RoundedRectangle(cornerRadius: 100).fill(Color.green))
                            .onTapGesture {
                                if formValidation(){
                                    Task{
                                        await authVM.onBoardUpdate(location:location,headline:heading,profileImage: selectedPhotoData,globalAlertObj:globalAlertVM)
                                    }
                                }
                            }
                        Spacer().frame(height: 20)
                        Text("I will do this later")
                            .foregroundColor(.white)
                            .bold()
                            .padding(.vertical,20)
                            .padding(.horizontal,125)
                            .background(RoundedRectangle(cornerRadius: 100).fill(Color.purple))
                            .onTapGesture {
                                Task{
                                    await authVM.onBoardUpdate(profileImage:selectedPhotoData,globalAlertObj:globalAlertVM)
                                }
                            }
                    }
                }
        }
        .alert(isPresented: $globalAlertVM.showError, content: getAlert)
    }
    
    func getAlert() -> Alert {
        return Alert(title: Text(globalAlertVM.alertErrorMessage))
   }
    func formValidation()->Bool{
        if location.isEmpty || heading.isEmpty {
           globalAlertVM.toggleShowError()
           globalAlertVM.setAlertErrorMessage("All fields are required!")
           return false
       }
       return true
   }
}

struct OnboardView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OnboardView()
        }.environmentObject(AuthViewModel())
            .environmentObject(GlobalAlertViewModel())
        
    }
}
