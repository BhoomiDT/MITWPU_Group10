import UIKit

extension UIViewController {
    func navigateToHome() {
        DispatchQueue.main.async {
            // Check if onboarding is completed for this user
            if !OnboardingManager.shared.isOnboardingCompleted {
                // Route to Onboarding
                if let onboardingVC = OnboardingManager.shared.getNextViewController() {
                    let nav = UINavigationController(rootViewController: onboardingVC)
                    self.setRootViewController(nav)
                    return
                }
            }
            
            // Otherwise, route to Home
            let storyboard = UIStoryboard(name: "HomePageProfileNew", bundle: nil)
            guard let homeVC = storyboard.instantiateInitialViewController() else {
                print("❌ Could not instantiate Home View Controller")
                return
            }
            self.setRootViewController(homeVC)
        }
    }
    
    private func setRootViewController(_ vc: UIViewController) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = vc
            window.makeKeyAndVisible()
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
    
    func showAppAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    @discardableResult
    func checkAuthentication() -> Bool {
        if UserSessionManager.shared.userId == nil {
            print("⚠️ Unauthenticated access detected. Redirecting to Welcome screen...")
            DispatchQueue.main.async {
                let welcomeVC = WelcomeViewController()
                let nav = UINavigationController(rootViewController: welcomeVC)
                nav.isNavigationBarHidden = true
                
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    window.rootViewController = nav
                    window.makeKeyAndVisible()
                }
            }
            return false
        }
        return true
    }
}
