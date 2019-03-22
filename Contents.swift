//: A UIKit based Playground to present an ARSKScene so you can play with ARKit in a playground

import UIKit
import ARKit
import PlaygroundSupport
import SceneKit
class QIARViewController : UIViewController {
    var sceneView: ARSCNView!
    var currentFaceAnchor: ARFaceAnchor?
    var featureIndices = [[7]]
    let noseOptions = ["nose01"]
    let features = ["nose"]
    
    
    override func loadView() {
        sceneView = ARSCNView(frame:CGRect(x: 0.0, y: 0.0, width: 500.0, height: 600.0))
        // Set the view's delegate
        sceneView.delegate = self
        
        resetTracking()
        
        self.view = sceneView
    }
    
    func updateFeatures(for node: SCNNode, using anchor: ARFaceAnchor) {
        
        for (feature, indices) in zip(features, featureIndices) {
            let child = node.childNode(withName: feature, recursively: false) as? FaceNode
            let vertices = indices.map { anchor.geometry.vertices[$0] }
            child?.updatePosition(for: vertices)
        }
    }
    
    func resetTracking() {
        let configuratio = ARFaceTrackingConfiguration()
        sceneView.session.run(configuratio)
    }

    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
    }
}



extension QIARViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
    
    let device: MTLDevice!
    device = MTLCreateSystemDefaultDevice()
    guard let faceAnchor = anchor as? ARFaceAnchor else {
    return nil
    }
    let faceGeometry = ARSCNFaceGeometry(device: device)
    let node = SCNNode(geometry: faceGeometry)
    node.geometry?.firstMaterial?.fillMode = .lines
    //node.geometry?.firstMaterial?.transparency = 0.0
    
    let noseNode = FaceNode(with: noseOptions)
    noseNode.name = "nose"
    node.addChildNode(noseNode)
    
    updateFeatures(for: node, using: faceAnchor)
    
    return node
    }
    
    func renderer(
        _ renderer: SCNSceneRenderer,
        didUpdate node: SCNNode,
        for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor,
            let faceGeometry = node.geometry as? ARSCNFaceGeometry else {
                return
        }
        
        faceGeometry.update(from: faceAnchor.geometry)
        updateFeatures(for: node, using: faceAnchor)
    }
}

//: We set our custom code above as our live view so that we can see all our hard work
PlaygroundPage.current.liveView = QIARViewController()
PlaygroundPage.current.needsIndefiniteExecution = true






