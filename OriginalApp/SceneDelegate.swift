//
//  SceneDelegate.swift
//  OriginalApp
//
//  Created by 金子　柊二 on 2023/07/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let ud = UserDefaults.standard
        let isLogin = ud.bool(forKey: "isLogin")
        let isAdmin = ud.bool(forKey: "isAdmin")
        // ログイン中だったらMain.Storyboardに遷移する。
        if isLogin == true {
            
            if isAdmin == true{
//                  LabMain
                var window = UIWindow(windowScene: scene as! UIWindowScene)
                self.window = window
                let storyboard = UIStoryboard(name: "LabMain", bundle: Bundle.main)
                let rootViewcontller = storyboard.instantiateViewController(withIdentifier: "RootTabBarController")
                self.window?.rootViewController = rootViewcontller
                self.window?.backgroundColor = UIColor.white
                self.window?.makeKeyAndVisible()
            }else if isAdmin == false{
//                SubjectMain
                var window = UIWindow(windowScene: scene as! UIWindowScene)
                self.window = window
                let storyboard = UIStoryboard(name: "SubjectMain", bundle: Bundle.main)
                let rootViewcontller = storyboard.instantiateViewController(withIdentifier: "RootTabBarController")
                self.window?.rootViewController = rootViewcontller
                self.window?.backgroundColor = UIColor.white
                self.window?.makeKeyAndVisible()
            }
        } else {
        // ログインしてなかったらSignIn.Storyboardに遷移する。
            var window = UIWindow(windowScene: scene as! UIWindowScene)
            self.window = window
            let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
            let rootViewcontller = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
            self.window?.rootViewController = rootViewcontller
            self.window?.backgroundColor = UIColor.white
            self.window?.makeKeyAndVisible()
        }
       
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

