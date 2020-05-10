Pod::Spec.new do |s|
    
    # 1
    s.platforms = { :ios => "11.0", :osx => "10.14", :watchos => "5.0", :tvos => "10.0" }
    s.name = "AdvancedLogger"
    s.summary = "AdvancedLogger swift 5.1 framework for advanced logging event in your app."
    s.requires_arc = true
    
    # 2
    s.version = "1.0.0"
    
    # 3
    s.license = { :type => "MIT", :file => "LICENSE" }
    
    # 4 - Replace with your name and e-mail address
    s.author = { "Dmitriy Toropkin" => "toropkind@gmail.com" }
    
    # 5 - Replace this URL with your own Github page's URL (from the address bar)
    s.homepage = "https://github.com/ESKARIA/AdvancedLogger.git"
    
    # 6 - Replace this URL with your own Git URL from "Quick Setup"
    s.source = { :git => "https://github.com/ESKARIA/AdvancedLogger.git", :tag => "#{s.version}"}
    
    # 7
    s.framework = "Foundation"
    s.dependency 'ESCrypto', '~> 1.0.0'
    
    # 8
    s.source_files = "AdvancedLogger/**/*.{swift}"
    
    # 9
    s.resources = "AdvancedLogger/**/*.{png,jpeg,jpg,storyboard,xib}"
   
end
