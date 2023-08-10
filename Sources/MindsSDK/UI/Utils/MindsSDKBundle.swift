import Foundation

final class MindsSDKBundle {
    static let resourceBundle: Bundle = {
        let myBundle = Bundle(for: MindsSDKBundle.self)

        guard let resourceBundleURL = myBundle.url(
            forResource: "MindsSDKResources", withExtension: "bundle")
            else { fatalError("MindsSDKResources.bundle not found!") }

        guard let resourceBundle = Bundle(url: resourceBundleURL)
            else { fatalError("Cannot access MindsSDKResources.bundle!") }

        return resourceBundle
    }()
}
