CS3340Project Team One
=============

CS3340 Semester Project

This project is based off of the moble game Lexathon, but written in MIPS assembly.

---------
Features
---------
 Score - This game keeps track of your score by adding points whenever a new word is found.

 Timer - There is a timer that extends when a word is found and will stop the game when it runs out.

 Scramble - The user can scramble the words while keeping the middle letter the same.

 Input - The user can guess words by typing in words and pressing enter, the program will check and then tell the user whether their word was correct or incorrect.

 Input Validation - In order for the word to be valid, the program checks to see if the word is at least 4 letters long, the middle letter is used, all the letters used are in the nine letter word, and the word is "real"(in the dictionary).

 Dictionary - Imports in all nine letter words and all the words that can be made from the nine letter words.




--------
How To
--------
Open main.asm in MIPS

In MIPS, go to Settings and check "Initialize Program Counter to global 'main' if defined". 

Initialize and run the game; the game will start immediately.

The game will start out with a timer of 60 seconds. You will get an extra 20 seconds for every word that you find. When the timer runs out, the game will end and the score will be shown.

The score is incremented by 10 for every word that is found and there is no penalty for entering in an incorrect word.

To enter a word, type in a word and then press enter, the program will check to see if the word is valid 
and will check to see if the word has been entered already.

