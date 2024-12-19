# Specs
Custom pod specs repository for mirror sdks &amp; private usage.

## Step1. Add Repo to your git repo list
```
$ pod repo add mine_specs git@github.com:MichaelLedger/Specs.git
Cloning spec repo `mine_specs` from `git@github.com:MichaelLedger/Specs.git`

$ pod repo list

master
- Type: git (remotes/origin/master)
- URL:  https://github.com/CocoaPods/Specs.git
- Path: /Users/gavinxiang/.cocoapods/repos/master

mine_specs
- Type: git (main)
- URL:  git@github.com:MichaelLedger/Specs.git
- Path: /Users/gavinxiang/.cocoapods/repos/mine_specs

trunk
- Type: CDN
- URL:  https://cdn.cocoapods.org/
- Path: /Users/gavinxiang/.cocoapods/repos/trunk

3 repos
```

## Step2. Modify Repo Remote URL(skip this step if repo is public && ssh is correct.)

```
$ pwd
/Users/gavinxiang/.ssh

$ ls
config           github-rsa       github-rsa-2     github-rsa-2.pub github-rsa.pub   known_hosts

$ cat config
# github
Host github.com
HostName github.com
PreferredAuthentications publickey
IdentityFile ~/.ssh/github-rsa

Host github2.com
HostName github.com
PreferredAuthentications publickey
IdentityFile ~/.ssh/github-rsa-2
```

Modify git remote url host to using another ssh account to push specs.
```
$ cd /Users/gavinxiang/.cocoapods/repos/mine_specs

$ git remote -v
origin    git@github.com:MichaelLedger/Specs.git (fetch)
origin    git@github.com:MichaelLedger/Specs.git (push)

$ git remote set-url origin git@github2.com:MichaelLedger/Specs.git

$ git remote -v
origin    git@github2.com:MichaelLedger/Specs.git (fetch)
origin    git@github2.com:MichaelLedger/Specs.git (push)
```

## Step3. pod repo push `.podspec`
```
$ pwd   
/Users/gavinxiang/Downloads/YYModel

$ pod repo push mine_specs 'YYModel.podspec' --sources='git@github.com:MichaelLedger/Specs.git' --allow-warnings --skip-import-validation --skip-tests

Validating spec
 -> YYModel (1.0.6)
    - NOTE  | xcodebuild:  note: Using codesigning identity override: -
    - NOTE  | xcodebuild:  note: Building targets in dependency order
    - NOTE  | xcodebuild:  note: Target dependency graph (1 target)
    - WARN  | xcodebuild:  YYModel/YYModel/NSObject+YYModel.m:247:41: warning: a function declaration without a prototype is deprecated in all versions of C [-Wstrict-prototypes]
    - WARN  | xcodebuild:  YYModel/YYModel/NSObject+YYModel.m:272:56: warning: a function declaration without a prototype is deprecated in all versions of C [-Wstrict-prototypes]
    - WARN  | xcodebuild:  YYModel/YYModel/NSObject+YYModel.m:1065:49: warning: a block declaration without a prototype is deprecated  [-Wstrict-prototypes]
    - WARN  | xcodebuild:  YYModel/YYModel/NSObject+YYModel.m:1065:111: warning: a block declaration without a prototype is deprecated  [-Wstrict-prototypes]
    - WARN  | xcodebuild:  YYModel/YYModel/NSObject+YYModel.m:1067:49: warning: a block declaration without a prototype is deprecated  [-Wstrict-prototypes]
    - WARN  | xcodebuild:  YYModel/YYModel/NSObject+YYModel.m:1067:111: warning: a block declaration without a prototype is deprecated  [-Wstrict-prototypes]
    - NOTE  | xcodebuild:  note: Disabling previews because SWIFT_VERSION is set and SWIFT_OPTIMIZATION_LEVEL=-O, expected -Onone (in target 'YYModel' from project 'Pods')
    - NOTE  | xcodebuild:  note: Using codesigning identity override: 

Updating the `mine_specs' repo


Adding the spec to the `mine_specs' repo

 - [No change] YYModel (1.0.6)

Pushing the `mine_specs' repo
```

## Step4. add source to `Podfile`

```
# Podfile
source 'https://github.com/CocoaPods/Specs.git'
source 'git@github.com:MichaelLedger/Specs.git'

platform :ios, '15.0'

# ignore all warnings from all pods
inhibit_all_warnings!

ensure_bundler! '~> 2.5.0'

use_frameworks!

def ucd_pods
    pod 'SDWebImageSVGCoder',                '~> 1.7.0'
    pod 'JXSegmentedView',                   '~> 1.3.0'
    pod 'JXPagingView/Paging',               '~> 2.l.2'
end

def mine_pods
    pod 'YYModel',  '~> 1.0.6'
end

target 'XXX' do
  ucd_pods
  mine_pods
end

# Name | NSExtensionPointIdentifier
# NotificationExtension | com.apple.usernotifications.service
# NotificationContentExtension | com.apple.usernotifications.content-extension
target 'XXXNotificationContentExtension' do
  pod 'Appboy-Push-Story',                '~> 4.7.0'
end

pre_install do |installer|
  # localization: we only support english
  # delete (yes, filesystem delete!) any unwanted localization files that were
  # included with the pods
  supported_locales = ['base', 'en']
  Dir.glob(File.join(installer.sandbox.pod_dir('*'), '**', '*.lproj')).each do |bundle|
    if (!supported_locales.include?(File.basename(bundle, ".lproj").downcase))
      puts "Pod includes unsupported localization: #{File.basename(bundle)}"
      puts "Removing #{bundle}"
      puts " "
      FileUtils.rm_rf(bundle)
    end
  end
end

post_install do |installer|
  add_build_configurations(installer.pods_project)
  installer.pods_project.targets.each do |target|
    add_build_configurations(target)
  end
  installer.aggregate_targets.each do |target|
    target.xcconfigs.each do |variant, xcconfig|
      xcconfig_path = target.client_root + target.xcconfig_relative_path(variant)
      IO.write(xcconfig_path, IO.read(xcconfig_path).gsub("DT_TOOLCHAIN_DIR", "TOOLCHAIN_DIR"))
    end
  end
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.base_configuration_reference.is_a? Xcodeproj::Project::Object::PBXFileReference
        xcconfig_path = config.base_configuration_reference.real_path
        IO.write(xcconfig_path, IO.read(xcconfig_path).gsub("DT_TOOLCHAIN_DIR", "TOOLCHAIN_DIR"))
      end
    end
  end
end

post_integrate do |installer|
  workspace_path = 'XXX.xcworkspace'
  workspace = Xcodeproj::Workspace.new_from_xcworkspace(workspace_path)
  workspace.file_references.each do |file_reference|
    project = Xcodeproj::Project.open(file_reference.path)
    add_build_configurations(project)
    project.save()
  end
end


# Add "build configurations"
def add_build_configurations(project)
  project.build_configurations.each do |config|
    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    config.build_settings["DEVELOPMENT_TEAM"] = "XXX4XXXXXX3"
    if config.name == 'Debug'
      config.build_settings['SWIFT_ACTIVE_COMPILATION_CONDITIONS'] = 'DEBUG SKIP_XX_BUILD'
    elsif config.name == 'TestFlight'
      config.build_settings['SWIFT_ACTIVE_COMPILATION_CONDITIONS'] = 'TESTFLIGHT SKIP_XX_BUILD'
    elsif config.name == 'Release'
      config.build_settings['SWIFT_ACTIVE_COMPILATION_CONDITIONS'] = 'RELEASE SKIP_XX_BUILD'
    end
  end
end
```

## Step5. Pod install
```
$ pod install --verbose

-> Installing YYModel (1.0.6)
 > Git download
 > Git download
     $ /usr/bin/git clone https://github.com/MichaelLedger/YYModel.git
     /var/folders/wk/frkkcch539lc6s2dk6dw9dy80000gn/T/d20241219-2751-i9h8eu --template= --single-branch --depth 1
     --branch 1.0.6
     Cloning into '/var/folders/wk/frkkcch539lc6s2dk6dw9dy80000gn/T/d20241219-2751-i9h8eu'...
     Note: switching to 'd928780e6d3f53467b9e38758eaf8f15a499fd11'.
     
  > Copying YYModel from `/Users/gavinxiang/Library/Caches/CocoaPods/Pods/Release/YYModel/1.0.6-ad2ab` to
  `Pods/YYModel`
```

## Step6. Open `XXX.xcworkspace` with Xcode.
That's all! 🎉🎉🎉🍺🍺🍺

## Tips
