//
//  ViewController.swift
//  ARKitDemo
//
//  Created by 开心粮票 on 2018/1/4.
//  Copyright © 2018年 eeee. All rights reserved.
//

import UIKit
import ARKit


class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!

    var randomColor: UIColor {
        get {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        sceneView.session.pause()
        addBox()
        addTapGestureToScenceView()
    }



    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        let configuration = ARWorldTrackingConfiguration()

        sceneView.session.run(configuration)

        
    }

    //MARK -
    func addBox(x: Float = 0, y:  Float = 0, z: Float = -0.2) {
        let box = SCNBox.init(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
         let boxNode = SCNNode()
        boxNode.geometry = box
        boxNode.position = SCNVector3(x,y,z)

        sceneView.scene.rootNode.addChildNode(boxNode)
        sceneView.autoenablesDefaultLighting = true
//      sceneView.allowsCameraControl = true
        box.firstMaterial?.diffuse.contents = self.randomColor

    }

    func addTapGestureToScenceView() {
        let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(ViewController.didTap(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func didTap(withGestureRecognizer recognizer: UIGestureRecognizer) {
         let tapLocation = recognizer.location(in: sceneView)
         let hitTestResults = sceneView.hitTest(tapLocation)
        guard let node = hitTestResults.first?.node else {
        let hitTestResultsWithFeaturePoints = sceneView.hitTest(tapLocation, types:         .featurePoint)

        if let hitTestResultWithFeaturePoints = hitTestResultsWithFeaturePoints.first {

            let translation = hitTestResultWithFeaturePoints.worldTransform.translation
            addBox(x: translation.x, y: translation.y, z: translation.z)
        }
        return }
        node.removeFromParentNode()
    }



}


extension float4x4 {

    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }

}
