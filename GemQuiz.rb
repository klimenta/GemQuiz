 #######################################################################################################################
#### The quiz has to be in the following format, no blank lines are allowed                                        ####
####                                                                                                               ####
#### Question number                                                                                               ####
#### Question text (one continuous line, the program takes care of the wrapping)                                   ####
#### Four possible answers, each line starts with A., B., C. and D.                                                ####
#### Answer(s) line that starts with the words "Answer: " (no quotes) and the correct answer                       ####
####      The program takes care of single/multiple choice answer widgets                                          ####
#######################################################################################################################
#### e.g.                                                                                                          ####
#######################################################################################################################
#### Q1.                                                                                                           ####
#### Leveraged loans are loans provided to companies that already have a significant amount of outstanding debt.   ####
#### As a banker, how might you compare a leveraged loan to other loans in your portfolio?                         ####
#### A. Higher risk to the lender but less costly to the borrower.                                                 ####
#### B. Lower risk to the lender and less costly to the borrower.                                                  ####
#### C. Lower risk to the lender but more costly to the borrower.                                                  ####
#### D. Higher risk to the lender and more costly to the borrower.                                                 ####
#### Answer: D                                                                                                     ####
#######################################################################################################################
#### This example will create a quiz with 4 radio buttons. If the answer line was Answer: B,C                      ####
#### then the program will show four check buttons instead.                                                        ####
#### NOTE: The question in this example is two lines. In the file, it should be one continuous line                ####                                                      ####
#######################################################################################################################

require 'tk'
require 'tkextlib/tile'

# Creates the root (parent) windows, 800 x 600, not resizable
$root = TkRoot.new
$root.minsize(width = 800, height = 600)
$root.maxsize(width = 800, height = 600)
$root.resizable(false, false)

TkOption.add '*tearOff', 0

# Creates the menu with two options (open and exit)
menuBar = TkMenu.new($root)
$root['menu'] = menuBar
menuFile = TkMenu.new(menuBar)
menuBar.add :cascade, :menu => menuFile, :label => 'File'
menuFile.add :command, :label => 'Open...', :command => proc{ openFile }
menuFile.add :command, :label => 'Exit', :command => proc{ exitProgram }

# Templates for the label's size and color
Tk::Tile::Style.configure('Question.TLabel', {"font" => "helvetica 14", "foreground" => "black"})
Tk::Tile::Style.configure('QuestionNumber.TLabel', {"font" => "helvetica 20", "foreground" => "red"})
Tk::Tile::Style.configure('Correct.TLabel', {"font" => "helvetica 14", "foreground" => "darkgreen"})
Tk::Tile::Style.configure('Answer.TLabel', {"font" => "helvetica 14", "foreground" => "blue"})
Tk::Tile::Style.configure('Stats.TLabel', {"font" => "helvetica 10", "foreground" => "black"})

# Variables
$arrQuestionLines = Array.new # All the question lines are stored here, e.g. Q1, Q2
$arrAnswerA = Array.new # All the possible answers that show up as answer A.
$arrAnswerB = Array.new # All the possible answers that show up as answer B.
$arrAnswerC = Array.new # All the possible answers that show up as answer C.
$arrAnswerD = Array.new # All the possible answers that show up as answer D.
$arrQuestions = Array.new # All the questions are stored in this array
$arrCorrectAnswers = Array.new # These are the correct answers for the questions
$arrUserAnswers = Array.new # These are the answers that the users picked up

$intQuestionOnScreen = 0 # The current question on the screen
$intTotalQuestions = 1 # Total number of questions

# Opens up the quiz file and loads all the content into an array
def openFile
  arrQuizContents = Array.new
  $filename = Tk::getOpenFile
  begin
    f = File.open($filename) or die "Unable to open file..."
  rescue # In case the users hits cancel or ESC, return to the menu
    return
  end
  arrQuizContents = []
  f.each_line {|strLine|
    arrQuizContents.push strLine # Puts the file in one array
  }
  f.close
  ParseFile(arrQuizContents)
  $intQuestionOnScreen = 1
  StartQuiz()
end

# Parses the contents array and gets question number lines, questions, possible answers and correct answers
def ParseFile(arr)
  arr.each do |strLine|
    if strLine.match(/^[Qq][0-9]/)
      $arrQuestionLines.push strLine
    elsif strLine.match(/^[Aa]\./)
      $arrAnswerA.push strLine
    elsif strLine.match(/^[Bb]\./)
      $arrAnswerB.push strLine
    elsif strLine.match(/^[Cc]\./)
      $arrAnswerC.push strLine
    elsif strLine.match(/^[Dd]\./)
      $arrAnswerD.push strLine
    elsif strLine.match(/^Answer:/)
      $arrCorrectAnswers.push ((strLine.sub("Answer:", "")).gsub(" ","")).gsub(",","").gsub(/\n/,"")
    else
      $arrQuestions.push strLine
    end
  end
  $intTotalQuestions = $arrQuestionLines.length
end

# Initializes all the widgets and arranges them on the screen
# Frame widgets start with frm
# label widgets start with lbl
# button widgets start with btn
# grid_propagate(false) means that the frame is absolute.
# The size (height, width) always stay the same
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
  $frmChoiceA = Tk::Tile::Frame.new($root) {width 40; height 90}
  $frmChoiceA.grid :column => 0, :row => 1
  $frmChoiceA.grid_propagate(false)
  $frmChoiceB = Tk::Tile::Frame.new($root) {width 40; height 90}
  $frmChoiceB.grid :column => 0, :row => 2
  $frmChoiceB.grid_propagate(false)
  $frmChoiceC = Tk::Tile::Frame.new($root) {width 40; height 90}
  $frmChoiceC.grid :column => 0, :row => 3
  $frmChoiceC.grid_propagate(false)
  $frmChoiceD = Tk::Tile::Frame.new($root) {width 40; height 90}
  $frmChoiceD.grid :column => 0, :row => 4
  $frmChoiceD.grid_propagate(false)
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
  $btnPrev = Tk::Tile::Button.new(frmbtnPrev) {text "< Prev"; command {prevQuestion()}}
  $btnPrev.state = 'disabled'
  $btnNext = Tk::Tile::Button.new(frmbtnNext) {text "Next >"; command {nextQuestion()}}
  btnFinish = Tk::Tile::Button.new(frmbtnFinish) {text "Finish"; command {finishQuestion()}}

  $lblQuestionNumber  = Tk::Tile::Label.new(frmNumber) {text ""}
  $lblQuestionNumber['style'] = "QuestionNumber.TLabel"

  $lblStats = Tk::Tile::Label.new(frmStats) {text "Program by Kliment ANDREEV - 2015"}
  $lblStats['style'] = "Stats.TLabel"
  $lblStats.grid :column =>0 , :row => 0
  $lblStats.text = $filename + " | Program by Kliment Andreev - 2015"

  $lblQuestion = Tk::Tile::Label.new(frmQuestion) {text "" ;wraplength 755 }
  $lblQuestion['style'] = "Question.TLabel"

  $lblAnswerA = Tk::Tile::Label.new(frmAnswerA) {
    text ""
    wraplength 755
  }.grid( :column => 0, :row => 0, :sticky => 'w')
  $lblAnswerA['style'] = "Answer.TLabel"

  $lblAnswerB = Tk::Tile::Label.new(frmAnswerB) {
    text ""
    wraplength 755
  }.grid( :column => 0, :row => 1, :sticky => 'w')
  $lblAnswerB['style'] = "Answer.TLabel"

  $lblAnswerC = Tk::Tile::Label.new(frmAnswerC) {
    text ""
    wraplength 755
  }.grid( :column => 0, :row => 2, :sticky => 'w')
  $lblAnswerC['style'] = "Answer.TLabel"

  $lblAnswerD = Tk::Tile::Label.new(frmAnswerD) {
    text ""
    wraplength 755
  }.grid( :column => 0, :row => 3, :sticky => 'w')
  $lblAnswerD['style'] = "Answer.TLabel"

  btnAnswer.grid :column => 0, :row => 0
  $btnPrev.grid :column => 0, :row => 0
  $btnNext.grid :column => 0, :row => 0
  btnFinish.grid :column => 0, :row => 0

  printQuestionOnScreen()
  printAnswersOnScreen()
  printChoicesOnScreen()
end

# Prints the question and the question number on the screen
def printQuestionOnScreen()
  $lblQuestionNumber.grid :column => 0, :row => 0
  $lblQuestionNumber['text'] = $intQuestionOnScreen.to_s + "."
  $lblQuestion.grid :column => 1, :row => 0
  $lblQuestion['text'] = $arrQuestions[$intQuestionOnScreen - 1]
end

# Prints all four possible answers on the screen
def printAnswersOnScreen()
  $lblAnswerA['text'] = $arrAnswerA[$intQuestionOnScreen - 1]
  $lblAnswerB['text'] = $arrAnswerB[$intQuestionOnScreen - 1]
  $lblAnswerC['text'] = $arrAnswerC[$intQuestionOnScreen - 1]
  $lblAnswerD['text'] = $arrAnswerD[$intQuestionOnScreen - 1]
end

# Destroys the choice widgets when the user chooses previous or next question
def destroyChoicesOnScreen()
  if $strAnswer.length == 1
    $radioA.destroy
    $radioB.destroy
    $radioC.destroy
    $radioD.destroy
  else
    $checkA.destroy
    $checkB.destroy
    $checkC.destroy
    $checkD.destroy
  end
end

# Prints the radio buttons or check buttons (choices) for the answers
def printChoicesOnScreen()
  $strAnswer = ($arrCorrectAnswers[$intQuestionOnScreen -  1].strip)
  # Based on the number of correct answers, the program decides to use radio or check buttons
  if $strAnswer.length == 1
    $radioChoice = TkVariable.new
    $radioA = Tk::Tile::RadioButton.new($frmChoiceA) {text ''; variable $radioChoice; value 'A'; command {yourAnswer}}
    $radioB = Tk::Tile::RadioButton.new($frmChoiceB) {text ''; variable $radioChoice; value 'B'; command {yourAnswer}}
    $radioC = Tk::Tile::RadioButton.new($frmChoiceC) {text ''; variable $radioChoice; value 'C'; command {yourAnswer}}
    $radioD = Tk::Tile::RadioButton.new($frmChoiceD) {text ''; variable $radioChoice; value 'D'; command {yourAnswer}}
    $radioA.grid :column => 0, :row => 0
    $radioB.grid :column => 0, :row => 0
    $radioC.grid :column => 0, :row => 0
    $radioD.grid :column => 0, :row => 0
  else
    $option_one = TkVariable.new( 0 )
    $checkA = Tk::Tile::CheckButton.new($frmChoiceA) {text ""; variable $option_one; onvalue 'A'; command {yourAnswer}}
    $option_two = TkVariable.new( 0 )
    $checkB = Tk::Tile::CheckButton.new($frmChoiceB) {text ""; variable $option_two; onvalue 'B'; command {yourAnswer}}
    $option_three = TkVariable.new( 0 )
    $checkC = Tk::Tile::CheckButton.new($frmChoiceC) {text ""; variable $option_three; onvalue 'C'; command {yourAnswer}}
    $option_four = TkVariable.new( 0 )
    $checkD = Tk::Tile::CheckButton.new($frmChoiceD) {text ""; variable $option_four; onvalue 'D'; command {yourAnswer}}
    $checkA.grid :column => 0, :row => 0
    $checkB.grid :column => 0, :row => 0
    $checkC.grid :column => 0, :row => 0
    $checkD.grid :column => 0, :row => 0
  end
end

# When user clicks the button for the next question
def nextQuestion()
  return if $intQuestionOnScreen == 0 || $intQuestionOnScreen == $intTotalQuestions
  $intQuestionOnScreen += 1
  if $intQuestionOnScreen == $intTotalQuestions
    $btnNext.state = 'disabled'
  end
  destroyChoicesOnScreen()
  resetAnswerLabelColors()
  printQuestionOnScreen()
  printAnswersOnScreen()
  printChoicesOnScreen()
  printUsersChoiceOnScreen()
  $btnPrev.state = 'enabled'
end

# Resets answers to the default look
def resetAnswerLabelColors()
  $lblAnswerA['style'] = "Answer.TLabel"
  $lblAnswerB['style'] = "Answer.TLabel"
  $lblAnswerC['style'] = "Answer.TLabel"
  $lblAnswerD['style'] = "Answer.TLabel"
end

# When user clicks the button for the previous question
def prevQuestion()
  return if $intQuestionOnScreen == 0 || $intQuestionOnScreen == 1
  $btnNext.state = 'enabled'
  $intQuestionOnScreen -= 1
  if $intQuestionOnScreen == 1
    $btnPrev.state = 'disabled'
  end
  destroyChoicesOnScreen()
  resetAnswerLabelColors()
  printQuestionOnScreen()
  printAnswersOnScreen()
  printChoicesOnScreen()
  printUsersChoiceOnScreen()
end

# Prints whatever the user selected when the previous or next question is displayed
def printUsersChoiceOnScreen()
  $strAnswer = ($arrCorrectAnswers[$intQuestionOnScreen -  1].strip)
  if $strAnswer.length == 1
    case $arrUserAnswers[$intQuestionOnScreen - 1]
      when "A"
        $radioA.invoke()
      when "B"
        $radioB.invoke()
      when "C"
        $radioC.invoke()
      when "D"
        $radioD.invoke()
    end
  else
    case $arrUserAnswers[$intQuestionOnScreen - 1]
      when "A"
        checkInvoke(true, false, false, false)
      when "B"
        checkInvoke(false, true, false, false)
      when "C"
        checkInvoke(false, false, true, false)
      when "D"
        checkInvoke(false, false, false, true)
      when "AB"
        checkInvoke(true, true, false, false)
      when "AC"
        checkInvoke(true, false, true, false)
      when "AD"
        checkInvoke(true, false, false, true)
      when "BC"
        checkInvoke(false, true, true, false)
      when "BD"
        checkInvoke(false, true, false, true)
      when "CD"
        checkInvoke(false, false, true, true)
      when "ABC"
        checkInvoke(true, true, true, false)
      when "ABD"
        checkInvoke(true, true, false, true)
      when "ACD"
        checkInvoke(true, false, true, true)
      when "BCD"
        checkInvoke(false, true, true, true)
      when "ABCD"
        checkInvoke(true, true, true, true)
    end
  end
end

def selectAnswerA
  $checkA.invoke()
end

def selectAnswerB
  $checkB.invoke()
end

def selectAnswerC
  $checkC.invoke()
end

def selectAnswerD
  $checkD.invoke()
end

def checkInvoke(bA, bB, bC, bD)
  arr = [method(:selectAnswerA), method(:selectAnswerB), method(:selectAnswerC), method(:selectAnswerD)]
  arr[0].call if bA
  arr[1].call if bB
  arr[2].call if bC
  arr[3].call if bD
end

# Prints the correct answer on the screen when user clicks on the Answer button
def answerQuestion()
  return if $intQuestionOnScreen == 0
  case $strAnswer
    when "A"
      $lblAnswerA['style'] = "Correct.TLabel"
    when "B"
      $lblAnswerB['style'] = "Correct.TLabel"
    when "C"
      $lblAnswerC['style'] = "Correct.TLabel"
    when "D"
      $lblAnswerD['style'] = "Correct.TLabel"
    when "AB"
      $lblAnswerA['style'] = "Correct.TLabel"
      $lblAnswerB['style'] = "Correct.TLabel"
    when "AC"
      $lblAnswerA['style'] = "Correct.TLabel"
      $lblAnswerC['style'] = "Correct.TLabel"
    when "AD"
      $lblAnswerA['style'] = "Correct.TLabel"
      $lblAnswerD['style'] = "Correct.TLabel"
    when "BC"
      $lblAnswerB['style'] = "Correct.TLabel"
      $lblAnswerC['style'] = "Correct.TLabel"
    when "BD"
      $lblAnswerB['style'] = "Correct.TLabel"
      $lblAnswerD['style'] = "Correct.TLabel"
    when "CD"
      $lblAnswerC['style'] = "Correct.TLabel"
      $lblAnswerD['style'] = "Correct.TLabel"
    when "ABC"
      $lblAnswerA['style'] = "Correct.TLabel"
      $lblAnswerB['style'] = "Correct.TLabel"
      $lblAnswerC['style'] = "Correct.TLabel"
    when "ABD"
      $lblAnswerA['style'] = "Correct.TLabel"
      $lblAnswerB['style'] = "Correct.TLabel"
      $lblAnswerC['style'] = "Correct.TLabel"
    when "ACD"
      $lblAnswerA['style'] = "Correct.TLabel"
      $lblAnswerC['style'] = "Correct.TLabel"
      $lblAnswerD['style'] = "Correct.TLabel"
    when "BCD"
      $lblAnswerB['style'] = "Correct.TLabel"
      $lblAnswerC['style'] = "Correct.TLabel"
      $lblAnswerD['style'] = "Correct.TLabel"
    else
      $lblAnswerA['style'] ="Correct.TLabel"
      $lblAnswerB['style'] ="Correct.TLabel"
      $lblAnswerC['style'] ="Correct.TLabel"
      $lblAnswerD['style'] ="Correct.TLabel"
  end
end

# Finishes the quiz when the user clicks on the Finish button and displays the stats
def finishQuestion()
  # Compares the arrays of correct answers and user's selected answers
  # and creates another array with correct (true) answers
  arrTrueAnswers = $arrUserAnswers.zip($arrCorrectAnswers).map { |x, y| x == y}
  x = arrTrueAnswers.count(true)
  msgBox = Tk.messageBox(
      'type'    => "ok",
      'icon'    => "info",
      'title'   => "GemQuiz - Stats",
      'message' => "You have " + x.to_s + " correct answers out of " + $intTotalQuestions.to_s + ".
                    That's " + ((x.to_f / $intTotalQuestions.to_f) * 100).round(2).to_s + "%.")
end

# Updates the array with the answer that the user selected
def yourAnswer()
  if $strAnswer.length == 1
    $arrUserAnswers[$intQuestionOnScreen - 1, 1] = $radioChoice
  else
    $arrUserAnswers[$intQuestionOnScreen - 1] = ($option_one.to_s + $option_two.to_s + $option_three.to_s + $option_four.to_s).gsub("0", "")
  end
end

# Exits the program if selected from the menu
def exitProgram
  exit(0)
end

Tk.mainloop