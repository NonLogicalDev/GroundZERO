FOLDER_NAME='@Folder'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Sort list view by kind in ascending order (Windows style)
# /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:ExtendedListViewSettings:sortColumn kind" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:ExtendedListViewSettings:columns:4:ascending true" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:ListViewSettings:sortColumn kind" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:ListViewSettings:columns:kind:ascending true" ~/Library/Preferences/com.apple.finder.plist

# Sort Folders before files hack (Windows style)
FILE=/System/Library/CoreServices/Finder.app/Contents/Resources/English.lproj/InfoPlist.strings

# Backup InfoPlist.strings first if no backup exists
[ -f $FILE.bak ] || ditto $FILE $FILE.bak

# Convert InfoPlist.strings to XML
plutil -convert xml1 $FILE

# Add a space in front of 'Folder' string
sed -i '' "s/g\\>Folder/g\\>$FOLDER_NAME/" $FILE > /dev/null

# Convert InfoPlist.strings back to binary
plutil -convert binary1 $FILE

# Restart cfprefsd and Finder
killAll cfprefsd
killAll Finder
