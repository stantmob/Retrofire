//
//  ListOfObjectsActionTest.swift
//  Retrofire
//
//  Created by Stant 02 on 04/05/18.
//  Copyright © 2018 Stant. All rights reserved.
//

import Quick
import Nimble
@testable import Retrofire

class ListOfObjectActionTest: QuickSpec {
    
    override func spec() {
        let remoteBaseImpl = RemoteBaseImpl()
        
        describe("Access the api for a result List of Objects") {
            
            context("When have any parameters and is a Get method") {
                
                it("Should return a valid list of response objects") {
                    var responses: [ResponseObject]?
                    remoteBaseImpl.posts()
                        .onSuccess() { responseObjects in
                            responses = responseObjects
                        }
                        .call()
                    
                    expect(responses?.count).toEventually(equal(100))
                    expect(responses!.first?.id).toEventually(equal(1))
                }
            }
            
            context("When have one query parameter and is a Get method") {
                
                it("Should return a valid list of response objects") {
                    var responses: [ResponseObject]?
                    remoteBaseImpl.postComments(postId: 1)
                        .onSuccess() { responseObjects in
                            responses = responseObjects
                        }
                        .call()
                    
                    expect(responses?.count).toEventually(equal(5))
                    expect(responses![0].id).toEventually(equal(1))
                    
                }
            }
            
            context("When have many query parameterers and is a Get method") {
                
                it("Should return a valid list of response objects") {
                    var responses: [ResponseObject]?
                    remoteBaseImpl.postsComments(postId: 2, email: "Presley.Mueller@myrl.com")
                        .onSuccess() { responseObjects in
                            responses = responseObjects
                        }
                        .call()
                    
                    expect(responses?.count).toEventually(equal(1))
                    expect(responses!.first?.id).toEventually(equal(6))
                    
                }
            }
            
        }
    }
}
