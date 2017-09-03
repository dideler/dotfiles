function compress -d "Compress a variety of image types"
  pngquant --skip-if-larger --speed=1 --ext .png --force **.png
  find . -name '*.jpg' -type f -print | xargs -I@ jpegtran -copy none -optimize -outfile @ @
end
