//
//  AppDelegate+Resolving.swift
//  Dialog Social Coffee
//
//  Created by Craig Mathieson on 2020-05-18.
//  Copyright © 2020 Craig Mathieson. All rights reserved.
//

import Foundation
import Resolver

// Essentially we are creating an instance of LocalRecipeRepository and injecting it anywhere a RecipeRepository instance exists.
// We can register as many Repositories we want if there are other data sets we also want to use!

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        register { LocalRecipeRepository() as RecipeRepository }.scope(application)
    }
}
