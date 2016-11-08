# Lordi_act10 - Calculates miles-per-gallon, and average MPG on quit.
.data
enterInfoPrompt: .asciiz "\nPlease enter miles and gallons respectively \n(Enter zero for both values to quit): \n"
mpgString: .asciiz "\nThe MPG was: "
averageMPG: .asciiz "\nThe average MPG was: "
inputError: .asciiz "\nError: Invalid input\n"
Zero: .double 0.0		# For use as constant value
One: .double 1.0		# For use as constant value

.text
main:
### Variables for MPG
l.d $f2, Zero			#F2 = Miles Traveled
l.d $f4, Zero			#F4 = Gallons of Gas
l.d $f6, Zero			#F4 = Calculated MPG

### Variables for Average MPG
l.d $f16, Zero			#F16 = Sum of MPGs
l.d $f18, Zero			#F18 = Number of Trips
l.d $f20, Zero			#F4 = Overall average MPG

### Constant variables
l.d $f10, Zero			#F10 CONST: Holds the value for 0.0
l.d $f14, One			#F14 CONST: Holds 1.0 to increment total # of trips

########## TOP OF MAIN LOOP ############################
While:
li $v0, 4			#System code to print a string
la $a0, enterInfoPrompt 	#Load string asking for input
syscall				#Tell the operating system to execute the command

li $v0, 7			#Load the system code to read a double
syscall				#Tell the operating system to execute the command
mov.d $f2, $f0			#Move user input into $F2
syscall				#Tell the operating system to execute the command
mov.d $f4, $f0			#Move user input into $F4

c.lt.d $f2, $f10		#Check if input for miles < 0
bc1t Error			#If result is true jump to Error label
c.lt.d $f4, $f10		#Check if input for gallons < 0
bc1t Error			#If result is true jump to Error label

c.eq.d $f2, $f10		#Check if user entered 0 for miles
bc1t Exit			#If result is true then break out of loop
c.eq.d $f4, $f10		#Check if user entered 0 for gallons
bc1t Exit			#If result is true then break out of loop

jal CalculateMPG		#Call function via Jump-and-Link
j While				#Jump back to top
############ BOTTOM OF MAIN LOOP #######################


Exit:
c.eq.d $f18, $f10		#Check if the number of trips equals zero
bc1t HardExit			#If trip number is zero, then skip next function to avoid divide by zero
jal CalculateAverageMPG		#Calls the function that calculates average MPG
HardExit:			#Jump label for skipping average-MPG function call
li $v0, 10			#Load instruction code for exit
syscall				

### Function : calculates MPG
CalculateMPG:
li $v0, 4			#System code to print a string
la $a0, mpgString		#Load string from memory
syscall				#Tell the operating system to execute the command
div.d $f6, $f2, $f4		#Divide to mile by gallons to compute MPG
li $v0, 3			#System code to print a double
mov.d $f12, $f6			#Move value for mpg into register for displaying double ($f12)
syscall				#Tell the operating system to execute the command
add.d $f18, $f18, $f14 		#Number of trips + 1
add.d $f16, $f16, $f6		#Add MPG to total sum of MPG results
jr $ra				#Return from function
### End function ######

### Function : calculates the average MPG ##
CalculateAverageMPG:
div.d $f20, $f16, $f18		#Divide total MPG sum by number of trips
li $v0, 4			#System code to print a string
la $a0, averageMPG		#Load string from memory
syscall				#Tell the operating system to execute the command
li $v0, 3			#System code to print a double
mov.d $f12, $f20		#Move value for mpg into register for displaying double ($f12)
syscall				#Tell the operating system to execute the command
jr $ra 				#Return from function
### End function ######

### Function : displays error for invalid input
Error:
li $v0, 4			#System code to print a string
la $a0, inputError		#Load string from memory
syscall				#Tell the operating system to execute the command
j While				#Input error warning was displayed, go back to top of main loop
### End function ######
