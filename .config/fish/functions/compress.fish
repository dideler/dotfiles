function compress -d "Compress a variety of image types"
  pngquant --skip-if-larger --speed=1 **/*.png --ext .png --force
  find . -name '*.jpg' -type f -print | xargs -I@ jpegtran -copy none -optimize -outfile @ @
end
