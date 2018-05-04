//
//  UpdateObjectActionTest.swift
//  Retrofire
//
//  Created by Stant 02 on 04/05/18.
//  Copyright © 2018 Stant. All rights reserved.
//

import Quick
import Nimble
@testable import Retrofire

class UpdateObjectActionTest: QuickSpec {
    
    override func spec() {
        
        let remoteBaseImpl = RemoteBaseImpl()
        var id             = Int()
        var userId         = Int()
        var response: ResponseObject?
        var errorResponse: ErrorResponse?
        
        describe("Updating an Object") {
            
            let updatePostAction: Action = Action() {
                remoteBaseImpl.updatePost(id: id, userId: userId, title: "Some Title", body: "Some Body")
                    .onSuccess() { (responseObject) in
                        response = responseObject
                    }
                    .onFailed() { (error) in
                        errorResponse = error as? ErrorResponse
                    }
                    .call()
            }
            
            context("When pass valid params") {
                
                beforeEach {
                    execute(action: updatePostAction) {
                        id     = 1
                        userId = 1
                    }
                }
                
                it("Should return a saved Object") {
                    expect(response?.userId).toEventually(equal(1))                    
                    expect(response?.title).toEventually(equal("Some Title"))
                    expect(response?.body).toEventually(equal("Some Body"))
                }
            }
            
            context("When pass invalid id to update") {
                
                beforeEach {
                    execute(action: updatePostAction) {
                        id     = 102292
                        userId = 123123
                    }
                }
                
                it("Should return a ErrorResponse Object") {
                    expect(errorResponse?.statusCode).toEventually(equal(404))
                    expect(errorResponse?.url).toEventually(equal("http://jsonplaceholder.typicode.com/posts/102292"))
                    expect(errorResponse?.detailMessage).toEventually(equal("{\n}"))
                }
            }
            
        }
    }
}


