//
//  CreateObjectActionTest.swift
//  Retrofire
//
//  Created by Stant 02 on 04/05/18.
//  Copyright © 2018 Stant. All rights reserved.
//

import Quick
import Nimble
@testable import Retrofire

class CreateObjectActionTest: QuickSpec {
    
    override func spec() {
        
        let remoteBaseImpl = RemoteBaseImpl()
        var response: ResponseObject?
        
        describe("Creating a new Object") {
            
            context("When pass valid params") {
                
                beforeEach {
                    remoteBaseImpl.createPost(userId: 1, title: "Some Title", body: "Some Body")
                        .onSuccess() { (responseObject) in
                            response = responseObject
                        }
                        .call()
                }
                
                it("Should return a saved Object") {
                    expect(response?.userId).toEventually(equal(1))
                    expect(response?.title).toEventually(equal("Some Title"))
                    expect(response?.body).toEventually(equal("Some Body"))
                }
            }
        }        
    }
}
