/*
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // 1. Create the window
        let window = UIWindow(windowScene: windowScene)
        
        // ⚠️ Reset for testing (Remove later)
        OnboardingManager.shared.resetOnboarding()
        
        // 2. Determine Logic
        let rootViewController: UIViewController
        
        if OnboardingManager.shared.isTechSkillsCompleted {
            print("User Status: Returning User (Going to Home)")
            let homeStoryboard = UIStoryboard(name: "HomePageProfileNew", bundle: nil)
            guard let homeVC = homeStoryboard.instantiateInitialViewController() else { return }
            rootViewController = homeVC
        } else {
            print("User Status: New User (Going to Onboarding)")
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            if let startVC = mainStoryboard.instantiateViewController(withIdentifier: "introVC") as? onboardingSectionIntroViewController {
                startVC.sectionIndex = 0
                rootViewController = startVC
            } else {
                rootViewController = UIViewController()
            }
        }
        
        // 3. Setup Navigation Controller & Large Titles
        if let navVC = rootViewController as? UINavigationController {
            navVC.navigationBar.prefersLargeTitles = true
            window.rootViewController = navVC
        } else {
            let navigationController = UINavigationController(rootViewController: rootViewController)
            navigationController.navigationBar.prefersLargeTitles = true
            window.rootViewController = navigationController
        }
        
        // MARK: - 👇 THIS WAS MISSING
        // 4. Attach the window to the scene and make it visible
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) { }
    func sceneDidBecomeActive(_ scene: UIScene) { }
    func sceneWillResignActive(_ scene: UIScene) { }
    func sceneWillEnterForeground(_ scene: UIScene) { }
    func sceneDidEnterBackground(_ scene: UIScene) { }
}
*/

//
//  SceneDelegate.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 27/11/25.
//

import UIKit
internal import Auth
import Supabase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        // ---------------------------------------------------------
        // DEFAULT BEHAVIOR:
        // This will load the Main.storyboard automatically.
        // KEEPING THIS because you want HEAD behavior.
        // ---------------------------------------------------------
        guard let _ = (scene as? UIWindowScene) else { return }


        // ---------------------------------------------------------
        // CUSTOM STORYBOARD LAUNCH (COMMENTED OUT)
        // Uncomment this block ONLY if you want to launch
        // another storyboard (e.g., "Badges", "MyJourney", etc.)
        // ---------------------------------------------------------

        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

        Task {
            let client = SupabaseManager.shared.client
            
            // TEMPORARY FOR TESTING: Force sign out on launch to test Login/Sign-In Screen
            try? await client.auth.signOut()
            
            do {
                let session = try await client.auth.session
                UserSessionManager.shared.setUserId(session.user.id)
                
                // Sync profile from Supabase
                await ProfileService.shared.syncRemoteToLocal()
                
                // User is logged in, decide where to go
                DispatchQueue.main.async {
                    if !OnboardingManager.shared.isOnboardingCompleted {
                        // Go to Onboarding
                        if let onboardingVC = OnboardingManager.shared.getNextViewController() {
                            let nav = UINavigationController(rootViewController: onboardingVC)
                            window.rootViewController = nav
                            window.makeKeyAndVisible()
                            return
                        }
                    }
                    
                    // Go to Home
                    let homeStoryboard = UIStoryboard(name: "HomePageProfileNew", bundle: nil)
                    if let homeVC = homeStoryboard.instantiateInitialViewController() {
                        window.rootViewController = homeVC
                        window.makeKeyAndVisible()
                    }
                }
            } catch {
                // No session, go to Welcome/Login (full-screen, non-bypassable)
                DispatchQueue.main.async {
                    let welcomeVC = WelcomeViewController()
                    let nav = UINavigationController(rootViewController: welcomeVC)
                    nav.isNavigationBarHidden = true
                    window.rootViewController = nav
                    window.makeKeyAndVisible()
                }
            }
        }
        
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) { }
    func sceneDidBecomeActive(_ scene: UIScene) { }
    func sceneWillResignActive(_ scene: UIScene) { }
    func sceneWillEnterForeground(_ scene: UIScene) { }
    func sceneDidEnterBackground(_ scene: UIScene) { }
}
