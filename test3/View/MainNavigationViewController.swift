//
//  MainNavigationViewController.swift
//  test3
//
//  Created by Alexander Batalov on 4/4/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import UIKit

class MainNavigationViewController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
    }
}
