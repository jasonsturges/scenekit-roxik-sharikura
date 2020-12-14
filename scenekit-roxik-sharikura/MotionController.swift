//
//  MotionController.swift
//  scenekit-roxik-sharikura
//
//  Created by Jason Sturges on 12/12/20.
//

import Foundation
import SceneKit

class MotionController {
    var cutoff: Int = 1
    var frameNumber: Int = 0
    var motionType: MotionType = MotionType.Cube
    var sceneLimit: Int = 100
    var r: Float!
    var r0: Float!
    var rp: Float!
    var rl: Float!

    func changeMotion(models: [Sphere], motionType: MotionType) {
        self.motionType = motionType
        sceneLimit = Int.random(in: 3...143)
        cutoff = 0
        frameNumber = 0

        switch motionType {
        case .Cylinder:
            cylinder(models: models)
        case .Tube:
            tube(models: models)
        case .Sphere:
            sphere(models: models)
        case .Cube:
            cube(models: models)
        case .Wave:
            wave(models: models)
        case .Gravity:
            gravity(models: models)
        case .Antigravity:
            antigravity(models: models)
        }
    }

    func cylinder(models: [Sphere]) {
        var n: Float = 0.0
        let r: Float = Float.pi * 2.0 / Float(models.count);
        let d: Float = Float.random(in: 1.0..<41.0) * r

        for (i, model) in models.enumerated() {
            model.speed = 0.0
            model.acceleration = Float.random(in: 0.022..<0.072)
            model.animate = false

            if (i < models.count - 50) {
                let a: Float = Float(models.count) - 50.0
                model.dest.x = cos(n) * 4.0;
                model.dest.y = Float(i) * 0.008 - a * 0.004;
                model.dest.z = sin(n) * 4.0;
            } else {
                model.dest.x = Float.random(in: -7.0..<7.0)
                model.dest.y = Float.random(in: -7.0..<7.0)
                model.dest.z = Float.random(in: -7.0..<7.0)
            }

            n += d;
        }
    }

    func cube(models: [Sphere]) {
        let a: Float = Float.random(in: 0.022...0.072)
        let n: Int = 0
        var l: Int = 1

        while (true) {
            if (l * l * l > models.count) {
                l -= 1
                break
            }

            l += 1
        }

        for i in 1...8 {
            for j in 1...8 {
                for k in 1...8 {
                    let model = models[n]
                    model.speed = 0
                    model.acceleration = a
                    model.animate = false
                    model.dest.x = Float(i) * 0.8 + -(Float(l - 1)) * 0.8 * 0.5
                    model.dest.y = Float(j) * 0.8 + -(Float(l - 1)) * 0.8 * 0.5
                    model.dest.z = Float(k) * 0.8 + -(Float(l - 1)) * 0.8 * 0.5
                }
            }
        }
    }

    func sphere(models: [Sphere]) {
        var s: Float = 0.0;
        var c: Float = 0.0
        let r: Float = Float.pi * 2 / Float(models.count)
        let d: Float = Float.random(in: 1.0..<40.0) * r
        let d2: Float = Float.random(in: 3...8)

        for (_, model) in models.enumerated() {
            model.speed = 0
            model.acceleration = Float.random(in: 0.022..<0.05)
            model.animate = false

            let d1: Float = cos(s) * d2

            if (Float.random(in: 0.0..<1.0) > 0.06) {
                model.dest.x = cos(c) * d1
                model.dest.y = sin(s) * d2
                model.dest.z = sin(c) * d1
            } else {
                model.dest.x = Float.random(in: -7.0..<0.0)
                model.dest.y = Float.random(in: -7.0..<0.0)
                model.dest.z = Float.random(in: -7.0..<0.0)
            }

            s += r
            c += d
        }
    }

    func wave(models: [Sphere]) {
        let a: Float = Float.random(in: 0.022...0.072)
        let l: Int = Int(floor(sqrt(Double(models.count))))
        let d: Float = -(Float(l) - 1.0) * 0.55 * 0.5
        let t: Float = Float.random(in: 0.05...0.35)
        let s: Float = Float.random(in: 1...2)
        var n: Int = 0
        r = 0
        r0 = 0
        rl = Float.random(in: 1...2)
        rp = Float.random(in: 0.1...0.4)

        for i in 0..<l {
            let ty: Float = cos(r) * s
            r += t

            for j in 0..<l {
                n += 1
                let model = models[n - 1]
                model.speed = 0
                model.acceleration = a
                model.animate = false
                model.dest.x = Float(i) * 0.55 + d
                model.dest.y = ty
                model.dest.z = Float(j) * 0.55 + d
                model.direction.x = 0.0
                model.direction.y = 0.0
                model.direction.z = 0.0
            }
        }

        while (n < models.count) {
            let model = models[n]
            model.speed = 0
            model.acceleration = a
            model.animate = false
            model.dest.x = Float.random(in: -7.0..<7.0)
            model.dest.y = Float.random(in: -7.0..<7.0)
            model.dest.z = Float.random(in: -7.0..<7.0)

            n += 1
        }
    }

    func gravity(models: [Sphere]) {
        sceneLimit = 60
        for (_, model) in models.enumerated() {
            model.speed = 0
            model.acceleration = 0.5
            model.animate = false
            model.direction.x = 0.0
            model.direction.y = Float.random(in: -0.2...0.8)
            model.direction.z = 0.0
        }
    }

    func antigravity(models: [Sphere]) {
        for (_, model) in models.enumerated() {
            model.speed = 0
            model.acceleration = 0.5
            model.animate = false
            model.direction.x = Float.random(in: -0.125...0.125)
            model.direction.y = Float.random(in: -0.125...0.125)
            model.direction.z = Float.random(in: -0.125...0.125)
        }
    }

    func tube(models: [Sphere]) {
        motionType = MotionType.Tube

        let a = Float.random(in: 0.022..<0.072)
        let v = Float.random(in: 0.02..<0.045)
        let dx = -v * Float(models.count) * 0.44
        let d = Float.random(in: 1.2..<2.2)

        for (i, model) in models.enumerated() {
            model.speed = 0.0
            model.acceleration = a
            model.animate = false

            if (Float.random(in: 0.0..<1.0) > 0.05) {
                model.dest.x = Float(i) * v + dx
                model.dest.y = Float.random(in: 0.0..<1.0) * d - d * 0.5
                model.dest.z = Float.random(in: 0.0..<1.0) * d - d * 0.5
            } else {
                model.dest.x = Float.random(in: -7.0..<7.0)
                model.dest.y = Float.random(in: -7.0..<7.0)
                model.dest.z = Float.random(in: -7.0..<7.0)
            }
        }
    }

    func update(models: [Sphere]) {
        var maxp: Int

        switch motionType {
        case .Cylinder:
            fallthrough
        case .Sphere:
            fallthrough
        case .Cube:
            fallthrough
        case .Tube:
            for i in 0..<cutoff {
                let model = models[i]

                if (!model.animate) {
                    if (model.speed < 0.8) {
                        model.speed += model.acceleration
                    }

                    let c0 = model.dest.x - model.position.x
                    let c1 = model.dest.y - model.position.y
                    let c2 = model.dest.z - model.position.z

                    model.position.x += c0 * model.speed
                    model.position.y += c1 * model.speed
                    model.position.z += c2 * model.speed

                    if (abs(c0) < 0.05 && abs(c1) < 0.05 && abs(c2) < 0.05) {
                        model.animate = true
                        model.position.x = model.dest.x
                        model.position.y = model.dest.y
                        model.position.z = model.dest.z
                    }
                }
            }

            maxp = Int(Double(models.count) / 40.0)
            cutoff += maxp

            if (cutoff > models.count) {
                cutoff = models.count
            }

        case .Gravity:
            for (_, model) in models.enumerated() {
                model.position.y += model.direction.y
                model.direction.y -= 0.06

                if (model.position.y < -9.0) {
                    model.position.y = -9.0
                    model.direction.y *= -model.acceleration
                    model.acceleration *= 0.9
                }
            }

        case .Antigravity:
            for i in 0..<cutoff {
                let model = models[i]

                model.position.x += model.direction.x
                model.position.y += model.direction.y
                model.position.z += model.direction.z
            }

            cutoff += 30
            if (cutoff > models.count) {
                cutoff = models.count
            }

        case .Wave:
            let max: Int = Int(floor(sqrt(Double(models.count))))
            var cc: Int = 0

            for _ in 0..<max {
                let c = cos(r) * rl
                r += rp
                
                for _ in 0..<max {
                    let model = models[cc]
                    model.dest.y = c
                    cc += 1
                }
            }

            r0 += 0.11
            r = r0

            for i in 0..<cutoff {
                let model = models[i]
                if (model.speed < 0.5) {
                    model.speed += model.acceleration
                }

                model.position.x += (model.dest.x - model.position.x) * model.speed
                model.position.y += (model.dest.y - model.position.y) * model.speed
                model.position.z += (model.dest.z - model.position.z) * model.speed
            }

            maxp = Int(Double(models.count) / 40.0)
            cutoff += maxp

            if (cutoff > models.count) {
                cutoff = models.count
            }

        default:
            print("none")
        }

        frameNumber += 1
        if (frameNumber > sceneLimit) {
            changeMotion(models: models, motionType: MotionType.allCases.randomElement()!)
        }
    }
}
