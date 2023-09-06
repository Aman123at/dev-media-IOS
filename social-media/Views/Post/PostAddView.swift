//
//  PostAddView.swift
//  social-media
//
//  Created by Aman Tiwari on 02/09/23.
//

import SwiftUI
import PhotosUI
struct PostAddView: View {
    @EnvironmentObject var authVM:AuthViewModel
    @EnvironmentObject var globalAlertVM:GlobalAlertViewModel
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedPhotoData: [Data] = []
    @State var description:String = ""
    let postVM = PostViewModel()
   
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea(.all)
            VStack(alignment: .leading){
                HStack{
                    Image(systemName: "chevron.left").foregroundColor(.white)
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                        }
                    Spacer()
                    Text("Post").foregroundColor(.white)
                        .font(.system(size: 30)).fontWeight(.bold)
                    Spacer()
                }.padding(.bottom)
                Text("Select Images").foregroundColor(.white).fontWeight(.bold)
                HStack{
                    
                    ForEach(selectedPhotoData,id:\.self){photoData in
                      
                        if let image = UIImage(data: photoData) {
                            
                            Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .clipped()
                            .frame(width: 50,height: 50)
                     
                            }
                    }
                    PhotosPicker(selection: $selectedItems,
                                 maxSelectionCount: 5,
                                 matching: .images){
                        Image(systemName: "plus.circle.fill").foregroundColor(.white.opacity(0.8))
                            .font(.system(size: 35))
                            .padding()
                            
                    }.onChange(of: selectedItems) { newItems in
                        for newItem in newItems{
                            Task {
                                if let data = try? await newItem.loadTransferable(type: Data.self) {
                                    
                                    selectedPhotoData.append(data)
                                }
                            }
                        }
                        
                    }
                }
                Text("Add Caption").foregroundColor(.white).fontWeight(.bold)
                TextEditor(text: $description)
                    .frame(height: 100)
                Spacer().frame(height: 30)
                Text("Upload")
                    .foregroundColor(.white)
                    .bold()
                    .padding(.vertical,20)
                    .padding(.horizontal,150)
                    .background(RoundedRectangle(cornerRadius: 100).fill(Color.green))
                    .onTapGesture {
                        Task{
                            await  postVM.createPost(PostAddModel(postDesc: description, postImages: selectedPhotoData),loginUserId: authVM.loggedInUserID,loginUserName: authVM.activeUserInfo.userName,loginUserProfileImg: authVM.activeUserInfo.profileImgId,globalAlertObj: globalAlertVM)
                            
                            presentationMode.wrappedValue.dismiss()
                        }
                       
                    }
                
                Spacer()
                FooterView().frame(height: 30).padding()
            }.padding()
        }.navigationBarHidden(true)
        
    }
}

struct PostAddView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PostAddView()
        }.environmentObject(AuthViewModel())
            .environmentObject(GlobalAlertViewModel())
        
    }
}
