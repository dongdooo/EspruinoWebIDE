#/bin/bash

# Extract icons from http://modernuiicons.com/ into an directory called 'svg'
# needs imagemagick to be installed

cd `dirname $0`
Y=0
CSSFILE=../css/icons.css
ICONFILE=../img/icons.png
cp icons/icons.css $CSSFILE
echo "/* auto-generated by extras/make_icons.sh */"  >> $CSSFILE

# Old icon - add to css
function o {
  ID=$2
  echo .icon-${ID}.lrg:before { background-position: 0 -${Y}px } >> $CSSFILE
  echo .compact .icon-${ID}.lrg:before, >> $CSSFILE
  echo .icon-${ID}.sml:before { background-position: -60px -${Y}px } >> $CSSFILE
  echo >> $CSSFILE
  Y=$((Y+60))
}

# New Icon - add to image
function i {
  # add CSS
  o $1 $2
  # add image
  IMG=$1.svg
  ID=$2
  TEMPIMG=tmp$ID.png
  if [ ! -f $IMG ]; then
    echo "File $IMG not found"
    exit 1
  fi

  convert $IMG -resize 60x60\! a.png
  convert $IMG -resize 30x30\! b.png
convert a.png b.png +append -negate -alpha copy -channel RGB -level 100,100 $TEMPIMG

#  convert a.png b.png +append -negate -fuzz 100% -transparent black $TEMPIMG
  rm a.png b.png
  IMAGES="$IMAGES $TEMPIMG"
} 

# list of OLD icons (in order)
# We do this because old icons looked good, and recreating
# the image from SVG causes icons to be all different sizes :(
o svg/appbar.close cross
o svg/appbar.app window
o svg/appbar.minus minus 
o svg/appbar.add plus
o svg/appbar.chevron.left back
o svg/appbar.chevron.right forward
o svg/appbar.chevron.down down
o svg/appbar.chevron.up up
o svg/appbar.settings settings
o svg/appbar.warning alert
o svg/appbar.connect connect
o svg/appbar.disconnect disconnect
o icons/window.vert split-vertical
o icons/window.horiz split-horizontal
o svg/appbar.folder folder
o svg/appbar.folder.open folder-open
o svg/appbar.save save
o icons/deploy deploy
o svg/appbar.code.xml code
o svg/appbar.clear.inverse clear
o svg/appbar.eye eye
o svg/appbar.webcam webcam
o svg/appbar.puzzle block
o svg/appbar.delete bin
o svg/appbar.star star
o svg/appbar.heart heart
o svg/appbar.lightning lightning
o svg/appbar.check tick
o svg/appbar.cloud cloud
o svg/appbar.usb usb
o svg/appbar.book.perspective.help help
o icons/compass compass
o svg/appbar.refresh refresh
o svg/appbar.cell.align snippets

# list of NEW icons (in order)
IMAGES=
i svg/appbar.control.play debug-go
i svg/appbar.control.stop debug-stop
i svg/appbar.debug.step.into debug-into
i svg/appbar.debug.step.out debug-out
i svg/appbar.debug.step.over debug-over

# Now put them all together into one file
convert icons/oldicons.png $IMAGES -append $ICONFILE
rm $IMAGES
