//
//  RemoteBaseTest.swift
//  retrofire
//
//  Created by Rachid Calazans on 09/07/17.
//  Copyright © 2017 Stant. All rights reserved.
//

import Quick
import Nimble
@testable import Retrofire

class RemoteBaseTest: QuickSpec {
    override func spec() {
        let remoteBaseImpl = RemoteBaseImpl()
        
        describe("Access the api for a result a Single Object") {
            
            context("When has a existent object to find") {
                
                it("Should return a single response object") {
                    var response: ResponseObject?
                    remoteBaseImpl.findPost(id: 1)
                        .onSuccess() { responseObject in
                            response = responseObject
                        }
                        .call()
                    
                    expect(response?.id).toEventually(equal(1))
 
                }
            }
        }
        
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
                    expect(responses![0].id).toEventually(equal(1))
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
                    expect(responses![0].id).toEventually(equal(6))

                }
            }
            
        }
        
        describe("Creating a new Object") {
            
            context("When pass valid params") {
                
                it("Should return a saved Object") {
                    var response: ResponseObject?
                    remoteBaseImpl.createPost(userId: 1, title: "Some Title", body: "Some Body")
                        .onSuccess() { (responseObject) in
                            response = responseObject
                        }
                        .call()
                    
                    expect(response?.userId).toEventually(equal(1))
                    expect(response?.title).toEventually(equal("Some Title"))
                    expect(response?.body).toEventually(equal("Some Body"))
                }
            }
            
        }
        
        describe("Updating an Object") {
            
            context("When pass valid params") {
                
                it("Should return a saved Object") {
                    var response: ResponseObject?
                    remoteBaseImpl.updatePost(id: 1, userId: 1, title: "Some Title", body: "Some Body")
                        .onSuccess() { (responseObject) in
                            response = responseObject
                        }
                        .call()
                    
                    expect(response?.userId).toEventually(equal(1))
                    expect(response?.title).toEventually(equal("Some Title"))
                    expect(response?.body).toEventually(equal("Some Body"))
                }
            }
            
            context("When pass invalid id to update") {
                it("Should return a ErrorResponse Object") {
                    var response: ErrorResponse?
                    remoteBaseImpl.updatePost(id: 102292, userId: 123123, title: "Some Title", body: "Some Body")
                        .onFailed() { (error) in
                            response = error as? ErrorResponse
                        }
                        .call()
                    
                    expect(response?.statusCode).toEventually(equal(404))
                    expect(response?.url).toEventually(equal("http://jsonplaceholder.typicode.com/posts/102292"))
                    expect(response?.detailMessage).toEventually(equal(""))
                }
            }
            
        }
        
        describe("Deleting an Object") {
            
            context("When pass an existent id") {
                
                it("Should delete successfully") {
                    var response: Bool = false
                    remoteBaseImpl
                        .deletePost(id: 1)
                        .onSuccess() { (responseObject) in
                            response = true
                        }
                        .call()
                    
                    expect(response).toEventually(equal(true))
                }
            }
        }
        
    }
}

/**
 Class implementation of RemoteBase to use for tests
 */
class RemoteBaseImpl: RemoteBase {
    
    func posts() -> Call<[ResponseObject]> {
        let path = "https://jsonplaceholder.typicode.com/posts"
        let request = RequestBuilder(path: path).build()
        return self.callList(request: request)
    }
    
    func postComments(postId: Int) -> Call<[ResponseObject]> {
        let path = "http://jsonplaceholder.typicode.com/comments"
        let request = RequestBuilder(path: path)
            .queryParameters(["postId": postId.description])
            .build()
        return self.callList(request: request)
    }
    
    func postsComments(postId: Int, email: String) -> Call<[ResponseObject]> {
        let path = "http://jsonplaceholder.typicode.com/comments"
        let request = RequestBuilder(path: path)
            .queryParameters(["postId": postId.description, "email": email])
            .build()
        return self.callList(request: request)
    }
    
    func findPost(id: Int) -> Call<ResponseObject> {
        let path = "http://jsonplaceholder.typicode.com/posts/\(id)/"
        let request = RequestBuilder(path: path)
            .build()
        return self.callSingle(request: request)
    }
    
    func createPost(userId: Int, title: String, body: String) -> Call<ResponseObject> {
        let path = "http://jsonplaceholder.typicode.com/posts"
        let request = RequestBuilder(path: path)
            .method(.post)
            .bodyParameters(["userId": userId, "title": title, "body": body])
            .build()
        return self.callSingle(request: request)
    }
    
    func updatePost(id: Int, userId: Int, title: String, body: String) -> Call<ResponseObject> {
        let path = "http://jsonplaceholder.typicode.com/posts/\(id)"
        let request = RequestBuilder(path: path)
            .method(.put)
            .bodyParameters(["userId": userId, "title": title, "body": body])
            .build()
        return self.callSingle(request: request)
    }
    
    func deletePost(id: Int) -> Call<Default> {
        let path = "http://jsonplaceholder.typicode.com/posts/\(id)"
        let request = RequestBuilder(path: path)
            .method(.delete)
            .build()
        return self.callSingle(request: request)
    }
    
}

/**
 Class to use as Response on tests
 */
import SwiftyJSON

struct ResponseObject: Retrofire.Mappable {
    let userId: Int?
    let id: Int?
    let title: String?
    let body: String?
    
    static func instanceBy<M>(json: JSON) -> M {
        let userId = json.dictionary?["userId"]?.int
        let id     = json.dictionary?["id"]?.int
        let title  = json.dictionary?["title"]?.string
        let body   = json.dictionary?["body"]?.string
        
        return ResponseObject.init(userId: userId, id: id, title: title, body: body) as! M
    }
}
