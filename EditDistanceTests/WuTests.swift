//
//  WuTests.swift
//  EditDistance
//
//  Copyright (c) 2017 Kazuhiro Hayashi
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import XCTest
@testable import EditDistance

class WuTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testTwoSameArray() {
        let container = Wu().calculate(from: [["a", "b", "c"]], to: [["a", "b", "c"]])
        let expected: [EditScript<String>] = [
            .common(element: "a", indexPath: IndexPath(row: 0, section: 0)),
            .common(element: "b", indexPath: IndexPath(row: 1, section: 0)),
            .common(element: "c", indexPath: IndexPath(row: 2, section: 0))
        ]
        XCTAssertEqual(container.editScripts, expected, "correct output")
    }

    func testTwoDifferentArray() {
        do {
            let container = Wu().calculate(from: [["a", "b", "c"]], to: [["a", "d", "c"]])
            let expected: [EditScript<String>] = [
                .common(element: "a", indexPath: IndexPath(row: 0, section: 0)),
                .delete(element: "b", indexPath: IndexPath(row: 1, section: 0)),
                .add(element: "d", indexPath: IndexPath(row: 1, section: 0)),
                .common(element: "c", indexPath: IndexPath(row: 2, section: 0))
            ]
            XCTAssertEqual(container.editScripts, expected, "correct output")
        }
        
        do {
            let container = Wu().calculate(from: [["a", "b", "e"]], to: [["a", "d", "f"]])
            let expected: [EditScript<String>] = [
                .common(element: "a", indexPath: IndexPath(row: 0, section: 0)),
                .delete(element: "b", indexPath: IndexPath(row: 1, section: 0)),
                .delete(element: "e", indexPath: IndexPath(row: 2, section: 0)),
                .add(element: "d", indexPath: IndexPath(row: 1, section: 0)),
                .add(element: "f", indexPath: IndexPath(row: 2, section: 0)),
            ]
            XCTAssertEqual(container.editScripts, expected, "correct output")
        }
    }
    
    func testDestinationIsLonger() {
        do {
            let container = Wu().calculate(from: [["a", "b", "c"]], to: [["a", "b", "c", "d"]])
            let expected: [EditScript<String>] = [
                .common(element: "a", indexPath: IndexPath(row: 0, section: 0)),
                .common(element: "b", indexPath: IndexPath(row: 1, section: 0)),
                .common(element: "c", indexPath: IndexPath(row: 2, section: 0)),
                .add(element: "d", indexPath: IndexPath(row: 3, section: 0)),
                ]
            XCTAssertEqual(container.editScripts, expected, "correct output")
        }
        
        do {
            let container = Wu().calculate(from: [["a", "b", "c"]], to: [["a", "b", "d", "e"]])
            let expected: [EditScript<String>] = [
                .common(element: "a", indexPath: IndexPath(row: 0, section: 0)),
                .common(element: "b", indexPath: IndexPath(row: 1, section: 0)),
                .add(element: "d", indexPath: IndexPath(row: 2, section: 0)),
                .add(element: "e", indexPath: IndexPath(row: 3, section: 0)),
                .delete(element: "c", indexPath: IndexPath(row: 2, section: 0)),
                ]
            XCTAssertEqual(container.editScripts, expected, "correct output")
        }
    }
    
    
    func testStartingIsLonger() {
        do {
            let container = Wu().calculate(from: [["a", "b", "c", "d"]], to: [["a", "b", "c"]])
            let expected: [EditScript<String>] = [
                .common(element: "a", indexPath: IndexPath(row: 0, section: 0)),
                .common(element: "b", indexPath: IndexPath(row: 1, section: 0)),
                .common(element: "c", indexPath: IndexPath(row: 2, section: 0)),
                .delete(element: "d", indexPath: IndexPath(row: 3, section: 0)),
                ]
            XCTAssertEqual(container.editScripts, expected, "correct output")
        }
        
        do {
            let container = Wu().calculate(from: [["a", "b", "d", "e"]], to: [["a", "b", "c"]])
            let expected: [EditScript<String>] = [
                .common(element: "a", indexPath: IndexPath(row: 0, section: 0)),
                .common(element: "b", indexPath: IndexPath(row: 1, section: 0)),
                .delete(element: "d", indexPath: IndexPath(row: 2, section: 0)),
                .delete(element: "e", indexPath: IndexPath(row: 3, section: 0)),
                .add(element: "c", indexPath: IndexPath(row: 2, section: 0)),
                ]
            XCTAssertEqual(container.editScripts, expected, "correct output")
        }
    }
    
    //MARK:- Performance Test
    
    // from: 100 items, to: 120 items (add 20)
    func testPerformanceOf20ItemsAddedToBottomOf100Items() {
        let from = Array(repeating: UUID().uuidString, count: 100)
        let to = from + Array(repeating: UUID().uuidString, count: 20)
        
        self.measure {
            let _ = Wu().calculate(from: [from], to: [to])
        }
    }
    
    // from: 100 items, to: 200 items (add 100)
    func testPerformanceOf100ItemsAddedToBottomOf100Items() {
        let from = Array(repeating: UUID().uuidString, count: 100)
        let to = from + Array(repeating: UUID().uuidString, count: 100)
        
        self.measure {
            let _ = Wu().calculate(from: [from], to: [to])
        }
    }
    
    // from: 100 items, to: 120 items (add 10 and delete 10)
    func testPerformanceOf20ItemsAddeAndDeleteOf100Items() {
        let from = Array(repeating: UUID().uuidString, count: 100)
        var to = from
        to.removeSubrange(10..<20)
        to.insert(contentsOf: Array(repeating: UUID().uuidString, count: 10), at: 40)

        self.measure {
            let _ = Wu().calculate(from: [from], to: [to])
        }
    }
    
    // from: 100 items, to: 150 items (add 50 and delete 50)
    func testPerformanceOf100ItemsAddeAndDeleteOf100Items() {
        let from = Array(repeating: UUID().uuidString, count: 100)
        var to = from
        to.removeSubrange(50..<100)
        to.insert(contentsOf: Array(repeating: UUID().uuidString, count: 10), at: 50)
        
        self.measure {
            let _ = Wu().calculate(from: [from], to: [to])
        }
    }

    // from: 1000 items, to: 1050 items (add 50)
    func testPerformanceOf50ItemsAddTo1000Items() {
        let from = Array(repeating: UUID().uuidString, count: 1000)
        let to = from + Array(repeating: UUID().uuidString, count: 50)
        
        self.measure {
            let _ = Wu().calculate(from: [from], to: [to])
        }
    }

    // from: 1000 items, to: 1200 items (add 200)
    func testPerformanceOf200ItemsAddIn1000Items() {
        let from = Array(repeating: UUID().uuidString, count: 1000)
        let to = from + Array(repeating: UUID().uuidString, count: 200)
        
        self.measure {
            let _ = Wu().calculate(from: [from], to: [to])
        }
    }
    
    // from: 1000 items, to: 1000 items (add 25 and delete 25)
    func testPerformanceOf50ItemsAddAndDeleteTo1000Items() {
        let from = Array(repeating: UUID().uuidString, count: 1000)
        var to = from
        to.removeSubrange(50..<75)
        to.insert(contentsOf: Array(repeating: UUID().uuidString, count: 25), at: 75)
        
        self.measure {
            let _ = Wu().calculate(from: [from], to: [to])
        }
    }
    
    // from: 1000 items, to: 1000 items (add 100 and delete 100)
    func testPerformanceOf200ItemsAddAndDeleteTo1000Items() {
        let from = Array(repeating: UUID().uuidString, count: 1000)
        var to = from
        to.removeSubrange(500..<600)
        to.insert(contentsOf: Array(repeating: UUID().uuidString, count: 100), at: 900)
        
        self.measure {
            let _ = Wu().calculate(from: [from], to: [to])
        }
    }
    
    // from: 10000 items, to: 10100 items (add 100)
    func testPerformanceOf100ItemsAddIn10000Items() {
        let from = Array(repeating: UUID().uuidString, count: 10000)
        let to = from + Array(repeating: UUID().uuidString, count: 100)
        
        self.measure {
            let _ = Wu().calculate(from: [from], to: [to])
        }
    }
    
    // from: 10000 items, to: 10100 items (add 50 and delete 50)
    func testPerformanceOf50ItemsAddAnd50ItemsDeleteIn10000Items() {
        let from = Array(repeating: UUID().uuidString, count: 10000)
        var to = from
        to.removeSubrange(1000..<1050)
        to.insert(contentsOf: Array(repeating: UUID().uuidString, count: 50), at: 9950)
        
        self.measure {
            let _ = Wu().calculate(from: [from], to: [to])
        }
    }
    
    // from: 10000 items, to: 11000 items (add 2000)
    func testPerformanceOf2000ItemsAddIn10000Items() {
        let from = Array(repeating: UUID().uuidString, count: 10000)
        let to = from + Array(repeating: UUID().uuidString, count: 2000)
        
        self.measure {
            let _ = Wu().calculate(from: [from], to: [to])
        }
    }
    
    // from: 10000 items, to: 11000 items (add 1000 and delete 1000)
    func testPerformanceOf2000ItemsAddAndDeleteIn10000Items() {
        let from = Array(repeating: UUID().uuidString, count: 10000)
        var to = from
        to.removeSubrange(1000..<2000)
        to.insert(contentsOf: Array(repeating: UUID().uuidString, count: 50), at: 9000)
        
        self.measure {
            let _ = Wu().calculate(from: [from], to: [to])
        }
    }
}
