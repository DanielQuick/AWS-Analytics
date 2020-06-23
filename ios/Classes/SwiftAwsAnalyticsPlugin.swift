import Flutter
import UIKit
import Amplify
import AmplifyPlugins

public class SwiftAwsAnalyticsPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "aws_analytics", binaryMessenger: registrar.messenger())
    let instance = SwiftAwsAnalyticsPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch (call.method) {
      case "initialize":
        initialize(result: result)
        break
      case "registerGlobalProperties":
        registerGlobalProperties(properties: (call.arguments as AnyObject as! AnalyticsProperties), result: result)
        break
      case "unregisterGlobalProperties":
        unregisterGlobalProperties(properties: (call.arguments as? Array<String>), result: result)
        break
      case "record":
        let arguments = call.arguments as! Dictionary<String,Any>
        record(eventName: (arguments["event"] as! String), properties: (arguments["properties"] as AnyObject as! AnalyticsProperties), result: result)
        break
      default: result(FlutterMethodNotImplemented)
    }
  }

  func initialize(result: FlutterResult) {
    do {
        try Amplify.add(plugin: AWSCognitoAuthPlugin())
        try Amplify.add(plugin: AWSPinpointAnalyticsPlugin())
        try Amplify.configure()
        print("Amplify configured with Auth and Analytics plugins")
        result(true)
    } catch {
        print("Failed to initialize Amplify with \(error)")
        result(false)
    }
  }

  func registerGlobalProperties(properties: AnalyticsProperties, result: FlutterResult) {
    Amplify.Analytics.registerGlobalProperties(properties)
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

  func record(eventName: String, properties: AnalyticsProperties, result: FlutterResult) {
    let event = BasicAnalyticsEvent(name: eventName, properties: properties)
    Amplify.Analytics.record(event: event)
    result(true)
  }
}
