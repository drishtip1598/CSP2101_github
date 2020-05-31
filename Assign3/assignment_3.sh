#Name: Drishti Panubhai Patel
#Student ID: 10447208

#!/bin/bash

#colour code
RED='\033[00;31m' #uses RED colour in code
GREEN='\033[00;32m' #uses GREEN colour in code
YELLOW='\033[00;33m' #uses YELLOW colour in code
BLUE='\033[00;34m' #uses BLUE colour in code
NCOL='\033[0m' #use to set code, back to default

#Function to create thumbnail list
generateThumbnailList(){
    #downloading contents from link to ecu.html
    curl -s -o ecu.html https://www.ecu.edu.au/service-centres/MACSC/gallery/gallery.php?folder=152
    #loading all the thumbnail names to thumbnail.txt
    sed -n '/<div class="thumbnail">/,/<div class="caption">/{//!p;}' ecu.html >textfile.txt
    sed -r 's/.* //g' textfile.txt >thumbnail.txt
    sed -i '{
        s/alt=//g;
        s/>//g;
        s/"//g;
        }' thumbnail.txt

    
}
#Get file size
fileSize(){
    FILENAME=/home/labuser/Pictures/thumbnail/$1.jpg        #saving thnumbnail name from thumbnail to FILENAME.
    FILESIZE=$(stat -c%s "$FILENAME")                       #Getting FILESIZE from FILENAME using stat
    echo "scale=2 ; $FILESIZE / 1024" | bc >size.txt        #Converting FILESIZE from bytes to KB and saving it to size.txt
    
}
#Method to download specific thumbnail to specific location from the input argument
downloadThumbnail(){

    wget -q -N --output-document=/home/labuser/Pictures/thumbnail/$1.jpg https://secure.ecu.edu.au/service-centres/MACSC/gallery/152/$1.jpg   
    fileSize $1
    thumbnailSize=$(cat size.txt)       #following arguments get the filesize from size.txt
    #thumbnailSize is used to exho the filesize in output
    echo -e "Downloading $1.jpg, with the file name  ${YELLOW}$1$.jpg${NCOL}, with a file size of ${GREEN}$thumbnailSize KB${NCOL}....FILE DOWNLOAD COMPLETED.."
   
}

#Method to validate user input based on thumbnail name
validateThumbnailName(){
    number=$1
    while true; do
        if [[ "$number" =~ [DSC][0][1-2][0-9][0-9][0-9] ]] &&  grep -q "$number" thumbnail.txt; then    #validation to check input range
            break
        else
            echo -e "${RED}Invalid!!!!${NCOL} Please try again"                       #error if number is not within given range
        fi
        read -p "Enter your choice:" number 

    done
    downloadThumbnail $number                                       #downloads user input thumbnail
}

#Takes range from the user for the thumbnail and saves it to range.txt
rangeList(){
    choice1=$1
    if [[ -f range.txt ]]                                           #checks if range.txt exists
    then
        rm range.txt                                                #removes if range.txt if exists
    fi
    until [ $choice1 -gt $2 ]; do                                   #Validates the choices
        if grep -Fq "$choice1" thumbnail.txt ; then
            echo "DSC0$choice1" >> range.txt                        #saves the userinput to range.txt file        
        fi
        ((choice1++))
    done
    for name in $(cat range.txt); do
        validateThumbnailName $name                                #Validate all the name in range.txt
    done

}

#Validates the user input to check thumbnail range
validateRangeInput(){
    choice=$1
    while true; 
    do
        if [[ "$choice" =~ [1-2][0-9][0-9][0-9] ]]; then        #checks if the user input is in range
            echo "$choice" > choice$2.txt                       #Saves user input to choice.txt
            break
        else
            echo -e "${RED}Invalid${NCOL}!!!! Please try again!"                   #generates error if input is invalid
        fi
        read -p "Enter your choice: DSC0" choice                
    done
}

#validates user input choices and checks if choices are from range list
downloadThumbnailRange(){
    while true;
    do
        read -p "Enter your first choice: DSC0" choice1
        validateRangeInput $choice1 1           #calling validated choice1 and saves to choice.txt
        read -p "Enter your second choice: DSC0" choice2
        validateRangeInput $choice2 2
        validatedChoice1=$(cat choice1.txt)     #read validated choice1 from choice1.txt
        validatedChoice2=$(cat choice2.txt)     #read validated choice2 from choice2.txt
        if [ $validatedChoice1 -lt $validatedChoice2 ]; then
            #do nothing
            rangeList $validatedChoice1 $validatedChoice2       #gets the range from rangelist
            break
        else
            echo "Your choice1 must be less than choice2!! please try again"        #generates error
        fi
    done   
}

#Checks the user input to validate number is selected from given range
randomThumbnailValidation(){
    while true;
    do
        read -p "Enter random number between 1 to 75: " choice                        #User inputs the choice
        if [[ "$choice" -lt 76 ]] && [[ "$choice" -gt 0 ]]; then    #check if theuserinput is in given range
            generateRandomThumbnail $choice                         #function to generate random thumbnail from user input
            break
        elif [[ "$choice" =~ ^[a-z] ]] || [[ "$choice"  =~ ^[A-Z] ]];then   #input validation to check if userinput is a integer
            echo -e "${RED}Invalid!!!!${NCOL}Input cannot be alphabets. Please Enter number."
        else
            echo -e "${RED}Invalid!!!!${NCOL}Please pick a range between 1 to 75!!"
        fi
        
    done
}



#Saves random thumbnail names based on user input and download all thumbnails
generateRandomThumbnail(){
    if [ -f test.txt ]; then
        rm test.txt
    fi
    lineCount="$(cat thumbnail.txt)";                   #Counts the total number of thumbnail
    number_line=`awk 'END{print NR}' thumbnail.txt`     
    for i in $(seq 1 $1); 
    do 
        random_line=$((1 + RANDOM % $number_line));     #Generates the random thumbnails
        sed $random_line'!d' thumbnail.txt >> test.txt   #saves randomly generated thumbnail to test.txt
       
    done
    for name in $(cat test.txt); do                     #checks if thumbnail is in test.txt
        validateThumbnailName $name
    done
                                       
}

#Creating Directory for Thumbnails.
generateThumbnailList
dir=~/Pictures/thumbnail        #downloading thumbnails to specific location
if ! [ -d  ${dir} ]; then       #check if diectory exists in the path
    echo -e "Creating Directory for thumbnails in ${BLUE}/home/labuser/Pictures/thumbnail${NCOL}."
    mkdir "/home/labuser/Pictures/thumbnail"    #creates the directory to save thumbnail
else
    echo -e "The Directory ${BLUE}/home/labuser/Pictures/thumbnail${NCOL} already exists."   #output if directory already exists
fi

#Switch case starts
while [ "$option" != "exit" ]; do
    #show menu 
    echo -e "1. Download a specific thumbnail \n2. Download ALL thumbnails \n3. Download images in a range \n4. Download a specified number of images"
    #input option from the user
    read -p "Type any option to proceed:" Choice
    case $Choice in
        "1")
            #calls the method for Download a specific thumbnail
            read -p "Enter your choice:" number         #Prompts user for input
            validateThumbnailName $number              #Validates the user input in function
            echo "PROGRAM FINISHED";;                   #display the message 
        "2")
            #calls the method for Download ALL thumbnails
            for name in $(cat thumbnail.txt); do        #checks for the name in thumbnail.txt
                validateThumbnailName $name            #validates Thumbnail name in function
            done
            echo "PROGRAM FINISHED";;                   ##display the message
        "3")
            #calls the method for Download images in a range
            downloadThumbnailRange                     #calls the function
            echo "PROGRAM FINISHED";;                  #display the message
        "4")
            #calls the method for Download a specified number of images
            randomThumbnailValidation                  #calls the function
            echo "PROGRAM FINISHED";;                  #display the message
        *)
            #calls if invalid option is entered
            echo -e "${RED}Invalid Input!!!!${NCOL}!Select number from 1 to 4."     #display the message if user input is invalid
        
    #end of switch case 
    esac
    read -p "Please	press any letter/character to continue or type 'exit' to quit:" option    #prompts the user to continue or exit the program
done

#files cleanup
rm *.txt 
rm *.html       #deletes every file that ends with .html or .txt        