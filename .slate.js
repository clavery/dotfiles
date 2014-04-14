var moveToRightWindow = slate.operation("throw", {
  "screen" : "right"
});
var moveToLeftWindow = slate.operation("throw", {
  "screen" : "left"
});
var fullscreen = slate.operation("move", {
  "x" : "screenOriginX",
  "y" : "screenOriginY",
  "width" : "screenSizeX",
  "height" : "screenSizeY"
});

slate.bind("left:e,cmd", function(win) {
  win.doOperation(moveToLeftWindow);
});
slate.bind("right:e,cmd", function(win) {
  win.doOperation(moveToRightWindow);
});
slate.bind("f:e,cmd", function(win) {
  win.doOperation(fullscreen);
});
