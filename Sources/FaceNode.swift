//
//  FaceNode.swift
//  IOS-Swift-ARkitFaceTrackingNose01
//
//  Created by Pooya on 2018-11-27.
//  Copyright © 2018 Soonin. All rights reserved.
//

import SceneKit

public class FaceNode: SCNNode {
    
  public  var options: [String]
  public  var index = 0
    
   public init(with options: [String], width: CGFloat = 0.06, height: CGFloat = 0.06) {
        self.options = options
        
        super.init()
        
        let plane = SCNPlane(width: width, height: height)
        plane.firstMaterial?.diffuse.contents =  UIImage(named: options.first!)
        plane.firstMaterial?.isDoubleSided = true
        
        geometry = plane
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Custom functions

extension FaceNode {
    
    public func updatePosition(for vectors: [vector_float3]) {
        let newPos = vectors.reduce(vector_float3(), +) / Float(vectors.count)
        position = SCNVector3(newPos)
    }
    
    public func next() {
        index = (index + 1) % options.count
        
        if let plane = geometry as? SCNPlane {
            plane.firstMaterial?.diffuse.contents = UIImage(named: options[index])
            plane.firstMaterial?.isDoubleSided = true
        }
    }
}

