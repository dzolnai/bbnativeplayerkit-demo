//
//  ShortsUIViewController.swift
//  bbnativeplayerkit-demo
//
//  Created by Olaf Timme on 10/06/2024.
//

import Foundation
import UIKit
import BBNativePlayerKit

class ShortsUIViewController: UIViewController {

    internal var bbShortsView: BBNativeShortsView? = nil
    internal var jsonUrl:String = "https://testsuite.acc.bbvms.com/sh/17.json"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bbShortsView = BBNativeShorts.createShortsView(uiViewController: self, frame: view.frame, jsonUrl: jsonUrl)
        view.addSubview(bbShortsView!)
        bbShortsView?.translatesAutoresizingMaskIntoConstraints = false
        bbShortsView?.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        bbShortsView?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0 ).isActive = true
        bbShortsView?.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        bbShortsView?.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor).isActive = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        bbShortsView?.destroy()
        super.viewWillDisappear(animated)
    }
}
