//
//  StoreTests.swift
//  StoreTests
//
//  Created by Ted Neward on 2/29/24.
//

import XCTest

final class StoreTests: XCTestCase {

    var register = Register()

    override func setUpWithError() throws {
        register = Register()
    }

    override func tearDownWithError() throws { }

    func testBaseline() throws {
        XCTAssertEqual("0.1", Store().version)
        XCTAssertEqual("Hello world", Store().helloWorld())
    }
    
    func testOneItem() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(199, receipt.total())

        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
------------------
TOTAL: $1.99
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    func testThreeSameItems() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199 * 3, register.subtotal())
    }
    
    func testThreeDifferentItems() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199, register.subtotal())
        register.scan(Item(name: "Pencil", priceEach: 99))
        XCTAssertEqual(298, register.subtotal())
        register.scan(Item(name: "Granols Bars (Box, 8ct)", priceEach: 499))
        XCTAssertEqual(797, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(797, receipt.total())

        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
Pencil: $0.99
Granols Bars (Box, 8ct): $4.99
------------------
TOTAL: $7.97
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    var register2 = Register()
    //Create a unit test that tests adding a single Item to the Register and displays its subtotal (which should be the single Item's price).
    func testSingleItem() {
        register2.scan(Item(name: "Oranges", priceEach: 299))
        XCTAssertEqual(299, register2.subtotal())
    }
    //test adding 2 items, then check the subtotal, then another item and the total
    func test3ItemsSubtotals() {
        register2.scan(Item(name: "Oranges", priceEach: 299))
        register2.scan(Item(name: "Eggs", priceEach: 4999))
        XCTAssertEqual(5298, register2.subtotal())
        register2.scan(Item(name: "Cheese", priceEach: 99))
        let receipt = register2.total()
        let expectedReceipt = """
Receipt:
Oranges: $2.99
Eggs: $49.99
Cheese: $0.99
------------------
TOTAL: $53.97
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    //test adding two of the same item
    func testTwoOfTheSameItem() {
        register2.scan(Item(name: "Oranges", priceEach: 299))
        register2.scan(Item(name: "Oranges", priceEach: 299))
        XCTAssertEqual(598, register2.subtotal())
    }
    //call total twice in a row
    func test2Total() {
        register2.scan(Item(name: "Oranges", priceEach: 299))
        _ = register2.total()
        let secondReceipt = register2.total()
        XCTAssertEqual(0, secondReceipt.total())
    }
    //price is negative
    func testNegative(){
        register2.scan(Item(name: "Oranges", priceEach: -299))
        XCTAssertEqual(-299, register2.subtotal())
    }
    func testEmptyReceipt() {
        let expectedReceipt = """
Receipt:
------------------
TOTAL: $0.00
"""
        XCTAssertEqual(register2.receipt.output(), expectedReceipt)
    }
    //coupon tests
    func testCoupon(){
        register2.scan(Item(name: "Beans", priceEach: 300))
        register2.scan(Item(name: "Beans", priceEach: 300))
        register2.receipt.coupons.append(Coupon(itemName: "Beans"))
        let r = register2.total()
        XCTAssertEqual(555, r.total())
    }
    
    func testCouponOutput(){
        register2.scan(Item(name: "Beans", priceEach: 300))
        register2.scan(Item(name: "Beans", priceEach: 300))
        register2.receipt.coupons.append(Coupon(itemName: "Beans"))
        let receipt = register2.total()
        let expectedReceipt = """
Receipt:
Beans: $2.55
Beans: $3.00
------------------
TOTAL: $5.55
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    func testTwoCouponsOutput(){
        register2.scan(Item(name: "Beans", priceEach: 300))
        register2.scan(Item(name: "Beans", priceEach: 300))
        register2.scan(Item(name: "Milk", priceEach: 200))
        register2.scan(Item(name: "Milk", priceEach: 200))

        register2.receipt.coupons.append(Coupon(itemName: "Beans"))
        register2.receipt.coupons.append(Coupon(itemName: "Milk"))
        
        let expectedReceipt = """
Receipt:
Beans: $2.55
Beans: $3.00
Milk: $1.70
Milk: $2.00
------------------
TOTAL: $9.25
"""

        XCTAssertEqual(expectedReceipt, register2.receipt.output())
    }
    
    func testCouponAppliesOnce(){
        register2.scan(Item(name: "Beans", priceEach: 300))
        register2.scan(Item(name: "Beans", priceEach: 300))
        register2.scan(Item(name: "Beans", priceEach: 300))
        register2.receipt.coupons.append(Coupon(itemName: "Beans"))
        let receipt = register2.total()
        let expectedReceipt = """
Receipt:
Beans: $2.55
Beans: $3.00
Beans: $3.00
------------------
TOTAL: $8.55
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    func testCouponForNonexistentItem() {
        register2.scan(Item(name: "Milk", priceEach: 200))
        register2.receipt.coupons.append(Coupon(itemName: "Cheese"))
        
        let expectedReceipt = """
Receipt:
Milk: $2.00
------------------
TOTAL: $2.00
"""
        XCTAssertEqual(expectedReceipt, register2.receipt.output())
    }
}
