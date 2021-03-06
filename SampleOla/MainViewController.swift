//
//  MainViewController.swift
//  SampleOla
//
//  Created by NanoNino on 11/11/21.
//

import UIKit

class MainViewController: UIViewController {
    
    private var sideMenuShadowView: UIView!
    
    private var sideMenuViewController: SideMenuViewController!
        private var sideMenuRevealWidth: CGFloat = 260
        private let paddingForRotation: CGFloat = 150
        private var isExpanded: Bool = false
   
    // Expand/Collapse the side menu by changing trailing's constant
    private var sideMenuTrailingConstraint: NSLayoutConstraint!

    private var revealSideMenuOnTop: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

        self.sideMenuViewController = kstoryboard.instantiateViewController(withIdentifier: "SideMenuViewController") as? SideMenuViewController
//        self.sideMenuViewController.defaultHighlightedCell = 0 // Default Highlighted Cell
        self.sideMenuViewController.delegate = self
        view.insertSubview(self.sideMenuViewController!.view, at: self.revealSideMenuOnTop ? 2 : 0)
        addChild(self.sideMenuViewController!)
        self.sideMenuViewController!.didMove(toParent: self)

        // Side Menu AutoLayout

        self.sideMenuViewController.view.translatesAutoresizingMaskIntoConstraints = false

        if self.revealSideMenuOnTop {
            self.sideMenuTrailingConstraint = self.sideMenuViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -self.sideMenuRevealWidth - self.paddingForRotation)
            self.sideMenuTrailingConstraint.isActive = true
        }
        NSLayoutConstraint.activate([
            self.sideMenuViewController.view.widthAnchor.constraint(equalToConstant: self.sideMenuRevealWidth),
            self.sideMenuViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.sideMenuViewController.view.topAnchor.constraint(equalTo: view.topAnchor)
        ])

        // Default Main View Controller
        showViewController(viewController: HomeViewController.self, storyboardId: "HomeViewController")

        self.sideMenuShadowView = UIView(frame: self.view.bounds)
        self.sideMenuShadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.sideMenuShadowView.backgroundColor = .black
        self.sideMenuShadowView.alpha = 0.0
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapGestureRecognizer))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
        if self.revealSideMenuOnTop {
            view.insertSubview(self.sideMenuShadowView, at: 1)
        }

    }
 
    @IBAction open func revealSideMenu() {
        self.sideMenuState(expanded: self.isExpanded ? false : true)
    }

}
extension MainViewController: UIGestureRecognizerDelegate {
    @objc func TapGestureRecognizer(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if self.isExpanded {
                self.sideMenuState(expanded: false)
            }
        }
    }

    // Close side menu when you tap on the shadow background view
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.sideMenuViewController.view))! {
            return false
        }
        return true
    }
    
    // ...
}

extension MainViewController: SideMenuViewControllerDelegate {
        func selectedCell(_ row: Int) {
            switch row {
            case 0:
                // Home
                self.showViewController(viewController: UINavigationController.self, storyboardId: "HomeNavId")
            case 1:
                // List
                self.showViewController(viewController: TripsViewController.self, storyboardId: "TripsViewController")
            case 2:
                // detail
                self.showViewController(viewController: DetailViewController.self, storyboardId: "DetailViewController")
           
            default:
                break
            }
            
            // Collapse side menu with animation
            DispatchQueue.main.async { self.sideMenuState(expanded: false) }
        }
        
        func showViewController<T: UIViewController>(viewController: T.Type, storyboardId: String) -> () {
            // Remove the previous View
            for subview in view.subviews {
                if subview.tag == 99 {
                    subview.removeFromSuperview()
                }
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: storyboardId) as! T
            vc.view.tag = 99
            view.insertSubview(vc.view, at: self.revealSideMenuOnTop ? 0 : 1)
            addChild(vc)
            if !self.revealSideMenuOnTop {
                if isExpanded {
                    vc.view.frame.origin.x = self.sideMenuRevealWidth
                }
                if self.sideMenuShadowView != nil {
                    vc.view.addSubview(self.sideMenuShadowView)
                }
            }
            vc.didMove(toParent: self)
        }
        
        func sideMenuState(expanded: Bool) {
            if expanded {
                self.animateSideMenu(targetPosition: self.revealSideMenuOnTop ? 0 : self.sideMenuRevealWidth) { _ in
                    self.isExpanded = true
                }
                // Animate Shadow (Fade In)
                UIView.animate(withDuration: 0.5) { self.sideMenuShadowView.alpha = 0.6 }
            }
            else {
                self.animateSideMenu(targetPosition: self.revealSideMenuOnTop ? (-self.sideMenuRevealWidth - self.paddingForRotation) : 0) { _ in
                    self.isExpanded = false
                }
                // Animate Shadow (Fade Out)
                UIView.animate(withDuration: 0.5) { self.sideMenuShadowView.alpha = 0.0 }
            }
        }
        
        func animateSideMenu(targetPosition: CGFloat, completion: @escaping (Bool) -> ()) {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .layoutSubviews, animations: {
                if self.revealSideMenuOnTop {
                    self.sideMenuTrailingConstraint.constant = targetPosition
                    self.view.layoutIfNeeded()
                }
                else {
                    self.view.subviews[1].frame.origin.x = targetPosition
                }
            }, completion: completion)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
extension UIViewController {
    
    // With this extension you can access the MainViewController from the child view controllers.
    func revealViewController() -> MainViewController? {
        var viewController: UIViewController? = self
        
        if viewController != nil && viewController is MainViewController {
            return viewController! as? MainViewController
        }
        while (!(viewController is MainViewController) && viewController?.parent != nil) {
            viewController = viewController?.parent
        }
        if viewController is MainViewController {
            return viewController as? MainViewController
        }
        return nil
    }
    
}


