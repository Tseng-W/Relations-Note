//
//  LoginView.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/7.
//

import UIKit
import AuthenticationServices
import FirebaseAuth
import CryptoKit

class LoginViewController: UIViewController {
  
  @IBOutlet var loginButtonView: UIView!

  fileprivate var currentNonce: String?

  var cornerRadius: CGFloat = 8.0 {
    didSet {
      updateRadius()
    }
  }

  private lazy var blackButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
  private lazy var whiteButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .white)

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    setupButton()
  }
  
  override func viewDidLoad() {

    super.viewDidLoad()
    setupButton()
  }
  
  @objc func appleLoginButtonTapped() {

    let nonce = randomNonceString()
    currentNonce = nonce

    let provider = ASAuthorizationAppleIDProvider()
    let request = provider.createRequest()
    request.requestedScopes = [.email, .fullName]
    request.nonce = sha256(nonce)

    let controller = ASAuthorizationController(authorizationRequests: [request])
    controller.delegate = self
    controller.presentationContextProvider = self
    controller.performRequests()
  }
}

private extension LoginViewController {

  func setupButton() {

    switch traitCollection.userInterfaceStyle {

    case .light:
      loginButtonView.subviews.forEach { $0.removeFromSuperview() }
      loginButtonView.addSubview(whiteButton)
      whiteButton.addConstarint(
        top: loginButtonView.topAnchor,
        left: loginButtonView.leftAnchor,
        bottom: loginButtonView.bottomAnchor,
        right: loginButtonView.rightAnchor)
      whiteButton.layer.cornerRadius = cornerRadius
      whiteButton.addTarget(self, action: #selector(appleLoginButtonTapped), for: .touchUpInside)

    case .unspecified, .dark:
      loginButtonView.subviews.forEach { $0.removeFromSuperview() }
      loginButtonView.addSubview(blackButton)
      blackButton.addConstarint(
        top: loginButtonView.topAnchor,
        left: loginButtonView.leftAnchor,
        bottom: loginButtonView.bottomAnchor,
        right: loginButtonView.rightAnchor)
      blackButton.layer.cornerRadius = cornerRadius
      blackButton.addTarget(self, action: #selector(appleLoginButtonTapped), for: .touchUpInside)

    @unknown default:
      print("unknown style: \(traitCollection.userInterfaceStyle)")
    }
  }

  func updateRadius() {

    switch traitCollection.userInterfaceStyle {

    case .light:
      whiteButton.layer.cornerRadius = cornerRadius

    case .unspecified, .dark:
      blackButton.layer.cornerRadius = cornerRadius
      
    @unknown default:
      print("unknown style: \(traitCollection.userInterfaceStyle)")
    }
  }

  @available(iOS 13, *)
  private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
      return String(format: "%02x", $0)
    }.joined()

    return hashString
  }

  private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: Array<Character> =
      Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length

    while remainingLength > 0 {
      let randoms: [UInt8] = (0 ..< 16).map { _ in
        var random: UInt8 = 0
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
        if errorCode != errSecSuccess {
          fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }
        return random
      }

      randoms.forEach { random in
        if remainingLength == 0 {
          return
        }

        if random < charset.count {
          result.append(charset[Int(random)])
          remainingLength -= 1
        }
      }
    }

    return result
  }
}

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {

    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {

      guard let nonce = currentNonce else {
        fatalError("Invalid state: A login callback was received, but no login request was sent.")
      }

      guard let appleIDToken = appleIDCredential.identityToken else {
        print("Unable to fetch identity token")
        return
      }

      guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
        print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
        return
      }

      let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                idToken: idTokenString,
                                                rawNonce: nonce)

      Auth.auth().signIn(with: credential) { [weak self] (autoResult, error) in
        if let error = error {
          print(error.localizedDescription)
          return
        }

        UserDefaults.standard.set(autoResult?.user.uid,
                     forKey: UserDefaults.Keys.uid.rawValue)
        UserDefaults.standard.set(autoResult?.user.email,
                     forKey: UserDefaults.Keys.email.rawValue)

        self?.performSegue(withIdentifier: "main", sender: self)
      }
    }
  }
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    print(error)
  }
  
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return self.view.window!
  }
}
