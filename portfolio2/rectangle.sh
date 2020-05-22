#!/bin/bash

#Student Name: Drishti Panubhai Patel
#Student ID: 10447208
#Description: The following Scripting uses the SED command to process the Text file.
#             The follwing Script will obtain dimensions of rectangle from rectangle.txt file and output the formatted verion to reactnagle_f.txt


if [ -f rectangle_f.txt ]; then       #Following argument will checks if rectangle_f.txt exists
    rm rectangle_f.txt                #Removes if rectangle_f.txt exists 
fi                                    #end Command for if

echo 'Proccessing the Data...'        ##Echoing 'Proccessing the Data...' on the Terminal
echo '---------------------------------------------------------------------------------'
sed '/Name,Height,Width,Area,Colour/d' rectangle.txt > rectangle_f.txt      #Deletes the line Containing 'Name,Height,Width,Area,Colour' from rectange.txt and saves it to rectangle_f.txt,                              

#-e will read multiple line commands seperated by '\', and so each line has its own -e
#Passing argument to subsitute Rec with Name: Rec for first matching pattern found in line
#Passing argument to subsitute ',' with Height for second matching pattern found in every line with the tab space
#Passing argument to subsitute ',' with Width for third matching pattern found in every line with the tab space
#Passing argument to subsitute ',' with Area for fourth matching pattern found in every line with the tab space
#Passing argument to subsitute ',' with Colour for fifth matching pattern found in every line with the tab space 
#'rectangle.txt > rectangle_f.txt' All the arguments will take input from rectangle.txt and save it to rectangle_f.txt
sed -e 's/Rec/\Name: Rec/'\
    -e 's/,/\tHeight: /'\
    -e 's/,/\tWidth: /'\
    -e 's/,/\tArea: /'\
    -e 's/,/\tColour: /' rectangle.txt > rectangle_f.txt    #Following argument will display the content from rectangle_f.txt.

cat rectangle_f.txt   #Following argument will display the content from rectangle_f.txt.

echo '---------------------Data has been written on rectangle_f.txt--------------------' #Following argument will echo message on Terminal
