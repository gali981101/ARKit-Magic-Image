//
//  ViewController.swift
//  AR-Image
//
//  Created by Terry Jason on 2023/12/20.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sceneView.session.run(setConfiguration())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
}

// MARK: - ARSCNViewDelegate

extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let imageAnchor = anchor as? ARImageAnchor else { fatalError() }
        return createNode(imgAnchor: imageAnchor)
    }
    
}

// MARK: - Func

extension ViewController {
    
    private func setConfiguration() -> ARImageTrackingConfiguration {
        let configuration = ARImageTrackingConfiguration()
        
        guard let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "ARImages", bundle: Bundle.main) else { fatalError() }
        
        configuration.trackingImages = trackedImages
        configuration.maximumNumberOfTrackedImages = 1
        
        return configuration
    }
    
    private func createNode(imgAnchor: ARImageAnchor) -> SCNNode {
        let node = SCNNode()
        
        let size = imgAnchor.referenceImage.physicalSize
        let plane = SCNPlane(width: size.width, height: size.height)
        
        plane.firstMaterial?.diffuse.contents = createVideo()
        
        let planeNode = SCNNode(geometry: plane)
        
        planeNode.eulerAngles.x = -.pi / 2
        
        node.addChildNode(planeNode)
        
        return node
    }
    
    private func createVideo() -> SKScene {
        let videoNode = SKVideoNode(fileNamed: "GTAIV.m4v")
        videoNode.play()
         
        let videoScene = SKScene(size: CGSize(width: 3840, height: 2160))
        
        let size = videoScene.size
        videoNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        videoNode.yScale = -1.0
        
        videoScene.addChild(videoNode)
        
        return videoScene
    }
    
}
