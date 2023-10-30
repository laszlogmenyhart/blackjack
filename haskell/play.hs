import qualified Data.Text    as Text
import qualified Data.Text.IO as Text
import System.Random
import System.IO.Unsafe
import Data.List
import Data.List.Split
import Data.Text
import Text.Read (readMaybe)
import Data.Maybe (fromMaybe)


stringToInt :: String -> Int
stringToInt s = fromMaybe (error "") (readMaybe s)

compose :: [a] -> [a] -> [a]
compose [] []  = []
compose a [] = a
compose [] b = b
compose (a:as) (b:bs) = do
    let vel = randomNumber 1 100
    if vel < 50
        then [a] ++ ( compose as ([b] ++ bs) ) 
        else [b] ++ ( compose ([a] ++ as) bs ) 

swapOnce :: [a] -> [a]
swapOnce (x) = do
    let vel = randomNumber 1 52
    let spl = Data.List.splitAt vel x
    compose (fst spl) (snd spl)

swap :: Int -> [a] -> [a]
swap 0 x = x
swap db x = swap ( db - 1 ) ( swapOnce x )

{-}
swap2 :: (Int , [a]) -> [a]
swap2 (0,x) = x
swap2 (db,x) = swap2 (( db - 1 ),( swapOnce x ))
-}

randomNumber :: Int -> Int -> Int
randomNumber x y = unsafePerformIO ( getStdRandom ( randomR (x,y) ) )

{-}
randomNumber2 :: (Int,Int) -> Int
randomNumber2 (x,y) = unsafePerformIO ( getStdRandom ( randomR (x,y) ) )
-}

askHitMore :: [Text] -> IO String
askHitMore x = do
    let sc=countScore x
    putStrLn ("Cards of Player: " ++ show x)
    putStrLn ("  Total score: " ++ show sc)
    if (sc > 21) then
        return "n"
    else do
        putStrLn ("Do you hit one more card? (y/N):")
        line <- getLine
        return line

playsPlayer :: ([Text], [Text]) -> ([Text], [Text])
playsPlayer (j, m)
    | (unsafePerformIO ( askHitMore j )) == "y" = playsPlayer ( j ++ [ (Data.List.head m) ] , Data.List.tail m )
    | otherwise = (j,m)

lastPartInt :: Text.Text -> Int
lastPartInt a = stringToInt (Data.List.last (Data.List.Split.splitOn ";" (Data.Text.unpack a)))

plusNumber11o1 :: Int -> Int -> Int
plusNumber11o1 a b
    | (b==11) && (a+b>21) = a + 1
    | otherwise = a + b

playsBank :: ([Text.Text], [Text.Text]) -> ([Text.Text], [Text.Text])
playsBank (b, m)
        | (countScore b) <= 16  = playsBank ( b ++ [ (Data.List.head m) ] , Data.List.tail m )
        | otherwise = (b, m)

countScore :: [Text] -> Int
countScore [] = 0
countScore b = Data.List.foldl plusNumber11o1 0 (sort (Data.List.map lastPartInt b))

finalScore :: Int -> Int
finalScore x
    | x > 21    = 0
    | otherwise = x

main :: IO()
main = do
    deckOfCards <- fmap Text.lines (Text.readFile "deckOfCards.txt")

    let swappedDOC=swap 100 deckOfCards
    {-}
    print $ swappedDOC
    -}
    
    let player = [ (Data.List.head swappedDOC) ]
    let swappedDOC2 = Data.List.tail swappedDOC

    let bank = [ (Data.List.head swappedDOC2) ]
    let swappedDOC3 = Data.List.tail swappedDOC2

    putStrLn ("You can see this card at Bank : " ++ show bank)
    putStrLn ("  Score: " ++ show (countScore bank))

    let player2 = player ++ [ (Data.List.head swappedDOC3) ]
    let swappedDOC4 = Data.List.tail swappedDOC3

    let bank2 = bank ++ [ (Data.List.head swappedDOC4) ]
    let swappedDOC5 = Data.List.tail swappedDOC4

    let playerResult=playsPlayer (player2, swappedDOC5)
    let player3 = fst playerResult
    let swappedDOC6 = snd playerResult
    let playerScore=countScore player3
    let playerScoreFinal = finalScore playerScore

    let bankResult=playsBank (bank2,swappedDOC6)
    let bank3 = fst bankResult
    {-}
    let swappedDOC7 = snd bankResult
    -}
    let bankScore=countScore bank3
    let bankScoreFinal = finalScore bankScore

    let blackjackResult = if ((playerScoreFinal == 21) && (bankScoreFinal < 21))
        then "BLACKJACK Win - 3:2"
        else if ((playerScoreFinal == bankScoreFinal) && (playerScoreFinal > 0))
        then "PUSH Get back - 1:1"
        else if (playerScoreFinal > bankScoreFinal)
        then "BUST Win - 2:1"
        else "YOU LOST - 0:1"

    putStrLn ("Cards of Player : " ++ show player3)
    putStrLn ("  Total score: " ++ show playerScore ++ ", final score: " ++ show playerScoreFinal)
    putStrLn ("Cards of Bank : " ++ show bank3)
    putStrLn ("  Total score: " ++ show bankScore ++ ", final score: " ++ show bankScoreFinal)
    putStrLn (blackjackResult)
