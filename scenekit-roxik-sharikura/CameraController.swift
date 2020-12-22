//
//  CameraController.swift
//  scenekit-roxik-sharikura
//
//  Created by Jason Sturges on 12/12/20.
//

import Foundation
import SceneKit

class CameraController {
    
    var cameraNode: SCNNode!
    var frameNumber: Int = 0
    var sceneLimit: Int = 90
    var target: SCNVector3! = SCNVector3(x: 0, y: 0, z: 0)
    var targetModel: Sphere! = nil
    var bl: Float = 6.0
    var rp: Float = 0.03
    var cs: Float = 0.0
    var gy: Float = 0.0
    var l: Float = 0.0
    var ts: Float = 0.0
    var r: Float = 0.0

    func setCamera(node: SCNNode) {
        cameraNode = node
    }
    
}

extension CameraController: FrameHandlerDelegate {
    
    func didEnterFrame(models: [Sphere]) {
        if (frameNumber % sceneLimit == 0) {
            sceneLimit = Int.random(in: 45...90)
            targetModel = models.randomElement()!
            ts = 0.0
            cs = 0.0
            gy = Float.random(in: -4.0..<4.0)
            rp = Float.random(in: -0.03..<0.03)
            bl = Float.random(in: 7.0..<11.0)
        }

        if (ts < 0.05) {
            ts += 0.005
        }

        if (cs < 0.5) {
            cs += 0.005
        }

        r += rp
        l += (bl - l) * 0.1

        let targetPosition = targetModel.position
        target.x += (targetPosition.x - target.x) * ts
        target.y += (targetPosition.y - target.y) * ts
        target.z += (targetPosition.z - target.z) * ts

        let cameraPosition = cameraNode.position
        cameraNode.position.x = (cameraPosition.x + (cos(r) * l + targetPosition.x - cameraPosition.x) * cs)
        cameraNode.position.y = cameraPosition.y + (targetPosition.y + gy - cameraPosition.y) * cs
        cameraNode.position.z = (cameraPosition.z + (sin(r) * l + targetPosition.z - cameraPosition.z) * cs)

        cameraNode.look(at: target, up: SCNVector3(0, 1, 0), localFront: SCNVector3(0, 0, -1))

        frameNumber += 1
    }
    
}
