# Uncomment the next line to define a global platform for your project
platform :ios, '8.0'

target 'PrefetchDemo' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!

  pod 'Masonry'
  pod 'UITableView+FDTemplateLayoutCell'
  pod 'SDWebImage'

  target 'PrefetchDemoTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'PrefetchDemoUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
post_install do |installer|
    installer.pods_project.targets.each do |target|
        fix_cocoapod_bug(target)
    end
end

def fix_cocoapod_bug(target)
  #log content
    resourcesPath = "Pods/Target Support Files/#{target.name}/#{target.name}-resources.sh"
    if File.exist?(resourcesPath)
        #File.write(resourcesPath, content, mode: 'a')
        text = File.read(resourcesPath)
        text = text.gsub(" && [ \"`xcrun --find actool`\" ]", "")
        text = text.gsub("xcrun actool", "/Applications/Xcode.app/Contents/Developer/usr/bin/actool")
        File.open(resourcesPath, "w") {|file| file.puts text }
    else
        puts "#{resourcesPath} not exist"
    end

    # modify frameworks.sh
checkThenCopyScript = <<-EOM
  local frameworkName
  frameworkName="$(basename -s .framework \"${source}\")"
  if [[ "${source}/${frameworkName}" -nt "${destination}/${frameworkName}.framework/${frameworkName}" ]]; then
    echo "\n=====================================${frameworkName} ====================================="
    hasSign="true"
  else
    echo -n
    return
  fi

  # use filter instead of exclude so missing patterns dont' throw errors
EOM
waitContent = <<-EOM
  if [[ "${hasSign}" == "true" ]]; then
    wait
  fi
EOM
    frameworksPath = "Pods/Target Support Files/#{target.name}/#{target.name}-frameworks.sh"
    if File.exist?(frameworksPath)
        text = File.read(frameworksPath)
        text = text.gsub("  # use filter instead of exclude so missing patterns dont' throw errors", checkThenCopyScript)
        text = text.gsub("  wait", waitContent)
        File.open(frameworksPath, "w") {|file| file.puts text }
    else
        puts "#{frameworksPath} not exist"
    end
end