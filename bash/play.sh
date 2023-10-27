#!/bin/bash

function countScore() {
    sum=0
    for x in `cat $1 | cut -f 3 -d";"`; do
        if [ $x -eq 11 -a `expr $sum + $x` -gt 21 ]; then
            sum=`expr $sum + 1`
        else
            sum=`expr $sum + $x`
        fi
    done
    echo $sum
}

function finalScore() {
    if [ $1 -gt 21 ]; then
        echo 0
    else
        echo $1
    fi
}

#file=oneSuiteOfCards.txt
file=deckOfCards.txt
cp $file .swappedDOC
echo -n "Cards are swapping"
for i in `seq 20`; do
    echo -n "."
    vel=`expr $RANDOM % 52 + 1`
    #echo $vel
    cat .swappedDOC | head -n $vel > .a
    cnta=`cat .a | wc -l`
    cat .swappedDOC | tail -n +`expr $vel + 1` > .b
    cntb=`cat .b | wc -l`
    ia=1
    ib=1
    echo -n "" > .swappedDOC
    while [ $ia -le $cnta -o $ib -le $cntb ]; do
        if [ $ia -le $cnta -a $ib -le $cntb ]; then
            if [ `expr $RANDOM % 100` -lt 50 ]; then
                cat .a | head -n $ia | tail -n 1 >> .swappedDOC
                ia=`expr $ia + 1`
            else
                cat .b | head -n $ib | tail -n 1 >> .swappedDOC
                ib=`expr $ib + 1`
            fi
        else
            cat .a | tail -n +$ia >> .swappedDOC
            ia=`expr $cnta + 1`
            cat .b | tail -n +$ib >> .swappedDOC
            ib=`expr $cntb + 1`
        fi
    done
done
echo ""
rm .a
rm .b
#cat .swappedDOC



cat .swappedDOC | head -n 1 > .player
mv .swappedDOC .swappedDOC~ && cat .swappedDOC~ | tail -n +2 >> .swappedDOC && rm .swappedDOC~

cat .swappedDOC | head -n 1 > .bank
mv .swappedDOC .swappedDOC~ && cat .swappedDOC~ | tail -n +2 >> .swappedDOC && rm .swappedDOC~

echo "You can see this card at Bank : `echo -n '[\"' && ( cat .bank | tr '\n' ',' | sed 's/,$//' || sed 's/,/\",\"/g' ) && echo -n '\"]'`"
echo "  Score: `countScore .bank`"

cat .swappedDOC | head -n 1 >> .player
mv .swappedDOC .swappedDOC~ && cat .swappedDOC~ | tail -n +2 >> .swappedDOC && rm .swappedDOC~

cat .swappedDOC | head -n 1 > .bank
mv .swappedDOC .swappedDOC~ && cat .swappedDOC~ | tail -n +2 >> .swappedDOC && rm .swappedDOC~

while
    sz=`countScore .player`
    echo "Cards of Player :`echo -n '[\"' && ( cat .player | tr '\n' ',' | sed 's/,$//' || sed 's/,/\",\"/g' ) && echo -n '\"]'`"
    echo "  Total score: $sz"
    if [ $sz -gt 21 ]; then
        val="n"
    else
        echo -n "Do you hit one more card? (y/N):"
        read val
    fi
[ "$val" = "y" ]; do
    cat .swappedDOC | head -n 1 >> .player
    mv .swappedDOC .swappedDOC~ && cat .swappedDOC~ | tail -n +2 >> .swappedDOC && rm .swappedDOC~
done
#    let jatekPakli=playsPlayer (player2, swappedDOC5)
#    let player3 = fst jatekPakli
#    let swappedDOC6 = snd jatekPakli

playerScore=`countScore .player`
playerScoreFinal=`finalScore $playerScore`
echo "Cards of Player :`echo -n '[\"' && ( cat .player | tr '\n' ',' | sed 's/,$//' || sed 's/,/\",\"/g' ) && echo -n '\"]'`"
echo "  Total score: $playerScore, final score: $playerScoreFinal"

while [ `countScore .bank` -le 16 ]; do
    cat .swappedDOC | head -n 1 >> .bank
    mv .swappedDOC .swappedDOC~ && cat .swappedDOC~ | tail -n +2 >> .swappedDOC && rm .swappedDOC~
done

bankScore=`countScore .bank`
bankScoreFinal=`finalScore $bankScore`
echo "Cards of Bank : `echo -n '[\"' && ( cat .bank | tr '\n' ',' | sed 's/,$//' || sed 's/,/\",\"/g' ) && echo -n '\"]'`"
echo "  Total score: $bankScore, final score: $bankScoreFinal"


if [ $playerScoreFinal -eq 21 -a $bankScoreFinal -lt 21 ]; then
    echo "BLACKJACK Win - 3:2"
elif [ $playerScoreFinal -eq $bankScoreFinal -a $playerScoreFinal -gt 0 ]; then
    echo "PUSH Get back - 1:1"
elif [ $playerScoreFinal -gt $bankScoreFinal ]; then
    echo "BUST Win - 2:1"
else
    echo "YOU LOST - 0:1"
fi

rm .swappedDOC
rm .player
rm .bank
