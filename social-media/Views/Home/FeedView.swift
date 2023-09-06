//
//  FeedView.swift
//  social-media
//
//  Created by Aman Tiwari on 02/09/23.
//

import SwiftUI

struct FeedView: View {
    @EnvironmentObject var postVM:PostViewModel
    @EnvironmentObject var authVM:AuthViewModel
    let appwriteService = AppwriteService()
    @State var imageData:Data = Data()
    @State private var image: Image?
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea(.all)
            VStack{
                HStack{
                    HStack{
                        Text("</>")
                            .foregroundColor(.green.opacity(1.5))
                            .font(.system(size: 30))
                            .fontWeight(.bold)
                        Text("Dev Media")
                            .foregroundColor(.white)
                            .font(.system(size: 25))
                            .fontWeight(.bold)
                    }.padding(.leading)
                    Spacer()
                    HStack{
                        Image(systemName: "bell.fill")
                            .foregroundColor(.white)
                            .frame(width: 25,height: 25)
                        Spacer().frame(width: 15)
                        if let image = image{
                            image
                                .resizable()
                                .frame(width: 30,height: 30)
                                .clipShape(Circle())
                        }else{
                            Image("google")
                                .resizable()
                                .frame(width: 30,height: 30)
                                .clipShape(Circle())
                        }
                        
                        
                    }.padding(.trailing)
                }
                ScrollView{
                    ScrollView(.horizontal){
                        HStack(alignment: .center){
                            Image(systemName: "plus.circle.fill").foregroundColor(.white.opacity(0.8))
                                .font(.system(size: 35))
                            VStack{
                                Image("github").resizable()
                                    .frame(width: 70,height: 90)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                Circle().fill(.red).frame(width: 25,height: 25).overlay {
                                    Image("google").resizable().frame(width: 20,height: 20)
                                        .clipShape(Circle())
                                        
                                }.offset(y:-18)
                                
                                    
                            }.padding(.leading,8)
                            VStack{
                                Image("github").resizable()
                                    .frame(width: 70,height: 90)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                Circle().fill(.red).frame(width: 25,height: 25).overlay {
                                    Image("google").resizable().frame(width: 20,height: 20)
                                        .clipShape(Circle())
                                        
                                }.offset(y:-18)
                                
                                    
                            }.padding(.leading,8)
                            VStack{
                                Image("github").resizable()
                                    .frame(width: 70,height: 90)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                Circle().fill(.red).frame(width: 25,height: 25).overlay {
                                    Image("google").resizable().frame(width: 20,height: 20)
                                        .clipShape(Circle())
                                        
                                }.offset(y:-18)
                                
                                    
                            }.padding(.leading,8)
                            VStack{
                                Image("github").resizable()
                                    .frame(width: 70,height: 90)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                Circle().fill(.red).frame(width: 25,height: 25).overlay {
                                    Image("google").resizable().frame(width: 20,height: 20)
                                        .clipShape(Circle())
                                        
                                }.offset(y:-18)
                                
                                    
                            }.padding(.leading,8)
                            VStack{
                                Image("github").resizable()
                                    .frame(width: 70,height: 90)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                Circle().fill(.red).frame(width: 25,height: 25).overlay {
                                    Image("google").resizable().frame(width: 20,height: 20)
                                        .clipShape(Circle())
                                        
                                }.offset(y:-18)
                                
                                    
                            }.padding(.leading,8)
                           
                            
                            
                        }
                      
                    }                        .padding(.top,5)
                    ForEach(postVM.postItems,id:\.postId){ post in
                        PostCard(postData: post)
                        
                    }
                   
                }
                
                FooterView().frame(height: 30).padding()
                
            }
            .onAppear{
                Task{
                    if authVM.activeUserInfo.userId.isEmpty{
                        await authVM.fetchUserInfo()
                    }
                    await getImage(fileid: authVM.activeUserInfo.profileImgId)
                    await postVM.getPosts()
                }
            }
        }
    }
    
    func getImage(fileid:String)async{
        do{
            let imageRes = try await appwriteService.storage.getFilePreview(bucketId:appwriteService.profilePictureBucketId , fileId: fileid)

          
          // converted ByteBuffer to Data
            let imageD = Data(buffer: imageRes)

            if let uiImage = UIImage(data: imageD) {
                        // Create SwiftUI Image from UIImage
                        image = Image(uiImage: uiImage)
                    }
            
        }catch{
            print("Error in get image",error.localizedDescription)
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FeedView()
        }.environmentObject(PostViewModel())
            .environmentObject(AuthViewModel())
      
    }
}
