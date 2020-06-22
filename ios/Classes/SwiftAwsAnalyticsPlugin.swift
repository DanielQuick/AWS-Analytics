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
        registerGlobalProperties(properties: call.arguments, result: result)
        break
      case "unregisterGlobalProperties":
        unregisterGlobalProperties(properties: call.arguments, result: result)
        break
      case "record":
        record(eventName: call.arguments["event"], properties: call.arguments["properties"], result: result)
        break
      default: result(FlutterMethodNotImplemented)
    }
  }

  func registerGlobalProperties(properties: Dictionary<String,Any>, result: FlutterResult) {
    let globalProperties: AnalyticsProperties = [:];
    for (key, value) in properties {
      globalProperties[key] = value
    }
    Amplify.Analytics.registerGlobalProperties(globalProperties)
    result(true)
  }

  func unregisterGlobalProperties(properties: Array<String>?, result: FlutterResult) {
    if let properties = properties {
      Amplify.Analytics.unregisterGlobalProperties(properties)
    } else {
      Amplify.Analytics.unregisterGlobalProperties()
    }
    result(true)
  }

  func record(eventName: String, properties: Dictionary<String,Any>, result: FlutterResult) {
     let analyticsProperties: AnalyticsProperties = [:];
    for (key, value) in properties {
      analyticsProperties[key] = value
    }
    let event = BasicAnalyticsEvent(name: eventName, properties: analyticsProperties)
    Amplify.Analytics.record(event: event)
    result(true)
  }
}
