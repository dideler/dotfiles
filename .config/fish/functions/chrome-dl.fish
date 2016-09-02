# Based on https://gist.github.com/paulirish/78d6c1406c901be02c2d

function chrome-dl --description "Download Chrome extensions, given their IDs"
  for extension_id in $argv
    curl --output "$extension_id.zip" \
         --location "https://clients2.google.com/service/update2/crx?response=redirect&os=mac&arch=x86-64&nacl_arch=x86-64&prod=chromecrx&prodchannel=stable&prodversion=44.0.2403.130&x=id%3D$extension_id%26uc"
    unzip -d "$extension_id-source" "$extension_id.zip"
    rm "$extension_id.zip"
  end
end
