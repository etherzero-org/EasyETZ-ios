//
//  Functions.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2017-06-18.
//  Copyright © 2017 breadwallet LLC. All rights reserved.
//

import UIKit

/// Executes the callback on the given queue when the device becomes unlocked, or immediately if protected data is already available
func guardProtected(queue: DispatchQueue, callback: @escaping () -> Void) {
    if UIApplication.shared.isProtectedDataAvailable {
        queue.async {
            callback()
        }
    } else {
        var observer: Any?
        observer = NotificationCenter.default.addObserver(forName: .UIApplicationProtectedDataDidBecomeAvailable, object: nil, queue: nil) { note in
            queue.async {
                callback()
            }
            if let observer = observer {
                NotificationCenter.default.removeObserver(observer)
            }
        }
    }
}

func strongify<Context: AnyObject>(_ context: Context, closure: @escaping(Context) -> Void) -> () -> Void {
    return { [weak context] in
        guard let strongContext = context else { return }
        closure(strongContext)
    }
}

func strongify<Context: AnyObject, Arguments>(_ context: Context?, closure: @escaping (Context, Arguments) -> Void) -> (Arguments) -> Void {
    return { [weak context] arguments in
        guard let strongContext = context else { return }
        closure(strongContext, arguments)
    }
}
