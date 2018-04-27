
# Retired :(
Since Xcode 8+ doesn't support xcode plugins, this plugin no longer useful.

# JKBlockCommenter
Xcode plugin to comment selected code segment with `/*...*/` by pressing `⌘⌥/` keys together
## How to install
You can install either by following methods
* Download or clone this repository and build it in Xcode. You'll need to restart Xcode after the installation.
* Download the release, unzip it and copy the `JKBlockCommenter.xcplugin` file to `~/Library/Application Support/Developer/Shared/Xcode/Plug-ins`
* Install via [Alcatraz](http://alcatraz.io)

##How to use
* Select code segment to be commented
* Press `⌘`, `⌥` and `/` keys together or  From `Edit` menu select `Comment Selection With /* ... */`
* See the screenshot

![Sreenshot](Demo.gif)
##TO DO
* Move the menu to `Editor` > `Structure`
* Change text of menu to `Uncomment Selection` if selected segment is commented code
* Hide or disable menu if active area is not textview(if its like xib,storyboard,plist etc)

##Author
* [Johnykutty Mathew](mailto:johnykutty.mathew@gmail.com)
