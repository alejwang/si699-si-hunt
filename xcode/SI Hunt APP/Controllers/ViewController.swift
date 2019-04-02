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
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var instruction_detail: UILabel!
    

    let fadeDuration: TimeInterval = 0.3
    let rotateDuration: TimeInterval = 3
    let waitDuration: TimeInterval = 0.5
    
    var NODE_URL = "http://alejwang.pythonanywhere.com/nav/node/"
    var PATH_URL = "http://alejwang.pythonanywhere.com/nav/path?start_location="
    var Navnode = [Nodes]()
    var eventLocation: String?
    var eventId: Int?
    var currentlocationId: Int?
    var instruction = [String]()
    var instruction_text = ""
    var headDirection: Int?
    var turn: String?
    var elevator: String?
    var level: Int?
    var step_num: Int?
    var turn_dir: Int?
    
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
        destination.text = eventLocation
        
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
            // print(imageName)
            // Requestion the details of the location: id and name
            let imageNameArr = imageName.characters.split{$0 == "a"}.map(String.init)
            
            self.NODE_URL = self.NODE_URL + imageNameArr[0] + "/" + imageNameArr[1] + "/" + imageNameArr[2] + "/" + imageNameArr[3]
            print(imageNameArr[5])
            self.headDirection = Int(imageNameArr[5])
            
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
        currentlocationId = json["nav_node_result"]["location_id"].intValue
        let node_name = json["nav_node_result"]["location_name"]
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
    
    @IBAction func goNavigation(_ sender: Any) {
        //print(eventId)
        //print(currentlocationId)

        if currentlocationId != nil{
            self.PATH_URL = self.PATH_URL + String(currentlocationId!) + "&end_location=" + String(eventId!)
            print(self.PATH_URL)
            
            Alamofire.request(self.PATH_URL, method: .get).responseJSON {
                response in
                if response.result.isSuccess{
                    print("Get the location!")
                    let pathJSON : JSON = JSON(response.result.value!)
                    
                    for i in pathJSON["path"] {
                        self.step_num = Int(i.0)
                    }
                    
                    for i in pathJSON["path"] {
                        print(i.0)
                        print(i.1)
                        
                        let nav_text = i.1["node_to_id"].intValue
                        let nav_dir = i.1["direction_2d"].intValue
                        let nav_dis = i.1["distance"].intValue
                        let nav_exit_dir = i.1["default_exit_direction"].intValue
                        let nav_level = i.1["to_level"].intValue
                        self.turn = ""
                        
                        // start
                        if (Int(i.0) == 0){
                            self.level = nav_level
                            // start as an elevator
                            if(i.1["node_to_special_type"] == "elevator") {
                                self.turn_dir = nav_exit_dir-self.headDirection!
                            }else{
                                self.turn_dir = self.headDirection!-nav_dir
                            }
                        }else{
                            // end
                            if (Int(i.0) == self.step_num){
                                self.turn_dir = nav_exit_dir - nav_dir
                            }
                            self.turn_dir = self.headDirection!-nav_dir
                        }
                       
                        // direction
                        if (self.turn_dir == (-180)||self.turn_dir == 180) {self.turn = "Turn around and Go "+String(nav_dis)+"mm"}
                        if (self.turn_dir == (-90)||self.turn_dir == 270) {self.turn = "Turn right and Go "+String(nav_dis)+"mm"}
                        if (self.turn_dir == 90||self.turn_dir == (-270)) {self.turn = "Turn left"+String(nav_dis)+"mm"}
                        
                        self.headDirection = nav_dir
                        
                        // for elevator
                        if (i.1["node_to_special_type"] == "elevator") {
                            if (nav_level == self.level){
                                self.elevator = "Take the elevator!"
                            }
                            if (nav_level != self.level!)
                            {
                                // "distance": 1,
                                // "direction_2d": -1
                                self.level = nav_level
                                self.elevator = "Go to the Level " + String(nav_level)
                                self.headDirection = nav_exit_dir
                                self.turn = "no"
                            }
                        }else{
                            self.elevator = "no"
                        }
                        
                        // instruction for navigation!
                        self.instruction.append(self.turn!)
                        self.instruction.append(self.elevator!)
                    }
                    for i in self.instruction {
                        if (i != "no"){
                            self.instruction_text += i
                            self.instruction_text += "\n"
                        }
                    }
                    self.instruction_detail.text = self.instruction_text
                }
                else{
                    print("Error")
                }
            }
            //print(self.instruction_text)
            
            self.PATH_URL = "http://alejwang.pythonanywhere.com/nav/path?start_location="
            self.instruction = []
            self.instruction_text = ""
            self.level = 1
        }
       
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
