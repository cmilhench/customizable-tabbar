//
//  TabBarController.swift
//  customizable-tabbar
//
//  Created by Colin Milhench on 07/08/2019.
//  Copyright © 2019 Colin Milhench. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    private var availableViewControllers: [UIViewController]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create the available view controllers
        let ctrl1 = viewController(withTitle: "First", icon: "first", backgroundColor: .white)
        let ctrl2 = viewController(withTitle: "Second", icon: "second", backgroundColor: .green)
        let ctrl3 = viewController(withTitle: "Third", icon: "first", backgroundColor: .yellow)
        let ctrl4 = viewController(withTitle: "Fourth", icon: "second", backgroundColor: .brown)
        let ctrl5 = viewController(withTitle: "Fifth", icon: "first", backgroundColor: .red)
        let ctrl6 = viewController(withTitle: "Sixth", icon: "second", backgroundColor: .gray)
        let ctrl7 = viewController(withTitle: "Seventh", icon: "first", backgroundColor: .blue)
        let ctrl8 = viewController(withTitle: "Eighth", icon: "second", backgroundColor: .black)
        availableViewControllers = [ctrl1, ctrl2, ctrl3, ctrl4, ctrl5, ctrl6, ctrl7, ctrl8]

        // restore the view controller order
        let defaults = UserDefaults.standard
        if let order = defaults.object(forKey:"tabOrder") as? [Int] {
            viewControllers = order.map { return availableViewControllers![$0] }
        } else {

            viewControllers = availableViewControllers?.map({ return $0 })
        }

        // restore the selected index
        if let index = defaults.object(forKey:"tabSelected") as? Int {
            selectedIndex = index
        }

        // indicate which controllers are customizable
        let slice = viewControllers![2...]
        customizableViewControllers = Array(slice)

        self.delegate = self
    }

    private func viewController(withTitle title: String, icon: String, backgroundColor: UIColor) -> UIViewController {
        let viewController = UIViewController()
        viewController.title = title
        viewController.view.backgroundColor = backgroundColor
        viewController.tabBarItem.image = UIImage(named: icon)
        return viewController
    }
}

extension TabBarController : UITabBarControllerDelegate {

    // store the selected index
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let index = tabBar.items!.firstIndex(of: item)
        // dont save the more tab
        if index == 4 { return }
        let defaults = UserDefaults.standard
        defaults.set(index, forKey: "tabSelected")
    }

    // store the customized tab order
    override func tabBar(_ tabBar: UITabBar, didEndCustomizing items: [UITabBarItem], changed: Bool) {
        let order = viewControllers?.map({ (ctrl) -> Int? in
            return availableViewControllers?.firstIndex(of: ctrl)
        })
        let defaults = UserDefaults.standard
        defaults.set(order, forKey: "tabOrder")
    }

}
