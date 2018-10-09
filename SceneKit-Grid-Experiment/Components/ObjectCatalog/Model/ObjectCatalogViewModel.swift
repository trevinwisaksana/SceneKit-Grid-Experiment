//
//  ObjectCatalogViewModel.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 26/09/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import SceneKit

public protocol ObjectCatalogViewModel {
    var objectModelScene: SCNScene { get set }
    var nodeModel: NodeModel { get set }
}