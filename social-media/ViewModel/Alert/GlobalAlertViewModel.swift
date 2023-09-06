//
//  GlobalAlertViewModel.swift
//  social-media
//
//  Created by Aman Tiwari on 01/09/23.
//

import Foundation

class GlobalAlertViewModel:ObservableObject{
    @Published var showError:Bool = false
    @Published var alertErrorMessage:String = ""
    init(){}
     func toggleShowError(){
         DispatchQueue.main.async {
             self.showError.toggle()
         }
       
    }
    
    func setAlertErrorMessage(_ message:String){
        DispatchQueue.main.async {
            self.alertErrorMessage = message
        }
        
    }
}
