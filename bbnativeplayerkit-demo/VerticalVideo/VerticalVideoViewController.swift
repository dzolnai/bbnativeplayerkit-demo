
import UIKit

class VerticalVideoViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        return UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    }()
    
    private let startIndex: Int
    private let assets: [String] = [
        "sourceid_string:VV_4867884",
        "sourceid_string:VV_4867850",
        "sourceid_string:VV_4867848",
        "sourceid_string:VV_4867471",
        "sourceid_string:VV_4867347",
        "sourceid_string:VV_4867135",
        "sourceid_string:VV_4867140",
        "sourceid_string:VV_4867056",
        "sourceid_string:VV_4867116",
        "sourceid_string:VV_4867029",
        "sourceid_string:VV_4866622",
        "sourceid_string:VV_4866805",
        "sourceid_string:VV_4866521",
        "sourceid_string:VV_4866555",
        "sourceid_string:VV_4866160"
    ]
    private var previousIndex: Int
    private var dataSource: VerticalVideoDataSource!
    private var autoScrollIndexPath: IndexPath?
    
    init(startIndex: Int) {
        self.startIndex = startIndex
        self.previousIndex = startIndex
        super.init(nibName: nil, bundle: nil)
        self.dataSource = VerticalVideoDataSource(assets: assets, uiViewController: self)
    }
    
    required init?(coder: NSCoder) {
        self.startIndex = 0
        self.previousIndex = 0
        super.init(coder: coder)
        self.dataSource = VerticalVideoDataSource(assets: assets, uiViewController: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBarAppearance()
        setNeedsStatusBarAppearanceUpdate()
        
        setNavTitle(for: startIndex + 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self, self.startIndex > 0 else {
                return
            }
            self.scrollToIndex(index: self.startIndex)
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func scrollToIndex(index: Int, animated: Bool = false) {
        if let rect = self.collectionView.layoutAttributesForItem(at: IndexPath(row: index, section: 0))?.frame {
            self.collectionView.scrollRectToVisible(rect, animated: animated)
            setNavTitle(for: index + 1)
        } else if index >= assets.count {
            onBackButtonTapped()
        }
    }
    
    private func setNavTitle(for currentItem: Int) {
        navigationItem.title = "\(currentItem) / \(assets.count)"
    }
    
    private func getStatusBarHeight() -> CGFloat {
        let statusBarHeight: CGFloat = UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0
        return statusBarHeight
    }
    
    private func setNavigationBarAppearance() {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    deinit {
        collectionView.dataSource = nil
        collectionView.prefetchDataSource = nil
    }
}

private extension VerticalVideoViewController {
    private func setupCollectionView() {
        view.backgroundColor = .black
        
        collectionView.backgroundColor = .black
        
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.delegate = self
        collectionView.contentInsetAdjustmentBehavior = .never
        let nib = UINib(nibName: "VerticalVideoCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "VerticalVideoCollectionViewCell")
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupDataSource() {
        collectionView.dataSource = dataSource
        dataSource.delegate = self
    }
    
    private func getIndexPathForCurrentItem() -> IndexPath? {
        var visibleRect = CGRect()
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        return collectionView.indexPathForItem(at: visiblePoint)
    }
    
    private func playItem(at indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? VerticalVideoCollectionViewCell {
            if cell.player?.player.state == .paused {
                cell.player?.player.play()
            }
        }
    }
}

private extension VerticalVideoViewController {
    
    @objc func onBackButtonTapped() {
        self.dataSource = nil
        self.navigationController?.dismiss(animated: true)
    }
}

// MARK: UICollectionViewDelegate
extension VerticalVideoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let videocell = cell as? VerticalVideoCollectionViewCell else { return }
        videocell.playerShouldPlay = true
        videocell.seekIfNotInTheBeginning()
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let videocell = cell as? VerticalVideoCollectionViewCell else { return }
        videocell.playerShouldPlay = false
    }
}

extension VerticalVideoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension VerticalVideoViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard let indexPath = getIndexPathForCurrentItem() else { return }
        if let cell = collectionView.cellForItem(at: indexPath) as? VerticalVideoCollectionViewCell {
            cell.player?.player.pause()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let indexPath = getIndexPathForCurrentItem() else { return }
        if indexPath == autoScrollIndexPath {
            playItem(at: indexPath)
            autoScrollIndexPath = nil
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if previousIndex == assets.count - 1 && velocity.y > 0 {
            onBackButtonTapped()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let indexPath = getIndexPathForCurrentItem(), indexPath.count >= 2 else { return }
        setNavTitle(for: indexPath.item + 1)
        playItem(at: indexPath)
        
        // We need to get the previous cell because that is the content we need to track
        guard let cell = collectionView.cellForItem(at: IndexPath(row: previousIndex, section: 0)) as? VerticalVideoCollectionViewCell else { return }
        
        let currentIndex = indexPath[1]
        let currentAsset = assets[previousIndex]
        
        previousIndex = currentIndex
    }
}

extension VerticalVideoViewController: VerticalVideoDataSourceDelegate {
    func didEndPlayingCurrentVideo() {
        if let currentIndexPath = getIndexPathForCurrentItem() {
            let indexToScrollTo: Int = currentIndexPath.item + 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.scrollToIndex(index: indexToScrollTo, animated: true)
                self?.autoScrollIndexPath = IndexPath(item: indexToScrollTo, section: 0)
            }
        }
    }
}
