//
//  GameViewController.swift
//  scenekit-roxik-sharikura
//
//  Created by Jason Sturges on 12/9/20.
//

import UIKit
import QuartzCore
import SceneKit

protocol FrameHandlerDelegate {
    func didEnterFrame(models: [Sphere])
}

class GameViewController: UIViewController, SCNSceneRendererDelegate {

    var gameView: SCNView!
    var gameScene: SCNScene!
    var cameraNode: SCNNode!
    let cameraControler: CameraController = CameraController()
    var cameraDelegate:FrameHandlerDelegate!
    var models = [Sphere]()
    let motionController: MotionController = MotionController()
    var motionDelegate:FrameHandlerDelegate!
    var targetCreationTime: TimeInterval = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        cameraDelegate = cameraControler
        motionDelegate = motionController

        initView()
        initScene()
        initCamera()
        createTarget()
    }

    func initView() {
        gameView = (self.view as! SCNView)
        gameView.allowsCameraControl = false
        gameView.autoenablesDefaultLighting = true

        gameView.delegate = self
    }

    func initScene() {
        gameScene = SCNScene()
        gameView.scene = gameScene

        gameView.isPlaying = true
    }

    func initCamera() {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 5, z: 10)
        gameView.pointOfView = cameraNode
        
        cameraControler.setCamera(node: cameraNode)
    }

    func createTarget() {
        let cube = SCNBox(width: 18, height: 18, length: 18, chamferRadius: 0.0)
        cube.lengthSegmentCount = 4
        cube.materials.first?.fillMode = .lines
        cube.materials.first?.isDoubleSided = true
        let cubeNode = SCNNode(geometry: cube)
        
        gameScene.rootNode.addChildNode(cubeNode)
        
        let bet: Float = 0.7
        let offset: Float = (8 - 1) * bet * 0.5
        let colors = [
            UIColor(red: 0.592, green: 0.207, blue: 0.043, alpha: 1),
            UIColor(red: 0.149, green: 0.431, blue: 0.647, alpha: 1),
            UIColor(red: 0.000, green: 0.517, blue: 0.498, alpha: 1),
            UIColor(red: 0.184, green: 0.505, blue: 0.556, alpha: 1),
            UIColor(red: 0.031, green: 0.568, blue: 0.486, alpha: 1),
            UIColor(red: 0.419, green: 0.270, blue: 0.549, alpha: 1),
            UIColor(red: 0.478, green: 0.270, blue: 0.149, alpha: 1)
        ]

        for i in 1...8 {
            for j in 1...8 {
                for k in 1...8 {
                    let color = colors.randomElement()!
                    let sphere = Sphere(fromColor: color)
                    sphere.position = SCNVector3(x: Float(i) * bet - offset, y: Float(Float(j) * bet - offset), z: Float(Float(k) * bet - offset))

                    gameScene.rootNode.addChildNode(sphere.geometryNode)
                    models.append(sphere)
                }
            }
        }

        motionController.changeMotion(models: models, motionType: .Cube)
    }

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        cameraDelegate.didEnterFrame(models: models)
        motionDelegate.didEnterFrame(models: models)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

}
