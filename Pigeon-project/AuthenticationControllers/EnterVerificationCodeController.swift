//
//  EnterVerificationCodeController.swift
//  Pigeon-project
//
//  Created by Roman Mizin on 8/2/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit
import FirebaseAuth

class EnterVerificationCodeController: UIViewController {

  let enterVerificationContainerView = EnterVerificationContainerView()
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      view.backgroundColor = UIColor.white
      view.addSubview(enterVerificationContainerView)
      enterVerificationContainerView.frame = view.bounds
      configureNavigationBar()
  }
  

  fileprivate func configureNavigationBar () {
    let rightBarButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(rightBarButtonDidTap))
    self.navigationItem.rightBarButtonItem = rightBarButton
  }
  
  
  func rightBarButtonDidTap () {
    print("tapped")
   
    ARSLineProgress.ars_showOnView(self.view)
    let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
    let verificationCode = enterVerificationContainerView.verificationCode.text

      let credential = PhoneAuthProvider.provider().credential (
        withVerificationID: verificationID!,
        verificationCode: verificationCode!)
      
      Auth.auth().signIn(with: credential) { (user, error) in
        if let error = error {
           ARSLineProgress.showFail()
           self.enterVerificationContainerView.verificationCode.shake()
          print(error.localizedDescription, "it is error")
          return
        }
      
        let destination = UserProfileController()
        destination.userProfileContainerView.phone.text = self.enterVerificationContainerView.titleNumber.text
        destination.checkIfUserDataExists(completionHandler: { (isCompleted) in
          if isCompleted {
            ARSLineProgress.hide()
           
            if self.navigationController != nil {
              if !(self.navigationController!.topViewController!.isKind(of: UserProfileController.self)) {
                self.navigationController?.pushViewController(destination, animated: true)
              }
            }
            
            print("code is correct")
          }
        })
      }
  }
  
}
