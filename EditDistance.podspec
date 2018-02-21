#
# Be sure to run `pod lib lint StringStylizer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "EditDistance"
  s.version          = "0.8.1"
  s.summary          = "Incremental update tool to UITableView and UICollectionView"

  s.description      = <<-DESC
  This library pipelines the process to update UITableView and UICollectionView. It is so difficult to update them incrementally, because iOS app developers need to manage differences between the two DataSources.
                       DESC

  s.homepage         = "https://github.com/kazuhiro4949/EditDistance"
  s.license          = 'MIT'
  s.author           = { "Kazuhiro Hayashi" => "k.hayashi.info@gmail.com" }
  s.source           = { :git => "https://github.com/kazuhiro4949/EditDistance.git", :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = "EditDistance/*"
end
