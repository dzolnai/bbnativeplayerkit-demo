//
//  Tab1ViewController.swift
//  BlueBillywigNativeiOSDemo
//
//  Created by Olaf Timme on 09/02/2021.
//

import Foundation
import UIKit
import BBNativePlayerKit

class MenuUIViewController: UIViewController, MenuCollectionViewControllerDelegate {
   
    private let backGroundImage:UIImageView = {
    
        let imageView:UIImageView = UIImageView()
        imageView.image = UIImage(named: "wp3692445-ios-12-wallpapers")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Bluebillywig logo WIT")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backGroundImage)
        backGroundImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        backGroundImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        backGroundImage.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backGroundImage.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        
        
       
        let menuCollectionViewController = MenuCollectionViewController()
        menuCollectionViewController.delegate = self
        menuCollectionViewController.view.frame = view.frame
        addChild(menuCollectionViewController)
        let menuCollectionView = menuCollectionViewController.view
        
        let numberOfButtonRows:CGFloat = 4
        
        view.addSubview(menuCollectionView!)
        menuCollectionView?.translatesAutoresizingMaskIntoConstraints = false
        menuCollectionView?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        menuCollectionView?.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        menuCollectionView?.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: 0).isActive = true
        menuCollectionView?.heightAnchor.constraint(equalToConstant: (180 * numberOfButtonRows)).isActive = true
       
        menuCollectionViewController.didMove(toParent: self)
        
        view.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: menuCollectionView!.bottomAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 160).isActive = true

        view.layoutIfNeeded()
    }
    
    func didSelectMenuItem(menuItem: MenuItem) {
        if ( menuItem.name != "" ) {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: menuItem.name) {
                vc.title = menuItem.title
                
                if ( menuItem.name == "Outstream" ) {
                    let alertController = UIAlertController(title: "Enter your outstream json url", message: nil, preferredStyle: .alert)

                    alertController.addTextField { textField in
                        textField.text = "https://demo.bbvms.com/a/native_sdk_outstream.json"
                    }

                    let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
                        if let text = alertController.textFields?.first?.text {
                            if let osvc: OutStreamUIViewController = vc as? OutStreamUIViewController {
                                osvc.jsonUrl = text
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }

                    alertController.addAction(submitAction)

                    present(alertController, animated: true, completion: nil)
                    
                } else if (menuItem.name == "shorts_beta"){
                    let alertController = UIAlertController(title: "Enter your shorts json url", message: nil, preferredStyle: .alert)

                    alertController.addTextField { textField in
                        textField.text = "https://maxetise.bbvms.com/sh/60.json"
                    }

                    let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
                        if let text = alertController.textFields?.first?.text {
                            if let svc: ShortsUIViewController = vc as? ShortsUIViewController {
                                svc.jsonUrl = text
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }

                    alertController.addAction(submitAction)

                    present(alertController, animated: true, completion: nil)
                } else {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}



struct MenuItem {
    var name: String
    var title: String
    var color1: UIColor
    var color2: UIColor
}


protocol MenuCollectionViewControllerDelegate {
    func didSelectMenuItem( menuItem: MenuItem )
}

class MenuCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public var delegate: MenuCollectionViewControllerDelegate?
    
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    private var menuItems = [MenuItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: MenuCollectionViewCell.identifier)

        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        view.backgroundColor = .clear

        var menuItem = MenuItem(name: "api",
                                title: "API",
                                color1: UIColor.init(hex: "#E6787BFF") ?? UIColor.systemGray,
                                color2: UIColor.init(hex: "#DA4749FF") ?? UIColor.systemGray)
        menuItems.append(menuItem)
        menuItem = MenuItem(name: "list",
                                title: "Video List",
                                color1: UIColor.init(hex: "#E7AA5AFF") ?? UIColor.systemGray,
                                color2: UIColor.init(hex: "#DC8237FF") ?? UIColor.systemGray)
        menuItems.append(menuItem)
        menuItem = MenuItem(name: "In-Out-View",
                                title: "In-Out-View",
                                color1: UIColor.init(hex: "#793BEBFF") ?? UIColor.systemGray,
                                color2: UIColor.init(hex: "#4823E2FF") ?? UIColor.systemGray)
        menuItems.append(menuItem)
        menuItem = MenuItem(name: "Outstream",
                                title: "Outstream",
                                color1: UIColor.init(hex: "#78D0F2FF") ?? UIColor.systemGray,
                                color2: UIColor.init(hex: "#47BAECFF") ?? UIColor.systemGray)
        menuItems.append(menuItem)
        menuItem = MenuItem(name: "Pre-Post-Roll",
                                title: "Pre-Post-Roll",
                                color1: UIColor.init(hex: "#9FE499FF") ?? UIColor.systemGray,
                                color2: UIColor.init(hex: "#71D767FF") ?? UIColor.systemGray)
        menuItems.append(menuItem)
        menuItem = MenuItem(name: "WebView",
                                title: "WebView",
                                color1: UIColor.init(hex: "#DE433CFF") ?? UIColor.systemGray,
                                color2: UIColor.init(hex: "#CE2824FF") ?? UIColor.systemGray)
        menuItems.append(menuItem)
        menuItem = MenuItem(name: "Chromecast",
                                title: "ChromeCast",
                                color1: UIColor.init(hex: "#793BEBFF") ?? UIColor.systemGray,
                                color2: UIColor.init(hex: "#47BAECFF") ?? UIColor.systemGray)
        menuItems.append(menuItem)
        menuItem = MenuItem(name: "ChromeCast_Controls",
                                title: "ChromeCast 2",
                                color1: UIColor.init(hex: "#793BEBFF") ?? UIColor.systemGray,
                                color2: UIColor.init(hex: "#47BAECFF") ?? UIColor.systemGray)
        menuItems.append(menuItem)
        menuItem = MenuItem(name: "Load_json_url",
                                title: "Load JSON",
                                color1: UIColor.init(hex: "#793BEBFF") ?? UIColor.systemGray,
                                color2: UIColor.init(hex: "#47BAECFF") ?? UIColor.systemGray)
        menuItem = MenuItem(name: "chapters",
                                title: "Chapters",
                                color1: UIColor.init(hex: "#E6787BFF") ?? UIColor.systemGray,
                                color2: UIColor.init(hex: "#DA4749FF") ?? UIColor.systemGray)
        menuItems.append(menuItem)
        menuItem = MenuItem(name: "highlights",
                                title: "Highlights",
                                color1: UIColor.init(hex: "#DE433CFF") ?? UIColor.systemGray,
                                color2: UIColor.init(hex: "#CE2824FF") ?? UIColor.systemGray)
        menuItems.append(menuItem)
        menuItem = MenuItem(name: "shorts_beta",
                                title: "Shorts Beta",
                                color1: UIColor.init(hex: "#E7AA5AFF") ?? UIColor.systemGray,
                                color2: UIColor.init(hex: "#DC8237FF") ?? UIColor.systemGray)
        menuItems.append(menuItem)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCollectionViewCell.identifier, for: indexPath) as! MenuCollectionViewCell
        cell.setup(with: menuItems[indexPath.row])
        cell.backgroundColor = .clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.didSelectMenuItem(menuItem: menuItems[indexPath.row])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    deinit {
    }
}




class MenuCollectionViewCell: UICollectionViewCell {
    static let identifier = "MenuCollectionViewCell"
    let button:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system) as UIButton
        button.backgroundColor = UIColor.systemTeal
        button.setTitle("", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.white, for:UIControl.State.normal)
        button.sizeToFit()
       
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        
        let button1 = CreateButton( title: "API", color1: UIColor.init(hex: "#E7AA5AFF")!, color2: UIColor.init(hex: "#DC8237FF")!)
        button1.addTarget(self, action: #selector(openMenuItem), for: .touchUpInside)
        addSubview(button1)
        button1.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        button1.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setup(with menuItem: MenuItem) {
        button.setTitle(menuItem.title, for: UIControl.State.normal)
        button.isEnabled = false
        button.applyGradient(colours: [menuItem.color1, menuItem.color2])
        button.layer.cornerRadius = 20
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 160).isActive = true
        button.heightAnchor.constraint(equalToConstant: 160).isActive = true
       
    }

   
    deinit {
    }
    
    @objc func openMenuItem(gesture: UITapGestureRecognizer) {
        
    }
    
    
    private func CreateButton( title: String, color1: UIColor, color2: UIColor)-> UIButton {
        
        return button
    }
}

extension UIView {
    @discardableResult
    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }

    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: 160, height: 160)
        gradient.colors = colours.map { $0.cgColor }
        
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.cornerRadius = 20
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
