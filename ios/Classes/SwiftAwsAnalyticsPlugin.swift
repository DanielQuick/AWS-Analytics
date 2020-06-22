import Flutter
import UIKit
import Amplify
import AmplifyPlugins

public class SwiftAwsAnalyticsPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    do {
        try Amplify.add(plugin: AWSCognitoAuthPlugin())
        try Amplify.add(plugin: AWSPinpointAnalyticsPlugin())
        try Amplify.configure()
        print("Amplify configured with Auth and Analytics plugins")
    } catch {
        print("Failed to initialize Amplify with \(error)")
    }

    let channel = FlutterMethodChannel(name: "aws_analytics", binaryMessenger: registrar.messenger())
    let instance = SwiftAwsAnalyticsPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch (call.method) {
      case "registerGlobalProperties":
        registerGlobalProperties(properties: call.arguments as! Dictionary<String,Any>, result: result)
        break
      case "unregisterGlobalProperties":
        unregisterGlobalProperties(properties: (call.arguments as? Array<String>), result: result)
        break
      case "record":
        let arguments = call.arguments as! Dictionary<String,Any>
        record(eventName: (arguments["event"] as! String), properties: (arguments["properties"] as! Dictionary<String,Any>), result: result)
        break
      default: result(FlutterMethodNotImplemented)
    }
  }

  func registerGlobalProperties(properties: Dictionary<String,Any>, result: FlutterResult) {
    var globalProperties: AnalyticsProperties = [:]
    for (key, value) in properties {
      globalProperties[key] = value.AnalyticsPropertyValue
    }
    Amplify.Analytics.registerGlobalProperties(globalProperties)
    result(true)
  }

  func unregisterGlobalProperties(properties: Array<String>?, result: FlutterResult) {
    if let properties = properties {
      let objectSet = Set(properties.map { $0 })
      Amplify.Analytics.unregisterGlobalProperties(objectSet)
    } else {
      Amplify.Analytics.unregisterGlobalProperties()
    }
    result(true)
  }

  func record(eventName: String, properties: Dictionary<String,Any>, result: FlutterResult) {
    var analyticsProperties: AnalyticsProperties = [:]
    for (key, value) in properties {
      analyticsProperties[key] = value.AnalyticsPropertyValue
    }
    let event = BasicAnalyticsEvent(name: eventName, properties: analyticsProperties)
    Amplify.Analytics.record(event: event)
    result(true)
  }
}
