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

var showTerminal = slate.operation("focus", {
  'app': 'Terminal'
});
slate.bind("c:e,cmd", function(win) {
  win.doOperation(showTerminal);
});

var showVim = slate.operation("focus", {
  'app': 'MacVim'
});
slate.bind("m:e,cmd", function(win) {
  win.doOperation(showVim);
});

var grid = slate.operation("grid", {
  "grids" : { }
});
slate.bind("g:e,cmd", function(win) {
  win.doOperation(grid);
});

// quake keys
S.bnda({
  "d:e,cmd" : S.op("push", { "direction" : "right", "style" : "bar-resize:screenSizeX/2" }),
  "a:e,cmd" : S.op("push", { "direction" : "left", "style" : "bar-resize:screenSizeX/2" }),
  "w:e,cmd" : S.op("push", { "direction" : "up", "style" : "bar-resize:screenSizeY/2" }),
  "s:e,cmd" : S.op("push", { "direction" : "down", "style" : "bar-resize:screenSizeY/2" })
});
