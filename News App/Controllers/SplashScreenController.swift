//
//  SplashScreenController.swift
//  Assignment12
//
//  Created by Pranab Raj Satyal on 7/5/21.
//

import UIKit
import Lottie

class SplashScreenController: UIViewController {
    
    private let animationContainerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    
    private let animationView: AnimationView = {
        let animation = AnimationView(name: "news")
        animation.contentMode = .scaleAspectFit
        animation.animationSpeed = 2
        return animation
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(animationContainerView)
        layoutAnimationContainerView()
        
        animationContainerView.addSubview(animationView)
        configureAnimation()
        animationView.play { completed in
            if completed {
                self.navigateToNewScreen()
            }
        }
        
    }
    
    private func layoutAnimationContainerView() {
        animationContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            animationContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            animationContainerView.heightAnchor.constraint(equalTo: animationContainerView.widthAnchor),
            animationContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
    }
    
    private func configureAnimation() {
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: animationContainerView.topAnchor),
            animationView.leadingAnchor.constraint(equalTo: animationContainerView.leadingAnchor),
            animationView.bottomAnchor.constraint(equalTo: animationContainerView.bottomAnchor),
            animationView.trailingAnchor.constraint(equalTo: animationContainerView.trailingAnchor)
        ])
        
    }
    
    private func navigateToNewScreen() {
        UIApplication.shared.windows.first?.rootViewController = configureTabBar()
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    private func configureTabBar() -> UITabBarController {
        
        let tabBar = UITabBarController()
        
        let item1 = UINavigationController(rootViewController: HomeViewController())
        let item2 = UINavigationController(rootViewController: DiscoverViewController())
        
        tabBar.setViewControllers([item1, item2], animated: false)
        
        if let tabBarItems = tabBar.tabBar.items {
            
            let imageNames = ["house", "magnifyingglass"]
            let selectedImageNames = ["house.fill", "magnifyingglass"]
            
            for i in 0 ..< tabBarItems.count {
                tabBarItems[i].image = UIImage(systemName: imageNames[i])?.withRenderingMode(.alwaysOriginal).withTintColor(.label)
                
                if selectedImageNames[i] == "magnifyingglass" {
                    tabBarItems[i].selectedImage = UIImage(systemName: selectedImageNames[i], withConfiguration: UIImage.SymbolConfiguration(weight: .heavy))?.withRenderingMode(.alwaysOriginal).withTintColor(.label)
                } else {
                    tabBarItems[i].selectedImage =
                        UIImage(systemName: selectedImageNames[i])?.withRenderingMode(.alwaysOriginal).withTintColor(.label)
                }
            }
        }
        
        return tabBar
        
    }

}
