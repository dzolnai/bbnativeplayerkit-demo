import UIKit
import BBNativePlayerKit
import AVFoundation
import AVKit
import bbnativeshared

class APIUIViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var APIActionUIPickerView: UIPickerView!
    
    private var bbPlayerView: BBNativePlayerView? = nil
    lazy var playerHeightConstraint = bbPlayerView?.heightAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.width * 9/16)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Connect data to UIPickerView:
        APIActionUIPickerView.dataSource = self
        APIActionUIPickerView.delegate = self

        // create player view using the embed url
        bbPlayerView = BBNativePlayer.createPlayerView(uiViewController: self, frame: view.frame, jsonUrl: "https://omroepwest.bbvms.com/p/regiogroei_west_ios_videoplayer_vertical_preroll/q/sourceid_string%3AVV_4867116.json",
                                                       options: ["allowCollapseExpand": false, "autoPlay": true, "noChromeCast": true])
        
        // use constraints to place and size the player view
        view.addSubview(bbPlayerView!)
        bbPlayerView?.translatesAutoresizingMaskIntoConstraints = false
        bbPlayerView?.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        bbPlayerView?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0 ).isActive = true
        bbPlayerView?.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        if ( view.safeAreaLayoutGuide.layoutFrame.width > view.safeAreaLayoutGuide.layoutFrame.height ) {
            self.playerHeightConstraint?.constant = self.view.safeAreaLayoutGuide.layoutFrame.height
        } else {
            self.playerHeightConstraint?.constant = self.view.safeAreaLayoutGuide.layoutFrame.width * 9/16
        }
        playerHeightConstraint?.isActive = true
        
        // set class to delegate of player view
        bbPlayerView?.delegate = self
        
        // place the cast button in the navigation bar
        if let castButton = bbPlayerView?.player.createChromeCastButton {
            castButton.tintColor = UIColor.black
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: castButton)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            guard let self else {
                return
            }
            self.bbPlayerView?.player.pause()
            self.bbPlayerView?.destroy()
            self.bbPlayerView?.delegate = nil
            self.bbPlayerView?.removeFromSuperview()
        }
    }
    
    //MARK: - API TESTS UI ELEMENTS
    @IBOutlet weak var debugTextLabel: UILabel!
    @IBOutlet weak var debugUIText: UITextField!
    @IBOutlet weak var debugUITextView: UITextView!
    
    
    //MARK: - UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return APIActions.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       return APIActions[row]
    }
    
    private var APIActions: [String] = ["Select API method", "Play", "Pause", "Seek", "Mute", "Unmute", "loadMediaClipById", "loadProjectById", "loadMediaClipListById", "loadMediaClip","loadProject","loadMediaClipList", "getMuted", "getDuration", "getPhase", "getState", "getMode", "getClipData", "getPlayoutData", "getProjectData", "getVolume", "OpenModalPlayer"]
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
    switch APIActions[row] {
        case "Fullscreen":
            //bbPlayerView?.setApiProperty(property: .fullscreen, value: true)
            break
        case "RetractFullscreen":
            //bbPlayerView?.setApiProperty(property: .fullscreen, value: false)
            break
        case "Play":
            bbPlayerView?.player.play()
            break
        case "Pause":
            bbPlayerView?.player.pause()
            break
        case "Seek":
            bbPlayerView?.player.seek(offsetInSeconds: 10)
            break
        case "Mute":
            bbPlayerView?.player.muted = true
            break
        case "Unmute":
            bbPlayerView?.player.muted = false
            break
        case "loadMediaClip":
            self.loadMediaClip()
            break
        case "loadProject":
            self.loadProject()
            break
        case "loadMediaClipList":
            self.loadMediaClipList()
            break
        case "loadMediaClipById":
            bbPlayerView?.player.loadWithClipId(clipId: "4256575", initiator: nil, autoPlay: true, seekTo: nil)
            break
        case "loadProjectById":
            bbPlayerView?.player.loadWithProjectId(projectId: "2209", initiator: nil, autoPlay: true, seekTo: nil)
            break
        case "loadMediaClipListById":
            bbPlayerView?.player.loadWithClipListId(clipListId: "1619442239940600", initiator: nil, autoPlay: true, seekTo: nil)
            break
        case "getClipData":
            if let mediaClip: MediaClip = bbPlayerView?.player.clipData {
                showValue(title: "Clip id", message: mediaClip.id!)
            } else {
                showValue(title: "Data", message: "Not available atm")
            }
            break
        case "getDuration":
            if ( bbPlayerView?.player.duration != nil ) {
                showValue(title: "Duration", message: "\(String(describing: bbPlayerView?.getApiProperty(property: .duration)))")
            } else {
                showValue(title: "Data", message: "Not available atm")
            }
            break
        case "getMuted":
            if let muted: Bool = bbPlayerView?.player.muted {
                showValue(title: "Muted?", message: String(muted))
            } else {
                showValue(title: "Data", message: "Not available atm")
            }
            break
        case "getPhase":
            if let phase: Phase = bbPlayerView?.player.phase {
                showValue(title: "Phase", message: "\(String(describing: phase))")
            } else {
                showValue(title: "Data", message: "Not available atm")
            }
            break
        case "getState":
            if let state: State = bbPlayerView?.player.state {
                showValue(title: "State", message: "\(String(describing: state))")
            } else {
                showValue(title: "Data", message: "Not available atm")
            }
            break
        case "getMode":
            if let mode: String = bbPlayerView?.player.mode {
                showValue(title: "Mode", message: "\(String(describing: mode))")
            } else {
                showValue(title: "Data", message: "Not available atm")
            }
            break
        case "getPlayoutData":
            if let playout: Playout = bbPlayerView?.player.playoutData {
                showValue(title: "Playout name", message: playout.name!)
            } else {
                showValue(title: "Data", message: "Not available atm")
            }
            break
        case "getProjectData":
            if let project: Project = bbPlayerView?.player.projectData {
                showValue(title: "Project name", message: project.name!)
            } else {
                showValue(title: "Data", message: "Not available atm")
            }
            break
            
        case "getVolume":
            if let volume: Float = bbPlayerView?.player.volume {
                showValue(title: "Project name", message: "\(volume)")
            } else {
                showValue(title: "Data", message: "Not available atm")
            }
            break
        case "OpenModalPlayer":
            _ = BBNativePlayer.createModalPlayerView(uiViewContoller: self, jsonUrl: "https://demo.bbvms.com/p/default/c/4256615.json")
            break
        default:
                break
            }
    }
    
    //MARK: - API load types
    func loadMediaClip() {
        if let url = URL(string: "https://demo.bbvms.com/json/mediaclip/4256575" ) {
            // Create a URLSession
            let session: URLSession = URLSession(configuration: .default)
            
            // Give the session a task
            let task: URLSessionTask = session.dataTask(with: url) { (data, response, error) in
                if ( error != nil ) {
                    print("MediaClip load failed")
                    return
                }
                if let safeData = data {
                    let dataString = String(data: safeData, encoding: .utf8) ?? ""
                    
                    // Option 1: use the jsonstring to load content (uncomment and comment option 2 to try)
//                    DispatchQueue.main.async {
//                        self.bbPlayerView?.callApiMethod(method: .load_, args: ["clipDataJsonString": dataString, "autoPlay": true])
//                    }
                    
                    // Option 2: parse the data using ContentLoader Companion object, then use parsed object to load content (uncomment and comment option 1 to try)
                    DispatchQueue.main.async {
                        if let clip: MediaClip = ContentLoader.Companion.init().parseMediaClip(jsonString: dataString) {
                            self.bbPlayerView?.callApiMethod(method: .load_, args: ["clipData": clip, "autoPlay": false])
                        } else {
                            print("Parsing of MediaClip Failed:")
                        }
                    }
                }
            }
            
            // Start the task and load the url
            task.resume()
        }
    }
        
    func loadProject() {
        if let url = URL(string: "https://demo.bbvms.com/json/project/2209" ) {
            // Create a URLSession
            let session: URLSession = URLSession(configuration: .default)
            
            // Give the session a task
            let task: URLSessionTask = session.dataTask(with: url) { (data, response, error) in
                if ( error != nil ) {
                    print("Project load failed")
                    return
                }
                if let safeData = data {
                    let dataString = String(data: safeData, encoding: .utf8) ?? ""
                    
                    // Option 1: use the jsonstring to load content (uncomment and comment option 2 to try)
//                    DispatchQueue.main.async {
//                        self.bbPlayerView?.callApiMethod(method: .load_, args: ["projectDataJsonString": dataString, "autoPlay": true])
//                    }
                    
                    // Option 2: parse the data using ContentLoader Companion object, then use parsed object to load content (uncomment and comment option 1 to try)
                    DispatchQueue.main.async {
                        if let project: Project = ContentLoader.Companion.init().parseProject(jsonString: dataString) {
                            self.bbPlayerView?.callApiMethod(method: .load_, args: ["projectData": project, "autoPlay": true])
                        } else {
                            print("Parsing Project Failed:")
                        }
                    }
                }
            }
            
            // Start the task and load the url
            task.resume()
        }
    }
    func loadMediaClipList() {
        if let url = URL(string: "https://demo.bbvms.com/json/mediacliplist/1619442239940600" ) {
            // Create a URLSession
            let session: URLSession = URLSession(configuration: .default)
            
            // Give the session a task
            let task: URLSessionTask = session.dataTask(with: url) { (data, response, error) in
                if ( error != nil ) {
                    print("MediaClipList load failed")
                    return
                }
                if let safeData = data {
                    let dataString = String(data: safeData, encoding: .utf8) ?? ""
                    
                    // Option 1: use the jsonstring to load content (uncomment and comment option 2 to try)
//                    DispatchQueue.main.async {
//                        self.bbPlayerView?.callApiMethod(method: .load_, args: ["clipListDataJsonString": dataString, "autoPlay": true])
//                    }
                    
                    // Option 2: parse the data using ContentLoader Companion object, then use parsed object to load content (uncomment and comment option 1 to try)
                    DispatchQueue.main.async {
                        if let clipList: MediaClipList = ContentLoader.Companion.init().parseMediaClipList(jsonString: dataString) {
                            self.bbPlayerView?.callApiMethod(method: .load_, args: ["clipListData": clipList, "autoPlay": true])

                        } else {
                            print("Parsing MediaClipList Failed:")
                        }
                    }
                }
            }
            
            // Start the task
            task.resume()
        }
    }
    
    
    
    //MARK: - Debug Info in UI
    func showValue(title: String, message: String) {
        debugTextLabel.text = title
        debugUIText.text = message
    }
    
    func addToEventDebug( _ message: String ) {
        debugUITextView.text.append(message + "\n")
        let range = NSMakeRange((debugUITextView.text.count) - 1, 0)
        debugUITextView.scrollRangeToVisible(range)
    }
    
    //MARK: - Handle rotation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.orientation.isLandscape {
            DispatchQueue.main.async {
                self.playerHeightConstraint?.constant = self.view.safeAreaLayoutGuide.layoutFrame.height
            }
        } else {
            DispatchQueue.main.async {
                self.playerHeightConstraint?.constant = self.view.safeAreaLayoutGuide.layoutFrame.width * 9/16
            }
        }
    }
}




//MARK: - BBNativePlayerViewDelegate in extension

//Implements BBNativePlayerViewDelegate to receive all API events and logs them in the DebugUITextView
extension APIUIViewController: BBNativePlayerViewDelegate {
    
    func didSetupWithJsonUrl(url: String?) {
        addToEventDebug("Player API Delegate: didSetupWithJson")
    }
    
    func bbNativePlayerView(playerView: BBNativePlayerView, didTriggerMediaClipLoaded data: MediaClip) {
        addToEventDebug("Player API Delegate: didTriggerMediaClipLoaded")
    }

    func bbNativePlayerView(didTriggerMediaClipFailed playerView: BBNativePlayerView) {
        addToEventDebug("Player API Delegate: didTriggerMediaClipFailed")
    }
    
    func bbNativePlayerView(didTriggerViewStarted playerView: BBNativePlayerView) {
        addToEventDebug("Player API Delegate: didTriggerViewStarted")
    }
    
    func bbNativePlayerView(didTriggerViewFinished playerView: BBNativePlayerView) {
        addToEventDebug("Player API Delegate: didTriggerViewFinished")
    }
    
    func bbNativePlayerView(playerView: BBNativePlayerView, didTriggerProjectLoaded data: Project) {
        addToEventDebug("Player API Delegate: didTriggerProjectLoaded")
    }
    
    func bbNativePlayerView(didTriggerCanPlay playerView: BBNativePlayerView) {
        addToEventDebug("Player API Delegate: didTriggerCanPlay")
    }
    
    func bbNativePlayerView(playerView: BBNativePlayerView, didTriggerDurationChange duration: Double) {
        addToEventDebug("Player API Delegate: didTriggerDurationChange : \(duration)")
    }
    
    func bbNativePlayerView(didTriggerPause playerView: BBNativePlayerView) {
        addToEventDebug("Player API Delegate: didTriggerPause")
        print("*** pause")
    }
    
    func bbNativePlayerView(didTriggerPlaying playerView: BBNativePlayerView) {
        addToEventDebug("Player API Delegate: didTriggerPlaying")
        print("*** playing")
    }
    
    func bbNativePlayerView(didTriggerEnded playerView: BBNativePlayerView) {
        addToEventDebug("Player API Delegate: didTriggerEnded")
    }
   
    func bbNativePlayerView(didTriggerSeeking playerView: BBNativePlayerView) {
        addToEventDebug("Player API Delegate: didTriggerSeeking")
    }
    
    func bbNativePlayerView(playerView: BBNativePlayerView, didTriggerSeeked seekOffset: Double) {
        addToEventDebug("Player API Delegate: didTriggerSeeked : \(seekOffset)")
    }
    
    func bbNativePlayerView(didTriggerStall playerView: BBNativePlayerView) {
        addToEventDebug("Player API Delegate: didTriggerStall")
    }
    
    func bbNativePlayerView(didTriggerAutoPause playerView: BBNativePlayerView) {
        addToEventDebug("Player API Delegate: didTriggerAutoPause")
    }
    
    func bbNativePlayerView(didTriggerAutoPausePlay playerView: BBNativePlayerView) {
        addToEventDebug("Player API Delegate: didTriggerAutoPausePlay")
    }
    
    func bbNativePlayerView(playerView: BBNativePlayerView, didFailWithError error: String?) {
        addToEventDebug("Player API Delegate: didFailWithError")
    }
    
    func bbNativePlayerView(playerView: BBNativePlayerView, didTriggerAdError error: String?) {
        addToEventDebug("Player API Delegate: didTriggerAdError : \(String(describing: error))")
    }

    func bbNativePlayerView(playerView: BBNativePlayerView, didTriggerPhaseChange phase: Phase?) {
        addToEventDebug("Player API Delegate: didTriggerPhaseChange : \(String(describing: phase))")
    }
    
    func bbNativePlayerView(playerView: BBNativePlayerView, didTriggerStateChange state: State?) {
        addToEventDebug("Player API Delegate: didTriggerStateChange : \(String(describing: state))")
    }
    
    func didRequestOpenUrl(url: String?) {
        addToEventDebug("Player API Delegate: didRequestOpenUrl : \(String(describing: url))")
    }
    
    func bbNativePlayerView(didTriggerAdLoaded playerView: BBNativePlayerView) {
        addToEventDebug("Player API Delegate: didTriggerAdLoaded")
//        print("*** didTriggerAdLoaded  adMediaWidth = \(self.bbPlayerView?.player.adMediaWidth) ")
//        print("*** didTriggerAdLoaded  adMediaHeight = \(self.bbPlayerView?.player.adMediaHeight) ")
    }
    
    func bbNativePlayerView(didTriggerAdSwipeLeft playerView: BBNativePlayerView) {
        addToEventDebug("Player API Delegate: didtriggerAdSwipeLeft")
    }

    func bbNativePlayerView(didTriggerAdSwipeRight playerView: BBNativePlayerView) {
        addToEventDebug("Player API Delegate: didtriggerAdSwipeRight")
    }
        
    func bbNativePlayerView(didRequestCollapse playerView: BBNativePlayerView) {
        print("*** did request collapse")
    }
    
    
    func bbNativePlayerView(didRequestExpand playerView: BBNativePlayerView) {
        print("*** did request expand")
    }
    
    func bbNativePlayerView(didTriggerUIPanGesture playerView: BBNativePlayerView, translation: CGPoint) {
        print("***** didTriggerUIPangesture: translation = \(translation)")
    }
    
    func bbNativePlayerView(playerView: BBNativePlayerView, didTriggerCustomStatistics ident: String, ev: String, aux: [String : String]) {
        print("CUSTOM STATISTICS: \(ev)")
    }
}
