#import "AwsAnalyticsPlugin.h"
#if __has_include(<aws_analytics/aws_analytics-Swift.h>)
#import <aws_analytics/aws_analytics-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "aws_analytics-Swift.h"
#endif

@implementation AwsAnalyticsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAwsAnalyticsPlugin registerWithRegistrar:registrar];
}
@end
