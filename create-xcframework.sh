xcodebuild archive \
-project BarChartKit.xcodeproj \
-scheme BarChartKit-Package \
-configuration Release \
-destination "generic/platform=iOS" \
-archivePath "$PWD/archives/BarChartKit-iOS" \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
APPLICATION_EXTENSION_API_ONLY=YES

xcodebuild archive \
-project BarChartKit.xcodeproj \
-scheme BarChartKit-Package \
-configuration Release \
-destination "generic/platform=iOS Simulator" \
-archivePath "$PWD/archives/BarChartKit-iOS-Simulator" \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
APPLICATION_EXTENSION_API_ONLY=YES

xcodebuild archive \
-project BarChartKit.xcodeproj \
-scheme BarChartKit-Package \
-configuration Release \
-destination "generic/platform=watchOS" \
-archivePath "$PWD/archives/BarChartKit-watchOS" \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
APPLICATION_EXTENSION_API_ONLY=YES

xcodebuild archive \
-project BarChartKit.xcodeproj \
-scheme BarChartKit-Package \
-configuration Release \
-destination "generic/platform=watchOS Simulator" \
-archivePath "$PWD/archives/BarChartKit-watchOS-Simulator" \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
APPLICATION_EXTENSION_API_ONLY=YES

xcodebuild archive \
-project BarChartKit.xcodeproj \
-scheme BarChartKit-Package \
-configuration Release \
-destination "generic/platform=macOS" \
-archivePath "$PWD/archives/BarChartKit-macOS" \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
APPLICATION_EXTENSION_API_ONLY=YES

xcodebuild archive \
-project BarChartKit.xcodeproj \
-scheme BarChartKit-Package \
-configuration Release \
-destination 'generic/platform=macOS,variant=Mac Catalyst' \
-archivePath "$PWD/archives/BarChartKit-macCatalyst" \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
APPLICATION_EXTENSION_API_ONLY=YES \
SUPPORTS_MACCATALYST=YES

xcodebuild -create-xcframework \
-framework "$PWD/archives/BarChartKit-iOS.xcarchive/Products/Library/Frameworks/BarChartKit.framework" \
-debug-symbols "$PWD/archives/BarChartKit-iOS.xcarchive/dSYMs/BarChartKit.framework.dSYM" \
-framework "$PWD/archives/BarChartKit-iOS-Simulator.xcarchive/Products/Library/Frameworks/BarChartKit.framework" \
-debug-symbols "$PWD/archives/BarChartKit-iOS-Simulator.xcarchive/dSYMs/BarChartKit.framework.dSYM" \
-framework "$PWD/archives/BarChartKit-watchOS.xcarchive/Products/Library/Frameworks/BarChartKit.framework" \
-debug-symbols "$PWD/archives/BarChartKit-watchOS.xcarchive/dSYMs/BarChartKit.framework.dSYM" \
-framework "$PWD/archives/BarChartKit-watchOS-Simulator.xcarchive/Products/Library/Frameworks/BarChartKit.framework" \
-debug-symbols "$PWD/archives/BarChartKit-watchOS-Simulator.xcarchive/dSYMs/BarChartKit.framework.dSYM" \
-framework "$PWD/archives/BarChartKit-macOS.xcarchive/Products/Library/Frameworks/BarChartKit.framework" \
-debug-symbols "$PWD/archives/BarChartKit-macOS.xcarchive/dSYMs/BarChartKit.framework.dSYM" \
-framework "$PWD/archives/BarChartKit-macCatalyst.xcarchive/Products/Library/Frameworks/BarChartKit.framework" \
-debug-symbols "$PWD/archives/BarChartKit-macCatalyst.xcarchive/dSYMs/BarChartKit.framework.dSYM" \
-output artifacts/BarChartKit.xcframework
