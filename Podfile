source 'http://github.com/CocoaPods/Specs.git'
platform :ios, '11.0'

inhibit_all_warnings!
use_frameworks!

workspace 'Boilerplate.xcworkspace'

def main_pods
    pod 'RxSwift'
    pod 'RxCocoa'
end

def test_pods
    pod 'RxTest'
    pod 'RxBlocking'
    pod 'Nimble'
end

target :Boilerplate do
    project 'Boilerplate.xcodeproj', 'Debug' => :debug, 'Release' => :release
    main_pods
    target :Boilerplate_UnitTests do
        test_pods
    end
end

post_install do |installer|

    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '5.0'
        end
    end

end
