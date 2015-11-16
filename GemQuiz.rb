require 'tk'
require 'tkextlib/tile'

root = TkRoot.new {title "GemQuiz"}
#root.resizable(false, false)
root.minsize(width=640, height=480)
root['resizable'] = false, false

TkOption.add '*tearOff', 0


menubar = TkMenu.new(root)
root['menu'] = menubar

file = TkMenu.new(menubar)
edit = TkMenu.new(menubar)
menubar.add :cascade, :menu => file, :label => 'File'
menubar.add :cascade, :menu => edit, :label => 'Edit'

file.add :command, :label => 'New', :command => proc{newFile}
file.add :command, :label => 'Open...', :command => proc{openFile}
file.add :command, :label => 'Close', :command => proc{closeFile}

Tk::Tile::Style.configure('Correct.TLabel', {"font" => "helvetica 24", "foreground" => "green"})
Tk::Tile::Style.configure('InCorrect.TLabel', {"font" => "helvetica 24", "foreground" => "red"})

#Tk::Tile::Style.configure('TLabel', {"font" => "helvetica 24", "foreground" => "red"})
a = Tk::Tile::Label.new(root) {text 'abc'}.grid( :column => 2, :row => 2);
b = Tk::Tile::Label.new(root) {text 'def'}.grid( :column => 3, :row => 2, :sticky => 'w')
a['style'] = "Correct.TLabel"
b['style'] = "InCorrect.TLabel"


filename = Tk::getOpenFile
puts filename


Tk.mainloop

