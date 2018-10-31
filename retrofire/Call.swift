//
//  Call.swift
//  retrofire
//
//  Created by Rachid Calazans on 09/07/17.
//  Copyright © 2017 Stant. All rights reserved.
//

/// Responsible to manage the successes and failures closures pass
///
public class Call<ResultObject> {
    /// Closure responsible to configure the calls for :success or :failed methods.
    private let callback: (Call<ResultObject>) -> Void

    /// Closure responsible to keep the success block until be called on :callback closure on :call method
    private var resultSuccessCallback: ((ResultObject?) -> Void)?

    /// Closure responsible to keep the failure block until be called on :callback closure on :call method
    private var resultFailureCallback: ((Any?) -> Void)?

    init(_ callback: @escaping (Call<ResultObject>) -> Void) {
        self.callback = callback
    }

    /// Execute the closure :callback attribute passing current instance of Call
    ///
    /// That function will run the first block passed through the constructor. That clouser will know witch function :success or :failed will execute.
    public func call() {
        callback(self)
    }

    /// Keep the parameter :resultCallback in the :resultSuccessCallback attribute and return self.
    ///
    /// - parameter resultCallback: Closure to be called when :call method is called and is success
    public func onSuccess(_ resultCallback: @escaping (ResultObject?) -> Void) -> Call<ResultObject> {
        self.resultSuccessCallback = resultCallback
        return self
    }

    /// Keep the parameter :resultCallback in the :resultFailureCallback attribute and return self.
    ///
    /// - parameter resultCallback: Closure to be called when :call method is called and is fail
    public func onFailed(_ resultCallback: @escaping (Any?) -> Void) -> Call<ResultObject> {
        self.resultFailureCallback = resultCallback
        return self
    }

    /// MARK: Functions called just inside the :callback closure

    public func success(result: ResultObject?) {
        self.resultSuccessCallback!(result)
    }

    public func failed(error: Any? = nil) {
        self.resultFailureCallback!(error)
    }

}
