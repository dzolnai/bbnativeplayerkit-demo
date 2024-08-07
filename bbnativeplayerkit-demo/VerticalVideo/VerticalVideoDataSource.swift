//
//  VerticalVideoDataSource.swift
//  bbnativeplayerkit-demo
//
//  Created by Dániel Zolnai on 07/08/2024.
//

import UIKit
import AVKit

protocol VerticalVideoDataSourceDelegate: AnyObject {
    func didEndPlayingCurrentVideo()
}

class VerticalVideoDataSource: NSObject, UICollectionViewDataSource {
    
    weak var delegate: VerticalVideoDataSourceDelegate?
    
    private let uiViewController: VerticalVideoViewController
    
    private let assets: [String]
        
    init(assets: [String], uiViewController: VerticalVideoViewController) {
        self.assets = assets
        self.uiViewController = uiViewController
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSession.Category.playback, options: [])
            try session.setActive(true, options: [])
        } catch {
            NSLog("⚠️ AVAudioSession error: \(error)")
        }
    }

    // MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }

    /// - Tag: CellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VerticalVideoCollectionViewCell", for: indexPath) as? VerticalVideoCollectionViewCell else {
            fatalError("Could not dequeue cell!")
        }
        
        let asset = assets[indexPath.row]
        cell.representedId = asset
        cell.delegate = self
        cell.uiController = self.uiViewController
        cell.configure(for: asset)
        
        return cell
    }
}

extension VerticalVideoDataSource: VerticalVideoCellDelegate {
    func didEndPlayingCurrentVideo() {
        delegate?.didEndPlayingCurrentVideo()
    }
}
