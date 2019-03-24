/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Main view controller for the AR experience.
*/

import ARKit
import SceneKit
import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var currentLocation: UILabel!
    
    let fadeDuration: TimeInterval = 0.3
    let rotateDuration: TimeInterval = 3
    let waitDuration: TimeInterval = 0.5
    
    var NODE_URL = "http://alejwang.pythonanywhere.com/nav/node/"
    var Navnode = [Nodes]()
    
    lazy var fadeAndSpinAction: SCNAction = {
        return .sequence([
            .fadeIn(duration: fadeDuration),
            .rotateBy(x: 0, y: 0, z: CGFloat.pi * 360 / 180, duration: rotateDuration),
            .wait(duration: waitDuration),
            .fadeOut(duration: fadeDuration)
            ])
    }()
    
    lazy var fadeAction: SCNAction = {
        return .sequence([
            .fadeOpacity(by: 0.8, duration: fadeDuration),
            .wait(duration: waitDuration),
            .fadeOut(duration: fadeDuration)
            ])
    }()
    
    
    /// The view controller that displays the status and "restart experience" UI.
    lazy var statusViewController: StatusViewController = {
        return childViewControllers.lazy.compactMap({ $0 as? StatusViewController }).first!
    }()
    
    /// A serial queue for thread safety when modifying the SceneKit node graph.
    let updateQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! +
        ".serialSceneKitQueue")
    
    /// Convenience accessor for the session owned by ARSCNView.
    var session: ARSession {
        return sceneView.session
    }
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.session.delegate = self

        // Hook up status view controller callback(s).
        statusViewController.restartExperienceHandler = { [unowned self] in
            self.restartExperience()
        }
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		// Prevent the screen from being dimmed to avoid interuppting the AR experience.
		UIApplication.shared.isIdleTimerDisabled = true

        // Start the AR experience
        resetTracking()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

        session.pause()
	}

    // MARK: - Session management (Image detection setup)
    
    /// Prevents restarting the session while a restart is in progress.
    var isRestartAvailable = true

    /// Creates a new AR configuration to run on the `session`.
    /// - Tag: ARReferenceImage-Loading
	func resetTracking() {
        
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

        statusViewController.scheduleMessage("Look around to detect images", inSeconds: 7.5, messageType: .contentPlacement)
	}

    // MARK: - ARSCNViewDelegate (Image detection results)
    /// - Tag: ARImageAnchor-Visualizing
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        //guard let imageAnchor = anchor as? ARImageAnchor else { return }
        //let referenceImage = imageAnchor.referenceImage.name else { return }
        updateQueue.async {
            
        }

        DispatchQueue.main.async {
            guard let imageAnchor = anchor as? ARImageAnchor,
                let imageName = imageAnchor.referenceImage.name else { return }
            
            // Requestion the details of the location: id and name
            let imageNameArr = imageName.characters.split{$0 == "a"}.map(String.init)
            self.NODE_URL = self.NODE_URL + imageNameArr[0] + "/" + imageNameArr[1] + "/" + imageNameArr[2] + "/" + imageNameArr[3]
            print(self.NODE_URL)
            
            Alamofire.request(self.NODE_URL, method: .get).responseJSON {
                response in
                if response.result.isSuccess{
                    print("Get the location!")
                    let startJSON : JSON = JSON(response.result.value!)
                    self.updateStartNode(json: startJSON)
                }
                else{
                    print("Error")
                }
            }
            self.NODE_URL = "http://alejwang.pythonanywhere.com/nav/node/"
        }
    }
    
    func updateStartNode(json:JSON) {
        
        // Get the location id
        let node_id = json["nav_node_result"]["id"]//.arrayValue
        print(node_id)
        
        // Get the location name
        let node_name = json["nav_node_result"]["location_name"]
        print(node_name)
        currentLocation.text = node_name.stringValue
        
        // Show the location name on the User interfaces
        self.statusViewController.cancelAllScheduledMessages()
        self.statusViewController.showMessage("Detected image “\(node_name)”")
//        for node in node_results {
//                self.Navnode.append(Nodes(id: node["id"].intValue,
//                                    building: node["building"].stringValue,
//                                    level: node["level"].intValue,
//                                    pos_x: node["pos_x"].intValue ,
//                                    pos_y: node["pos_y"].intValue,
//                                    default_exit_direction: node["default_exit_direction"].intValue,
//                                    location_id: node["location_id"].intValue,
//                                    location_name: node["location_name"].stringValue)!)
//        }
    }
    
    var imageHighlightAction: SCNAction {
        return .sequence([
            .wait(duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOpacity(to: 0.15, duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOut(duration: 0.5),
            .removeFromParentNode()
        ])
    }
}
