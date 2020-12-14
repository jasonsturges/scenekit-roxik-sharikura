//
//  Sphere.swift
//  scenekit-roxik-sharikura
//
//  Created by Jason Sturges on 12/12/20.
//

import SceneKit

class Sphere {
    var geometry: SCNGeometry!
    var geometryNode: SCNNode!
    var color: UIColor!
    var speed: Float = 0.0
    var acceleration: Float = 0.0
    var animate: Bool = false
    var dest: SCNVector3 = SCNVector3()
    var direction: SCNVector3 = SCNVector3()

    var position: SCNVector3 {
        get {
            return geometryNode.position
        }
        set(value) {
            geometryNode.position = value
        }
    }
    
    init(fromColor color: UIColor) {
        self.geometry = SCNSphere(radius: 0.3)
        self.geometryNode = SCNNode(geometry: geometry)
        self.color = color
        
        geometry.materials.first?.diffuse.contents = color
        geometry.materials.first?.specular.contents = color
    }
}
