xcodebuild archive \
-project BarChartKit.xcodeproj \
-scheme BarChartKit-Package \
-configuration Release \
-destination "generic/platform=iOS" \
-archivePath "archives/BarChartKit-iOS" \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
APPLICATION_EXTENSION_API_ONLY=YES

xcodebuild archive \
-project BarChartKit.xcodeproj \
-scheme BarChartKit-Package \
-configuration Release \
-destination "generic/platform=iOS Simulator" \
-archivePath "archives/BarChartKit-iOS-Simulator" \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
APPLICATION_EXTENSION_API_ONLY=YES

xcodebuild archive \
-project BarChartKit.xcodeproj \
-scheme BarChartKit-Package \
-configuration Release \
-destination "generic/platform=watchOS" \
-archivePath "archives/BarChartKit-watchOS" \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
APPLICATION_EXTENSION_API_ONLY=YES

xcodebuild archive \
-project BarChartKit.xcodeproj \
-scheme BarChartKit-Package \
-configuration Release \
-destination "generic/platform=watchOS Simulator" \
-archivePath "archives/BarChartKit-watchOS-Simulator" \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
APPLICATION_EXTENSION_API_ONLY=YES

xcodebuild archive \
-project BarChartKit.xcodeproj \
-scheme BarChartKit-Package \
-configuration Release \
-destination "generic/platform=macOS" \
-archivePath "archives/BarChartKit-macOS" \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
APPLICATION_EXTENSION_API_ONLY=YES

xcodebuild -create-xcframework \
-framework "archives/BarChartKit-iOS.xcarchive/Products/Library/Frameworks/BarChartKit.framework" \
-framework "archives/BarChartKit-iOS-Simulator.xcarchive/Products/Library/Frameworks/BarChartKit.framework" \
-framework "archives/BarChartKit-watchOS.xcarchive/Products/Library/Frameworks/BarChartKit.framework" \
-framework "archives/BarChartKit-watchOS-Simulator.xcarchive/Products/Library/Frameworks/BarChartKit.framework" \
-framework "archives/BarChartKit-macOS.xcarchive/Products/Library/Frameworks/BarChartKit.framework" \
-output artifacts/BarChartKit.xcframework
