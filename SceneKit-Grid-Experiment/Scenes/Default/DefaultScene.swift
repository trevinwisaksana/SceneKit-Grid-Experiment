//
//  DefaultScene.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 25/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

public class DefaultScene: SCNScene, DefaultSceneViewModel {
    
    // MARK: - Internal Properties
    
    private static let gridWidth: Int = 20
    private static let gridTileWidth: CGFloat = 1
    
    // MARK: - Public Properties
    
    public var nodeSelected: SCNNode?
    public var lastNodeSelected: SCNNode?
    public var didSelectTargetNode: Bool = false
    public var isGridDisplayed: Bool = true
    
    public var cameraNode: SCNNode = {
        let node = SCNNode(geometry: nil)
        return node
    }()
    
    public var floorNode: SCNNode = {
        let node = SCNNode(geometry: nil)
        node.name = "floorNode"
        node.changeColor(to: .gray)
        return node
    }()
    
    public var backgroundColor: UIColor {
        return background.contents as! UIColor
    }
    
    public lazy var floorColor: UIColor? = .gray
    
    // MARK: - Setup
    
    override public init() {
        super.init()

        setup()
    }
    
    private func setup() {
        createGrid()
        
        background.contents = UIColor.gray
    }
    
    private func setupCamera() {
        cameraNode.camera = SCNCamera()
        rootNode.addChildNode(cameraNode)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Node Insertion
    
    func insertBox() {
        let box = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
        let boxNode = SCNNode(geometry: box)
        boxNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        boxNode.position = SCNVector3(10, 10, 0.5)
        boxNode.name = "boxNode"
        
        rootNode.addChildNode(boxNode)
    }
    
    func insertPyramid() {
        let pyramid = SCNPyramid(width: 1, height: 1, length: 1)
        let pyramidNode = SCNNode(geometry: pyramid)
        pyramidNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        pyramidNode.position = SCNVector3(10, 10, 0.5)
        // TODO: Change the name
        pyramidNode.name = "pyramidNode"
        
        rootNode.addChildNode(pyramidNode)
    }
    
    // MARK: - Grid
    
    public func createGrid() {
        for xIndex in 0...DefaultScene.gridWidth {
            for yIndex in 0...DefaultScene.gridWidth {
                let tileGeometry = SCNPlane(width: DefaultScene.gridTileWidth, height: DefaultScene.gridTileWidth)
                let tileNode = SCNNode(geometry: tileGeometry)
                tileNode.geometry?.firstMaterial?.diffuse.contents = UIColor.clear

                tileNode.position.x = Float(xIndex)
                tileNode.position.y = Float(yIndex)
                
                createBorder(for: tileNode)

                rootNode.addChildNode(tileNode)
            }
        }
    }
    
    public func hideGrid() {
        if !isGridDisplayed {
            return
        }
        
        floorNode.enumerateChildNodes { (node, stop) in
            node.isHidden = true
        }
        
        isGridDisplayed = false
    }
    
    // TODO: Fix issue where we cannot unhide grid
    public func showGrid() {
        if isGridDisplayed {
            return
        }
        
        floorNode.enumerateChildNodes { (node, stop) in
            node.isHidden = false
        }
        
        isGridDisplayed = true
    }
    
    private func createBorder(for node: SCNNode?) {
        guard let node = node else {
            return
        }
        
        let (min, max) = node.boundingBox
        let zCoord = node.position.z
        let topLeft = SCNVector3(min.x, max.y, zCoord)
        let bottomLeft = SCNVector3(min.x, min.y, zCoord)
        let topRight = SCNVector3(max.x, max.y, zCoord)
        let bottomRight = SCNVector3(max.x, min.y, zCoord)
        
        let bottomSide = createLineNode(fromPos: bottomLeft, toPos: bottomRight, color: .yellow)
        let leftSide = createLineNode(fromPos: bottomLeft, toPos: topLeft, color: .yellow)
        let rightSide = createLineNode(fromPos: bottomRight, toPos: topRight, color: .yellow)
        let topSide = createLineNode(fromPos: topLeft, toPos: topRight, color: .yellow)
        
        [bottomSide, leftSide, rightSide, topSide].forEach {
            node.addChildNode($0)
        }
    }
    
    private func createLineNode(fromPos origin: SCNVector3, toPos destination: SCNVector3, color: UIColor) -> SCNNode {
        let line = lineFrom(vector: origin, toVector: destination)

        let lineNode = SCNNode(geometry: line)
        lineNode.geometry?.firstMaterial?.diffuse.contents = color

        return lineNode
    }

    private func lineFrom(vector vector1: SCNVector3, toVector vector2: SCNVector3) -> SCNGeometry {
        let indices: [Int32] = [0, 1]

        let source = SCNGeometrySource(vertices: [vector1, vector2])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)

        return SCNGeometry(sources: [source], elements: [element])
    }
    
    // MARK: - Node Movement
    
    public func move(nodeSelected: SCNNode, in sceneView: SCNView) {
        if didSelectTargetNode {
            let nodeXPos = nodeSelected.position.x
            let nodeYPos = nodeSelected.position.y
            var nodeZPos = nodeSelected.position.z
            
            if nodeZPos >= 0.5 {
                nodeZPos = 0
            }
            
            if lastNodeSelected?.isMovable ?? false {
                lastNodeSelected?.position = SCNVector3(nodeXPos, nodeYPos, nodeZPos + 0.5)
                sceneView.allowsCameraControl = false
            }
        }
    }
    
    // MARK: - Node Selection
    
    public func didSelectNode(_ node: SCNNode?) {
        if node == nil || node?.name == nil {
            nodeSelected = nil
            State.nodeSelected = nil
            unhighlight(lastNodeSelected)
            return
        }
        
        nodeSelected = node
        lastNodeSelected = nodeSelected
        State.nodeSelected = nodeSelected
        
        highlight(nodeSelected)
        didSelectTargetNode = true
    }
    
    // MARK: - Node Color
    
    public func modifyNode(color: UIColor) {
        guard let name = nodeSelected?.name else {
            return
        }
        
        let node = rootNode.childNode(withName: name, recursively: true)
        node?.changeColor(to: color)
    }
    
    // MARK: - Scene Actions
    
    public func didSelectScene(action: String) {
        switch action {
        case Action.cut.capitalized:
            nodeSelected?.copy()
            nodeSelected?.removeFromParentNode()
        case Action.copy.capitalized:
            nodeSelected?.copy()
        case Action.paste.capitalized:
            break
        case Action.delete.capitalized:
            nodeSelected?.removeFromParentNode()
        case Action.move.capitalized:
            nodeSelected?.isMovable = true
//            showGrid()
        case Action.pin.capitalized:
            nodeSelected?.isMovable = false
            didSelectTargetNode = false
//            hideGrid()
        default:
            break
        }
    }
    
    // TODO: Move the node manipulation code elsewhere
    // TODO: Find solution that doesn't only work with boxes
    private func highlight(_ nodeSelected: SCNNode?) {
        guard let node = nodeSelected else {
            return
        }
    
        if node.isHighlighted {
            return
        }

        // TODO: Make the dimensions the same with the node selected
        let box = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)

        let nodeHighlight = SCNNode(geometry: box)
        nodeHighlight.geometry?.firstMaterial?.diffuse.contents = UIImage(named: .boxWireframe)
        nodeHighlight.geometry?.firstMaterial?.lightingModel = SCNMaterial.LightingModel.constant
        nodeHighlight.name = "nodeHighlight"

        node.addChildNode(nodeHighlight)

        node.isHighlighted = true
    }

    private func unhighlight(_ lastNodeSelected: SCNNode?) {
        guard let node = lastNodeSelected else {
            return
        }
        
        if !node.isHighlighted {
            return
        }
        
        node.isHighlighted = false

        let nodeHighlight = node.childNode(withName: "nodeHighlight", recursively: true)
        nodeHighlight?.removeFromParentNode()
    }

}