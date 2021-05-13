//
//  LoginView.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/7.
//

import UIKit
import AuthenticationServices

class LoginViewController: UIViewController {
  
  @IBOutlet var loginButtonView: UIView!
  
  @IBOutlet var mockLogin: UIButton!
  
  let appleLoginButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    appleLoginButton.layer.cornerRadius = 8.0
    appleLoginButton.addTarget(self, action: #selector(appleLoginButtonTapped), for: .touchUpInside)
    appleLoginButton.translatesAutoresizingMaskIntoConstraints = false
    
    loginButtonView.addSubview(appleLoginButton)
    NSLayoutConstraint.activate([
      appleLoginButton.bottomAnchor.constraint(equalTo: loginButtonView.bottomAnchor, constant: -40),
      appleLoginButton.leadingAnchor.constraint(equalTo: loginButtonView.leadingAnchor, constant: 16),
      appleLoginButton.trailingAnchor.constraint(equalTo: loginButtonView.trailingAnchor, constant: -16),
      appleLoginButton.heightAnchor.constraint(equalToConstant: 50)
    ])
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if touches.first?.view == view {
      dismiss(animated: true)
    }
  }
  
  @objc func appleLoginButtonTapped() {
    
    let provider = ASAuthorizationAppleIDProvider()
    let request = provider.createRequest()
    request.requestedScopes = [.email, .fullName]
    let controller = ASAuthorizationController(authorizationRequests: [request])
    
    controller.delegate = self
    controller.presentationContextProvider = self
    controller.performRequests()
  }
}

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    switch authorization.credential {
    case let appleIdCredentail as ASAuthorizationAppleIDCredential:
      let userIdentifier = appleIdCredentail.user
      
      let defaults = UserDefaults.standard
      defaults.set(userIdentifier, forKey: "userIdentifier")
      
      print(userIdentifier)
      
    default:
      break
    }
  }
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    print(error)
  }
  
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return self.view.window!
  }
}
