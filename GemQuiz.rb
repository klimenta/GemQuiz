########################################################
# a.grid_remove() - makes it not visible
# a.grid() - makes it visible again
# a.destroy - destroy the widget
########################################################
require 'tk'
require 'tkextlib/tile'

root = TkRoot.new {title "GemQuiz"}
frame = Tk::Tile::Frame.new(root)

root.resizable(false, false)
root.minsize(width=800, height=600)
root.maxsize(width=800, height=600)

TkOption.add '*tearOff', 0

menubar = TkMenu.new(root)
root['menu'] = menubar

file = TkMenu.new(menubar)
menubar.add :cascade, :menu => file, :label => 'File'

file.add :command, :label => 'Open...', :command => proc{openFile}
file.add :command, :label => 'Exit', :command => proc{exitProgram}

Tk::Tile::Style.configure('Question.TLabel', {"font" => "helvetica 14", "foreground" => "black"})
Tk::Tile::Style.configure('QuestionNumber.TLabel', {"font" => "helvetica 24", "foreground" => "red"})
Tk::Tile::Style.configure('Correct.TLabel', {"font" => "helvetica 14", "foreground" => "darkgreen"})
Tk::Tile::Style.configure('Answer.TLabel', {"font" => "helvetica 14", "foreground" => "blue"})

frame.grid :column => 2, :row => 0

$btnAnswer = Tk::Tile::Button.new(root) {text "Answer"; command {answerQuestion()}}
$btnPrev = Tk::Tile::Button.new(root) {text "< Prev"; command {prevQuestion()}}
$btnNext = Tk::Tile::Button.new(root) {text "Next >"; command {nextQuestion()}}
$btnFinish = Tk::Tile::Button.new(root) {text "Finish"; command {finishQuestion()}}

$questionNumberlabel  = Tk::Tile::Label.new(root) {text ""}.grid( :column => 1, :row => 0)
$questionNumberlabel['style'] = "QuestionNumber.TLabel"

$questionlbl = Tk::Tile::Label.new(frame) {text ""
wraplength 650
}.grid( :column => 0, :row => 0, :sticky => 'w' )
$questionlbl['style'] = "Question.TLabel"

$answerAlbl = Tk::Tile::Label.new(root) {
  text ""
  wraplength 650
}.grid( :column => 2, :row => 1, :sticky => 'w')
$answerAlbl['style'] = "Answer.TLabel"

$answerBlbl = Tk::Tile::Label.new(root) {
  text ""
  wraplength 650
}.grid( :column => 2, :row => 2, :sticky => 'w')
$answerBlbl['style'] = "Answer.TLabel"

$answerClbl = Tk::Tile::Label.new(root) {
  text ""
  wraplength 650
}.grid( :column => 2, :row => 3, :sticky => 'w')
$answerClbl['style'] = "Answer.TLabel"

$answerDlbl = Tk::Tile::Label.new(root) {
  text ""
  wraplength 650
}.grid( :column => 2, :row => 4, :sticky => 'w')
$answerDlbl['style'] = "Answer.TLabel"

$option_one = TkVariable.new( 0 ) # put 1 for checked box
$checkA = Tk::Tile::CheckButton.new(root) {text ""; variable $option_one; onvalue 'A'; command {yourAnswer}}
$option_two = TkVariable.new( 0 )
$checkB = Tk::Tile::CheckButton.new(root) {text ""; variable $option_two; onvalue 'B'; command {yourAnswer}}
$option_three = TkVariable.new( 0 )
$checkC = Tk::Tile::CheckButton.new(root) {text ""; variable $option_three; onvalue 'C'; command {yourAnswer}}
$option_four = TkVariable.new( 0 )
$checkD = Tk::Tile::CheckButton.new(root) {text ""; variable $option_four; onvalue 'D'; command {yourAnswer}}
$checkA.grid :column => 1, :row => 1
$checkB.grid :column => 1, :row => 2
$checkC.grid :column => 1, :row => 3
$checkD.grid :column => 1, :row => 4
$checkA.grid_remove()
$checkB.grid_remove()
$checkC.grid_remove()
$checkD.grid_remove()

$radioChoice = TkVariable.new
$radioA = Tk::Tile::RadioButton.new(root) {text ''; variable $radioChoice; value 'A'; command {yourAnswer()}}
$radioB = Tk::Tile::RadioButton.new(root) {text ''; variable $radioChoice; value 'B'; command {yourAnswer()}}
$radioC = Tk::Tile::RadioButton.new(root) {text ''; variable $radioChoice; value 'C'; command {yourAnswer()}}
$radioD = Tk::Tile::RadioButton.new(root) {text ''; variable $radioChoice; value 'D'; command {yourAnswer()}}
$radioA.grid :column => 1, :row => 1
$radioB.grid :column => 1, :row => 2
$radioC.grid :column => 1, :row => 3
$radioD.grid :column => 1, :row => 4
$radioA.grid_remove()
$radioB.grid_remove()
$radioC.grid_remove()
$radioD.grid_remove()

$contentsArray = Array.new
$questionLinesArray = Array.new
$answerAArray = Array.new
$answerBArray = Array.new
$answerCArray = Array.new
$answerDArray = Array.new
$answerEArray = Array.new
$answerFArray = Array.new
$questionsArray = Array.new
$correctAnswersArray = Array.new
$myAnswersArray = Array.new
$questionOnScreen = 0
$totalQuestions = 1

def openFile
  filename = Tk::getOpenFile
  f = File.open(filename) or die "Unable to open file..."
  $contentsArray = []
  f.each_line {|line|
    $contentsArray.push line
  }
  ParseFile()
  $questionOnScreen = 1
  StartQuiz()
end

def ParseFile()
  $contentsArray.each do |line|
    if line.match(/^[Qq][0-9]/)
      $questionLinesArray.push line
    elsif line.match(/^[Aa]\./)
      $answerAArray.push line
    elsif line.match(/^[Bb]\./)
      $answerBArray.push line
    elsif line.match(/^[Cc]\./)
      $answerCArray.push line
    elsif line.match(/^[Dd]\./)
      $answerDArray.push line
    elsif line.match(/^Answer:/)
      $correctAnswersArray.push ((line.sub("Answer:", "")).gsub(" ","")).gsub(",","")
    else
      $questionsArray.push line
    end # end-if
  end # each-do
  $totalQuestions = $questionLinesArray.length
end

def showButtonsOnScreen()
  $btnAnswer.grid :column => 0, :row => 5, :columnspan => 2
  $btnPrev.grid :column => 2, :row => 5, :sticky => 'w'
  $btnNext.grid :column => 2, :row => 5, :sticky => 'e'
  $btnFinish.grid :column => 4, :row => 5, :sticky => 'e'
end

def StartQuiz()
  printQuestionOnScreen()
  printAnswersOnScreen()
  printChoicesOnScreen()
  showButtonsOnScreen()
end

def yourAnswer()
  if $strAnswer.length == 1
    $myAnswersArray[$questionOnScreen - 1] = $radioChoice
  else
    $myAnswersArray[$questionOnScreen - 1] = ($option_one.to_s + $option_two.to_s + $option_three.to_s + $option_four.to_s).gsub("0","")
  end
end

def finishQuestion()
  puts $myAnswersArray
  puts "-------------------"
  puts $correctAnswersArray
  msgBox = Tk.messageBox(
      'type'    => "ok",
      'icon'    => "info",
      'title'   => "GemQuiz - Stats",
      'message' => "This is message over three
levels with enters and stuff
let's see ho w many lijnes
"
  )
end

def SingleChoice(var)
  if var
    $radioA.grid()
    $radioB.grid()
    $radioC.grid()
    $radioD.grid()
    $checkA.grid_remove()
    $checkB.grid_remove()
    $checkC.grid_remove()
    $checkD.grid_remove()
  else
    $radioA.grid_remove()
    $radioB.grid_remove()
    $radioC.grid_remove()
    $radioD.grid_remove()
    $checkA.grid()
    $checkB.grid()
    $checkC.grid()
    $checkD.grid()
  end
end

def resetAnswerLabelColors()
  $answerAlbl['style'] = "Answer.TLabel"
  $answerBlbl['style'] = "Answer.TLabel"
  $answerClbl['style'] = "Answer.TLabel"
  $answerDlbl['style'] = "Answer.TLabel"
end

def printChoicesOnScreen()
  $strAnswer = ($correctAnswersArray[$questionOnScreen - 1].strip)
  if $strAnswer.length == 1
    SingleChoice(true)
  else
    SingleChoice(false)
  end
end

def nextQuestion()
  return if $questionOnScreen == 0 || $questionOnScreen == $totalQuestions
  $questionOnScreen = $questionOnScreen + 1
  resetAnswerLabelColors()
  printQuestionOnScreen()
  printAnswersOnScreen()
  printChoicesOnScreen()
end

def printAnswersOnScreen()
  $answerAlbl['text'] = $answerAArray[$questionOnScreen - 1]
  $answerBlbl['text'] = $answerBArray[$questionOnScreen - 1]
  $answerClbl['text'] = $answerCArray[$questionOnScreen - 1]
  $answerDlbl['text'] = $answerDArray[$questionOnScreen - 1]
end

def prevQuestion()
  return if $questionOnScreen == 0 || $questionOnScreen == 1
  $questionOnScreen = $questionOnScreen - 1
  resetAnswerLabelColors()
  printQuestionOnScreen()
  printAnswersOnScreen()
  printChoicesOnScreen()
end

def answerQuestion()
  return if $questionOnScreen == 0
  case $strAnswer
    when "A"
      $answerAlbl['style'] = "Correct.TLabel"
    when "B"
      $answerBlbl['style'] = "Correct.TLabel"
    when "C"
      $answerClbl['style'] = "Correct.TLabel"
    when "D"
      $answerDlbl['style'] = "Correct.TLabel"
    when "AB"
      $answerAlbl['style'] = "Correct.TLabel"
      $answerBlbl['style'] = "Correct.TLabel"
    when "AC"
      $answerAlbl['style'] = "Correct.TLabel"
      $answerClbl['style'] = "Correct.TLabel"
    when "AD"
      $answerAlbl['style'] = "Correct.TLabel"
      $answerDlbl['style'] = "Correct.TLabel"
    when "BC"
      $answerBlbl['style'] = "Correct.TLabel"
      $answerClbl['style'] = "Correct.TLabel"
    when "BD"
      $answerBlbl['style'] = "Correct.TLabel"
      $answerDlbl['style'] = "Correct.TLabel"
    when "CD"
      $answerClbl['style'] = "Correct.TLabel"
      $answerDlbl['style'] = "Correct.TLabel"
    when "ABC"
      $answerAlbl['style'] = "Correct.TLabel"
      $answerBlbl['style'] = "Correct.TLabel"
      $answerClbl['style'] = "Correct.TLabel"
    when "ABD"
      $answerAlbl['style'] = "Correct.TLabel"
      $answerBlbl['style'] = "Correct.TLabel"
      $answerClbl['style'] = "Correct.TLabel"
    when "ACD"
      $answerAlbl['style'] = "Correct.TLabel"
      $answerClbl['style'] = "Correct.TLabel"
      $answerDlbl['style'] = "Correct.TLabel"
    when "BCD"
      $answerBlbl['style'] = "Correct.TLabel"
      $answerClbl['style'] = "Correct.TLabel"
      $answerDlbl['style'] = "Correct.TLabel"
    else
      $answerAlbl['style'] ="Correct.TLabel"
      $answerBlbl['style'] ="Correct.TLabel"
      $answerClbl['style'] ="Correct.TLabel"
      $answerDlbl['style'] ="Correct.TLabel"
  end
end

def printQuestionOnScreen()
  $questionNumberlabel['text'] = $questionOnScreen.to_s + "."
  $questionlbl['text'] = $questionsArray[$questionOnScreen - 1]
end

def exitProgram
  exit(0)
end

Tk.mainloop