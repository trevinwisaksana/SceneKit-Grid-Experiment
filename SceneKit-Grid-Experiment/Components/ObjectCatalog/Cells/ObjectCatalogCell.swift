//
//  ObjectCatalogCell.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 23/06/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

public class ObjectCatalogCell: UICollectionViewCell {
    
    // MARK: - Internal Properties
    
    private var objectSceneView: SCNView = {
        let sceneView = SCNView(frame: .zero)
        sceneView.antialiasingMode = .none
        sceneView.stop(self)
        return sceneView
    }()
    
    private var nodeModel: NodeModel?
    
    // MARK: - Setup
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addSubview(objectSceneView)
        objectSceneView.fillInSuperview()
    }
    
    // MARK: - Dependency injection
    
    /// The model contains data used to populate the view.
    public var model: ObjectCatalogViewModel? {
        didSet {
            if let model = model {
                objectSceneView.prepare([model.objectModelScene], completionHandler: { (success) in
                    if success {
                        DispatchQueue.main.async {
                            self.objectSceneView.scene = model.objectModelScene
                        }
                    }
                })
                
                nodeModel = model.nodeModel
            }
        }
    }
    
}
