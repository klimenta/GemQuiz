require 'tk'
require 'tkextlib/tile'

$root = TkRoot.new
$root.minsize(width=800, height=600)
$root.maxsize(width=800, height=600)
$root.resizable(false, false)

TkOption.add '*tearOff', 0

menubar = TkMenu.new($root)
$root['menu'] = menubar
file = TkMenu.new(menubar)
menubar.add :cascade, :menu => file, :label => 'File'
file.add :command, :label => 'Open...', :command => proc{openFile}
file.add :command, :label => 'Exit', :command => proc{exitProgram}

Tk::Tile::Style.configure('Question.TLabel', {"font" => "helvetica 14", "foreground" => "black"})
Tk::Tile::Style.configure('QuestionNumber.TLabel', {"font" => "helvetica 20", "foreground" => "red"})
Tk::Tile::Style.configure('Correct.TLabel', {"font" => "helvetica 14", "foreground" => "darkgreen"})
Tk::Tile::Style.configure('Answer.TLabel', {"font" => "helvetica 14", "foreground" => "blue"})
Tk::Tile::Style.configure('Stats.TLabel', {"font" => "helvetica 10", "foreground" => "black"})

$answerAArray = Array.new
$answerBArray = Array.new
$answerCArray = Array.new
$answerDArray = Array.new
$questionsArray = Array.new
$correctAnswersArray = Array.new
$myAnswersArray = Array.new
$questionOnScreen = 0
$totalQuestions = 1

def openFile
  # This array holds the whole quiz file
  arrQuizContents = Array.new
  filename = Tk::getOpenFile
  begin
    f = File.open(filename) or die "Unable to open file..."
  rescue
    return
  end
  arrQuizContents = []
  f.each_line {|line|
    arrQuizContents.push line
  }
  f.close
  ParseFile(arrQuizContents)
  $questionOnScreen = 1
  StartQuiz()
end

def ParseFile(arr)
  questionLinesArray = Array.new
  arr.each do |line|
    if line.match(/^[Qq][0-9]/)
      questionLinesArray.push line
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
  $totalQuestions = questionLinesArray.length
end

def StartQuiz()
  frmQuestion = Tk::Tile::Frame.new($root) {width 760; height 175}
  frmQuestion.grid :column => 1, :row => 0, :columnspan => 4
  frmQuestion.grid_propagate(false)
  frmAnswerA = Tk::Tile::Frame.new($root) {width 760; height 90}
  frmAnswerA.grid :column => 1, :row => 1, :columnspan => 4
  frmAnswerA.grid_propagate(false)
  frmAnswerB = Tk::Tile::Frame.new($root) {width 760; height 90}
  frmAnswerB.grid :column => 1, :row => 2, :columnspan => 4
  frmAnswerB.grid_propagate(false)
  frmAnswerC = Tk::Tile::Frame.new($root) {width 760; height 90}
  frmAnswerC.grid :column => 1, :row => 3, :columnspan => 4
  frmAnswerC.grid_propagate(false)
  frmAnswerD = Tk::Tile::Frame.new($root) {width 760; height 90}
  frmAnswerD.grid :column => 1, :row => 4, :columnspan => 4
  frmAnswerD.grid_propagate(false)
  frmChoiceA = Tk::Tile::Frame.new($root) {width 40; height 90}
  frmChoiceA.grid :column => 0, :row => 1
  frmChoiceA.grid_propagate(false)
  frmChoiceB = Tk::Tile::Frame.new($root) {width 40; height 90}
  frmChoiceB.grid :column => 0, :row => 2
  frmChoiceB.grid_propagate(false)
  frmChoiceC = Tk::Tile::Frame.new($root) {width 40; height 90}
  frmChoiceC.grid :column => 0, :row => 3
  frmChoiceC.grid_propagate(false)
  frmChoiceD = Tk::Tile::Frame.new($root) {width 40; height 90}
  frmChoiceD.grid :column => 0, :row => 4
  frmChoiceD.grid_propagate(false)
  frmNothing = Tk::Tile::Frame.new($root) {width 40; height 65}
  frmNothing.grid :column => 0, :row => 5, :rowspan => 2
  frmNothing.grid_propagate(false)
  frmStats = Tk::Tile::Frame.new($root) {width 760; height 30}
  frmStats.grid :column => 1, :row => 6, :columnspan => 4
  frmStats.grid_propagate(false)
  frmNumber = Tk::Tile::Frame.new($root) {width 40; height 175}
  frmNumber.grid :column => 0, :row => 0
  frmNumber.grid_propagate(false)
  frmbtnAnswer = Tk::Tile::Frame.new($root) {width 190; height 35}
  frmbtnAnswer.grid :column => 1, :row => 5
  frmbtnAnswer.grid_propagate(false)
  frmbtnPrev = Tk::Tile::Frame.new($root) {width 190; height 35}
  frmbtnPrev.grid :column => 2, :row => 5
  frmbtnPrev.grid_propagate(false)
  frmbtnNext = Tk::Tile::Frame.new($root) {width 190; height 35}
  frmbtnNext.grid :column => 3, :row => 5
  frmbtnNext.grid_propagate(false)
  frmbtnFinish = Tk::Tile::Frame.new($root) {width 190; height 35}
  frmbtnFinish.grid :column => 4, :row => 5
  frmbtnFinish.grid_propagate(false)

  btnAnswer = Tk::Tile::Button.new(frmbtnAnswer) {text "Answer"; command {answerQuestion()}}
  btnPrev = Tk::Tile::Button.new(frmbtnPrev) {text "< Prev"; command {prevQuestion()}}
  btnNext = Tk::Tile::Button.new(frmbtnNext) {text "Next >"; command {nextQuestion()}}
  btnFinish = Tk::Tile::Button.new(frmbtnFinish) {text "Finish"; command {finishQuestion()}}

  $questionNumberlabel  = Tk::Tile::Label.new(frmNumber) {text ""}
  $questionNumberlabel['style'] = "QuestionNumber.TLabel"

  $lblStats = Tk::Tile::Label.new(frmStats) {text "Program by Kliment ANDREEV - 2015"}
  $lblStats['style'] = "Stats.TLabel"
  $lblStats.grid :column =>0 , :row => 0

  $questionlbl = Tk::Tile::Label.new(frmQuestion) {text "" ;wraplength 755 }
  $questionlbl['style'] = "Question.TLabel"

  $answerAlbl = Tk::Tile::Label.new(frmAnswerA) {
    text ""
    wraplength 755
  }.grid( :column => 0, :row => 0, :sticky => 'w')

  $answerAlbl['style'] = "Answer.TLabel"

  $answerBlbl = Tk::Tile::Label.new(frmAnswerB) {
    text ""
    wraplength 755
  }.grid( :column => 0, :row => 1, :sticky => 'w')
  $answerBlbl['style'] = "Answer.TLabel"

  $answerClbl = Tk::Tile::Label.new(frmAnswerC) {
    text ""
    wraplength 755
  }.grid( :column => 0, :row => 2, :sticky => 'w')
  $answerClbl['style'] = "Answer.TLabel"

  $answerDlbl = Tk::Tile::Label.new(frmAnswerD) {
    text ""
    wraplength 755
  }.grid( :column => 0, :row => 3, :sticky => 'w')
  $answerDlbl['style'] = "Answer.TLabel"

  btnAnswer.grid :column => 0, :row => 0
  btnPrev.grid :column => 0, :row => 0
  btnNext.grid :column => 0, :row => 0
  btnFinish.grid :column => 0, :row => 0

  $option_one = TkVariable.new( 0 ) # put 1 for checked box
  $checkA = Tk::Tile::CheckButton.new(frmChoiceA) {text ""; variable $option_one; onvalue 'A'; command {yourAnswer}}
  $option_two = TkVariable.new( 0 )
  $checkB = Tk::Tile::CheckButton.new(frmChoiceB) {text ""; variable $option_two; onvalue 'B'; command {yourAnswer}}
  $option_three = TkVariable.new( 0 )
  $checkC = Tk::Tile::CheckButton.new(frmChoiceC) {text ""; variable $option_three; onvalue 'C'; command {yourAnswer}}
  $option_four = TkVariable.new( 0 )
  $checkD = Tk::Tile::CheckButton.new(frmChoiceD) {text ""; variable $option_four; onvalue 'D'; command {yourAnswer}}
  $checkA.grid :column => 0, :row => 0
  $checkB.grid :column => 0, :row => 0
  $checkC.grid :column => 0, :row => 0
  $checkD.grid :column => 0, :row => 0
  $checkA.grid_remove()
  $checkB.grid_remove()
  $checkC.grid_remove()
  $checkD.grid_remove()

  $radioChoice = TkVariable.new
  $radioA = Tk::Tile::RadioButton.new(frmChoiceA) {text ''; variable $radioChoice; value 'A'; command {yourAnswer()}}
  $radioB = Tk::Tile::RadioButton.new(frmChoiceB) {text ''; variable $radioChoice; value 'B'; command {yourAnswer()}}
  $radioC = Tk::Tile::RadioButton.new(frmChoiceC) {text ''; variable $radioChoice; value 'C'; command {yourAnswer()}}
  $radioD = Tk::Tile::RadioButton.new(frmChoiceD) {text ''; variable $radioChoice; value 'D'; command {yourAnswer()}}
  $radioA.grid :column => 0, :row => 0
  $radioB.grid :column => 0, :row => 0
  $radioC.grid :column => 0, :row => 0
  $radioD.grid :column => 0, :row => 0
  $radioA.grid_remove()
  $radioB.grid_remove()
  $radioC.grid_remove()
  $radioD.grid_remove()

  printQuestionOnScreen()
  printAnswersOnScreen()
  printChoicesOnScreen()
end

def printQuestionOnScreen()
  $questionNumberlabel.grid :column => 0, :row => 0
  $questionNumberlabel['text'] = $questionOnScreen.to_s + "."
  $questionlbl.grid :column => 1, :row => 0
  $questionlbl['text'] = $questionsArray[$questionOnScreen - 1]
end

def printAnswersOnScreen()
  $answerAlbl['text'] = $answerAArray[$questionOnScreen - 1]
  $answerBlbl['text'] = $answerBArray[$questionOnScreen - 1]
  $answerClbl['text'] = $answerCArray[$questionOnScreen - 1]
  $answerDlbl['text'] = $answerDArray[$questionOnScreen - 1]
end

def printChoicesOnScreen()
  $strAnswer = ($correctAnswersArray[$questionOnScreen -  1].strip)
  if $strAnswer.length == 1
    SingleChoice(true)
  else
    SingleChoice(false)
  end
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

def nextQuestion()
  return if $questionOnScreen == 0 || $questionOnScreen == $totalQuestions
  $questionOnScreen = $questionOnScreen + 1
  resetAnswerLabelColors()
  printQuestionOnScreen()
  printAnswersOnScreen()
  printChoicesOnScreen()
end

def resetAnswerLabelColors()
  $answerAlbl['style'] = "Answer.TLabel"
  $answerBlbl['style'] = "Answer.TLabel"
  $answerClbl['style'] = "Answer.TLabel"
  $answerDlbl['style'] = "Answer.TLabel"
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

def yourAnswer()
  if $strAnswer.length == 1
    $myAnswersArray[$questionOnScreen - 1] = $radioChoice
  else
    $myAnswersArray[$questionOnScreen - 1] = ($option_one.to_s + $option_two.to_s + $option_three.to_s + $option_four.to_s).gsub("0","")
  end
end

def exitProgram
  exit(0)
end

Tk.mainloop

 
