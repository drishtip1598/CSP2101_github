#!/bin/bash

#Function to create 
thumbnailList(){
    curl -s -o ecu.html https://www.ecu.edu.au/service-centres/MACSC/gallery/gallery.php?folder=152
    sed -n '/<div class="thumbnail">/,/<div class="caption">/{//!p;}' ecu.html >textfile.txt
    sed -r 's/.* //g' textfile.txt >thumbnail.txt
    sed -i '{
        s/alt=//g;
        s/>//g;
        s/"//g;
        }' thumbnail.txt
    rm textfile.txt

}


#[0][1-2][0-9][0-9][0-9]
validateName(){
    number=$1
    #echo "$num"
    while true; do
        if [[ "$number" =~ [DSC][0][1-2][0-9][0-9][0-9] ]]; then
            break
        else
            echo "Invalid Please try again: "   
        fi
        read -p "Enter your choice:" number 

    done
    downloadThumbnail $number
}




#method to download specific thumbnail

downloadThumbnail(){
    wget -q --output-document=/home/labuser/CSP2101/workshop/assignments/assig3/thumbnail/$1.jpg https://secure.ecu.edu.au/service-centres/MACSC/gallery/152/$1.jpg   
}

rangeList(){
    choice1=$1
    if [[ -f range.txt ]]
    then
        rm range.txt
    fi
    until [ $choice1 -gt $2 ]; do
        if grep -Fq "$choice1" thumbnail.txt ; then
            echo "DSC0$choice1" >> range.txt
        fi
        ((choice1++))
    done
    for name in $(cat range.txt); do
        validateName $name
    done

}

randomFile(){
    lineCount="$(cat thumbnail.txt)";

    number_line=`awk 'END{print NR}' thumbnail.txt`
    #user_input=7 # user input is hardcode.. you can use read function to get a value from user.
    for i in $(seq 1 $1); 
    do 
        random_line=$((1 + RANDOM % $number_line));
        sed $random_line'!d' thumbnail.txt >>test.txt
       # downloadThumbnail $random_line
       
    done
    for name in $(cat test.txt); do 
        validateName $name
    done
    rm test.txt 
}
#Switch case starts
thumbnailList
dir=~/CSP2101/workshop/assignments/assig3/thumbnail
if [ -d  ${dir} ]; then
    #do nothing
    echo ""
else
    echo "Creating it now..."
    mkdir "thumbnail"
fi
while [ "$option" != "exit" ]; do
    #show menu 
    echo -e "1. Download a specific thumbnail \n2. Download ALL thumbnails \n3. Download images in a range \n4. Download a specified number of images"
    #input option from the user
    read -p "Type any option to proceed:" Choice
    case $Choice in
        "1")
            #calls the method for Download a specific thumbnail
            read -p "Enter your choice:" number
            #downloadThumbnail $number
            validateName $number
            ;;
            
        "2")
            #calls the method for Download ALL thumbnails
            for name in $(cat thumbnail.txt); do
                validateName $name
            done
            echo "$number";;
        "3")
            #calls the method for Download images in a range
            echo "$number"
            read -p "Enter fir choice:" choice1
            read -p "Enter sec choice:" choice2
            rangeList $choice1 $choice2
            ;;
        "4")
            #calls the method for Download a specified number of images
            read -p "Enter count:" choice
            randomFile $choice

            ;;
        *)
            #calls if invalid option is entered
            echo "Invalid Input!"
    #end of switch case
    esac
    read -p "Please	press any letter/character to continue or type 'exit' to quit:" option
done