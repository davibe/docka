# Uncomment the next line to define a global platform for your project
platform :osx, '10.15'

target 'Docka' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'Silica', { :git => 'https://github.com/ianyh/Silica', :submodules => true }
  pod 'StreamSwift', { :git => 'https://github.com/davibe/stream-swift', :branch => 'master' }

  # Pods for Docka

  target 'DockaTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'DockaUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
