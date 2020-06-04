A proof-of-concept OSX Dock alternative or completentary utility written in Swift


![sshot](sshot.png)


### What

- small panel with open application icons
- positioned at the bottom of the screen just like Dock (I suggest to autohide the Dock or to move it to a side)
- always on top (above other windows)
- visible on all spaces
- only lists window of the current space

### Usage

- click on an window icon:
  - brings the window to front (not the application)
  - if window is frontmost and visible then hides it
- option+click: hides all other windows

Note: hiding a window currently means moving it "offscreen" because osx has no concept of 'hidden window'. It can minimize them but the minimize-animation is super-slow.

### next ?

Not sure
- automatically shrink the dock width when there are fewer icons, or figure out a different layout
- I would like to simulate groups of hidden/show windows as if they were different spaces you can switch to
- I would like to create a cmd+tab alternative that is window based (and only shows the windows of the current space)

--

Feel free to try this, make suggestions, submit pull requests.

