//
//  main.swift
//  Store
//
//  Created by Ted Neward on 2/29/24.
//

import Foundation

protocol SKU {
    var name: String { get }
    func price() -> Int
}

class Item: SKU {
    var name: String
    var itemPrice: Int
    init(name: String, priceEach: Int){
        self.name = name
        self.itemPrice = priceEach
    }
    func price() -> Int {
        return itemPrice
    }
}

//When a Register is created, have it create a Receipt on which to capture all the items scanned
class Receipt {
    var list: [SKU]
    var coupons: [Coupon] = []
    init(list: [SKU] = [], coupons: [Coupon] = []) {
        self.list = list
        self.coupons = coupons
    }
    func items() -> [SKU] {
        return list
    }
    func output() -> String{
        //print out all of the items stored on the Receipt
        var result = "Receipt:\n"
        var usedCoupons: Set<String> = []
        for item in list {
            var price = item.price()
            for coupon in coupons {
                if !usedCoupons.contains(coupon.itemName) && item.name == coupon.itemName {
                    price = Int(Double(price) * (1.0 - coupon.discount))
                    usedCoupons.insert(coupon.itemName)
                    break
                }
            }
            result += "\(item.name): \(String(format: "$%.2f", Double(price) / 100.0))\n"
        }
        result += "------------------\n"
        result += "TOTAL: \(String(format: "$%.2f", Double(total()) / 100.0))"
        return result
    }
    func total() -> Int {
        var total = 0
        var usedCoupons: Set<String> = []
        for item in list {
            var price = item.price()
            for coupon in coupons {
                if !usedCoupons.contains(coupon.itemName) && item.name == coupon.itemName {
                    price = Int(Double(price) * (1.0 - coupon.discount))
                    usedCoupons.insert(coupon.itemName)
                }
            }
            total += price
        }
        return total
    }
}

class Register {
    var receipt: Receipt
    init(){
        self.receipt = Receipt()
    }
    func scan(_ item: SKU){
        receipt.list.append(item)
    }
    func subtotal() -> Int {
        var subtotal = 0
        for item in receipt.list {
            subtotal += item.price()
        }
        return subtotal
    }
    func total() -> Receipt {
        let result = receipt
        receipt = Receipt(list: [])
        return result
    }
}
class Coupon {
    let itemName: String
    let discount: Double
        
    init(itemName: String, discount: Double = 0.15) {
        self.itemName = itemName
        self.discount = discount
    }
}
class Store {
    let version = "0.1"
    func helloWorld() -> String {
        return "Hello world"
    }
}
