//
//  EditDistanceTests.swift
//  EditDistanceTests
//
//  Created by Kazuhiro Hayashi on 2/18/17.
//  Copyright © 2017 Kazuhiro Hayashi. All rights reserved.
//

import XCTest
@testable import EditDistance

class EditDistanceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCallingAlgorithmToOneDimentionalArrays() {
        let algorithm = AnyEditDistanceAlgorithm { (from, to) -> EditDistanceContainer<String> in
            let fromExpected = [["a", "b", "c"]]
            let toExpected = [["d", "e", "f"]]
            
            XCTAssertEqual(from.count, fromExpected.count, "starting one dimentional array becomes two dimentional array")
            XCTAssertEqual(to.count, toExpected.count, "destination one dimentional array becomes two dimentional array")
            
            XCTAssertEqual(from.first!, fromExpected.first!, "starting is expected array")
            XCTAssertEqual(to.first!, toExpected.first!, "destinationis expected array")
            
            return EditDistanceContainer(editScripts: [.add(element: "a", indexPath: IndexPath(row: 0, section: 0))])
        }

        let _ = EditDistance(from: ["a", "b", "c"], to: ["d", "e", "f"]).calculate(with: algorithm)
    }
    
    func testCallingAlgorithmToTwoDimentionalArrays() {
        let algorithm = AnyEditDistanceAlgorithm { (from, to) -> EditDistanceContainer<String> in
            let fromExpected = [["a", "b", "c"]]
            let toExpected = [["d", "e", "f"]]
            
            XCTAssertEqual(from.count, fromExpected.count, "starting array is two dimentional array")
            XCTAssertEqual(to.count, toExpected.count, "destination array is two dimentional array")
            
            XCTAssertEqual(from.first!, fromExpected.first!, "starting is expected array")
            XCTAssertEqual(to.first!, toExpected.first!, "destinationis expected array")
            
            return EditDistanceContainer(editScripts: [.add(element: "a", indexPath: IndexPath(row: 0, section: 0))])
        }
        
        let _ = EditDistance(from: [["a", "b", "c"]], to: [["d", "e", "f"]]).calculate(with: algorithm)
    }
    
    func testOutputEditDistanceContainer() {
        let algorithm = AnyEditDistanceAlgorithm { (from, to) -> EditDistanceContainer<String> in
            let scripts: [EditScript<String>] = [
                .common(element: "a", indexPath: IndexPath(row: 0, section: 0)),
                .delete(element: "b", indexPath: IndexPath(row: 1, section: 0)),
                .add(element: "d", indexPath: IndexPath(row: 1, section: 0)),
                .common(element: "c", indexPath: IndexPath(row: 2, section: 0))
            ]
            
            return EditDistanceContainer(editScripts: scripts)
        }
        
        let expected: [EditScript<String>] = [
            .common(element: "a", indexPath: IndexPath(row: 0, section: 0)),
            .delete(element: "b", indexPath: IndexPath(row: 1, section: 0)),
            .add(element: "d", indexPath: IndexPath(row: 1, section: 0)),
            .common(element: "c", indexPath: IndexPath(row: 2, section: 0))
        ]
        
        let container = EditDistance(from: [["a", "b", "c"]], to: [["a", "d", "c"]]).calculate(with: algorithm)
        XCTAssertEqual(expected, container.editScripts, "container is a correct output from EditDistance")
    }
}
