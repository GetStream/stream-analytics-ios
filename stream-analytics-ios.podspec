Pod::Spec.new do |s|

  s.name         = "stream-analytics-ios"
  s.version      = "0.0.3"
  s.summary      = "stream-analytics-ios"

  s.description  = <<-DESC
                   iOS SDK for Stream.
                   Build scalable newsfeeds & activity streams in a few hours instead of weeks
                   DESC

  s.homepage     = "https://github.com/GetStream/stream-analytics-ios"
  s.license      = {:type => 'MIT', :file => 'LICENSE' }
  s.author             = { "Stream" => "support@getstream.io" }
  s.social_media_url   = "https://twitter.com/getstream_io"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/GetStream/stream-analytics-ios.git", :tag => "0.0.3" }


  s.source_files  = "StreamAnalytics/**/*.{h,m}"
  # s.public_header_files = "StreamAnalytics/*.h"
  s.exclude_files = "StreamAnalyticsTests/**"
  s.requires_arc = true
  s.framework = 'XCTest', 'Foundation'

end
