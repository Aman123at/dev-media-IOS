//
//  PostCard.swift
//  social-media
//
//  Created by Aman Tiwari on 02/09/23.
//

import SwiftUI
let sampleData = PostItemModel(postImages: [], creationTime: "2h ago", userId: "sfdf4545", postId: "gfsdf697981", comments: [], likes: [], postDesc: "This is my first post",userName: "I_AM_USER",createrProfileImage: "34545dgdfg3412")
struct PostCard: View {
    let postData:PostItemModel
    let appwriteService = AppwriteService()
    @State var imageData:Data = Data()
    @State private var image: Image?
    @State private var profileImg: Image?
    var body: some View {
        ZStack{
            Color.black.opacity(0.8).ignoresSafeArea(.all)
            VStack(alignment: .leading){
                HStack{
                    if let profileimg = profileImg{
                        profileimg.resizable().frame(width:65,height: 65)
                            .clipShape(Circle())
                    }else{
                        Image("google").resizable().frame(width:65,height: 65)
                            .clipShape(Circle())
                    }
                   
                    VStack(alignment: .leading,spacing: 5){
                        Text(postData.userName).foregroundColor(.white)
                            .font(.system(size: 23))
                            .fontWeight(.bold)
                        Text("1h ago").foregroundColor(.white)
                            .fontWeight(.semibold)
                            
                    }.padding(.leading,5)
                    Spacer()
                }
                Text(postData.postDesc).foregroundColor(.white)
                    .padding(.vertical,5)
                
//                Image("link").resizable().frame(width: 360,height: 300)
//                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                if let image = image{
                    image.resizable().frame(width: 360,height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                HStack{
                    HStack{
                        Image("github").resizable().frame(width: 30,height: 30)
                            .clipShape(Circle())
                        Image("link").resizable().frame(width: 30,height: 30)
                            .clipShape(Circle())
                            .offset(x:-20)
                        Image("google").resizable().frame(width: 30,height: 30)
                            .clipShape(Circle())
                            .offset(x:-40)
                        Image("matrix").resizable().frame(width: 30,height: 30)
                            .clipShape(Circle())
                            .offset(x:-60)
                    }
                    Spacer()
                    HStack{
                        HStack{
                            Image(systemName: "heart.fill").foregroundColor(.white)
                            Text("\(postData.likes.count)").foregroundColor(.white)
                        }
                        HStack{
                            Image(systemName: "ellipsis.message.fill").foregroundColor(.white)
                            Text("\(postData.comments.count)").foregroundColor(.white)
                        }
                    }
                }.padding(.top,5)
                
                if !postData.likes.isEmpty{
                    HStack(spacing:5){
                        if postData.likes.count==1{
                            Text("Liked by").foregroundColor(.white)
                            Text("Annabella").foregroundColor(.white).fontWeight(.bold)
                        }else{
                            Text("Liked by").foregroundColor(.white)
                            Text("Annabella").foregroundColor(.white).fontWeight(.bold)
                            Text("and").foregroundColor(.white)
                            Text("\(postData.likes.count-1)").foregroundColor(.white).fontWeight(.bold)
                            Text("others").foregroundColor(.white)
                        }
                        
                    }
                }
                
                if !postData.comments.isEmpty{
                    Text("View all \(postData.comments.count) comments").foregroundColor(.white.opacity(0.7)).padding(.top,2)
                }
            }.padding()
                .background(Color.gray.opacity(0.3))
                .onAppear{
                    Task{
                        await getProfileImage(fileid:postData.createrProfileImage)
                        await getImage(fileid:postData.postImages[0])
                    }
                }
        }
    }
    
    func getImage(fileid:String)async{
        do{
            let imageRes = try await appwriteService.storage.getFilePreview(bucketId:appwriteService.postImagesBucketId , fileId: fileid)

          
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
    
    func getProfileImage(fileid:String)async{
        do{
            let imageRes = try await appwriteService.storage.getFilePreview(bucketId:appwriteService.profilePictureBucketId , fileId: fileid)

          
          // converted ByteBuffer to Data
            let imageD = Data(buffer: imageRes)

            if let uiImage = UIImage(data: imageD) {
                        // Create SwiftUI Image from UIImage
                        profileImg = Image(uiImage: uiImage)
                    }
            
        }catch{
            print("Error in get image",error.localizedDescription)
        }
    }
}

struct PostCard_Previews: PreviewProvider {
    static var previews: some View {
 
            PostCard(postData: sampleData)
        
       
    }
}
