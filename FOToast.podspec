Pod::Spec.new do |s|

s.name         = "FOToast"
s.version      = "0.2.0"
s.summary      = "Toast used by Figure 1"
s.homepage     = "https://github.com/DanielKrofchick/FOToast.git"
s.license      = { :type => 'MIT', :text => <<-LICENSE
LICENSE
}
s.author       = { "Daniel Krofchick" => "krofchick@gmail.com" }
s.ios.deployment_target = '8.0'
s.source       = {
:git => "https://github.com/DanielKrofchick/FOToast.git",
:tag => "0.1.0"
}
s.source_files = 'FOToast/Classes/**/*'

# s.resource_bundles = {
#   'FOToast' => ['FOToast/Assets/*.png']
# }

# s.public_header_files = 'Pod/Classes/**/*.h'

end
