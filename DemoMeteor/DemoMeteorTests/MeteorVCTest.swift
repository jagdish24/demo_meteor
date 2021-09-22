//
//  MeteorVCTest.swift
//  DemoMeteorTests
//
//  Created by Jagdish on 22/09/21.
//

import XCTest
@testable import DemoMeteor

class MeteorVCTest: XCTestCase {
    
    override class func setUp() {
        super.setUp()
        
        
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    //MARK: - Meteor VC Test
    func testTitle() {
        let sut = makeSUT()
        sut.viewDidLoad()
        XCTAssertEqual(sut.lblTitle.text, "Meteor", "Title equal test")
    }
    
    func test_meteorlist() {
        let sut = makeSUT()
        sut.addTableData()
        XCTAssertNotNil(sut.meteorList)
    }
    
    func test_meteor_table_configure() {
        let sut = makeSUT()
        XCTAssertNotNil(sut.meteorList.tblList.delegate)
        XCTAssertNotNil(sut.meteorList.tblList.dataSource)
    }
    
    func makeSUT() -> MeteorVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sut = storyboard.instantiateViewController(identifier: "MeteorVC") as! MeteorVC
        sut.loadViewIfNeeded()
        return sut
    }
}
