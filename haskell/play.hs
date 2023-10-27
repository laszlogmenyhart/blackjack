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

osszefuz :: [a] -> [a] -> [a]
osszefuz [] []  = []
osszefuz a [] = a
osszefuz [] b = b
osszefuz (a:as) (b:bs) = do
    let vel = veletlenSzam 1 100
    {-if ( unsafePerformIO vel ) < 50-}
    if vel < 50
        then [a] ++ [b] ++ ( osszefuz as bs ) 
        else [b] ++ [a] ++ ( osszefuz as bs ) 

{-
osszefuz :: [a] -> [a] -> [a]
osszefuz (_,_) = []
osszefuz (a,) = a
osszefuz (,b) = b
osszefuz (a,b) = do
    if (length a == 0) && (length b == 0)
        then []
    else if (length a == 0)
        then b
    else if (length b == 0)
        then a
    else osszefuz a b
-}

keverEgy :: [a] -> [a]
keverEgy (x) = do
    let vel = veletlenSzam 1 52
    {-let spl = splitAt ( unsafePerformIO vel ) x-}
    let spl = Data.List.splitAt vel x
    osszefuz (fst spl) (snd spl)

{-}
keverEgy :: [a] -> IO [a]
keverEgy (x:xs) = xs ++ [x]
keverEgy (x) = do
    vel <- veletlenSzam 1 52
    let vag=splitAt vel x
    print $ vag
-}
    {-}
    let e=head vag
    e
    print vag
    let b=last vag
    osszetesz a b -}
    


kever :: Int -> [a] -> [a]
kever 0 x = x
kever db x = kever ( db - 1 ) ( keverEgy x )

kever2 :: (Int , [a]) -> [a]
kever2 (0,x) = x
kever2 (db,x) = kever2 (( db - 1 ),( keverEgy x ))

{-
myFunc :: String -> [a]
myFunc x = do {
    let a = 1:2:[]
    a
}
-}

{-}
huzas :: [a] -> (String, [a])
huzas [x] = (head x, tail x)
-}

veletlenSzam :: Int -> Int -> Int
veletlenSzam x y = unsafePerformIO ( getStdRandom ( randomR (x,y) ) )

veletlenSzam2 :: (Int,Int) -> Int
veletlenSzam2 (x,y) = unsafePerformIO ( getStdRandom ( randomR (x,y) ) )

huzolMeg :: [Text] -> IO String
huzolMeg x = do
    {-}
    let x2=x
    -}
    putStrLn ("A paklid jelenleg: " ++ show x)
    putStrLn ("Huzol meg? (y/N):")
    line <- getLine
    return line

jatszikJatekos :: ([Text], [Text]) -> ([Text], [Text])
jatszikJatekos (j, m)
    | (unsafePerformIO ( huzolMeg j )) == "y" = jatszikJatekos ( j ++ [ (Data.List.head m) ] , Data.List.tail m )
    | otherwise = (j,m)

{-}
proba :: [a] -> IO Int
proba x = do
    putStrLn ("x: " ++ show x)
    return 42
-}

myfnc :: Text.Text -> Int
myfnc a = stringToInt (Data.List.last (Data.List.Split.splitOn ";" (Data.Text.unpack a)))

pluszSzam11v1 :: Int -> Int -> Int
pluszSzam11v1 a b
    | (b==11) && (a+b>21) = a + 1
    | otherwise = a + b

jatszikBank :: ([Text.Text], [Text.Text]) -> ([Text.Text], [Text.Text])
jatszikBank (b, m)
        | (szamol b) <= 16  = jatszikBank ( b ++ [ (Data.List.head m) ] , Data.List.tail m )
        | otherwise = (b, m)


szamol :: [Text] -> Int
szamol [] = 0
szamol b = Data.List.foldl pluszSzam11v1 0 (sort (Data.List.map myfnc b))

vegpont :: Int -> Int
vegpont x
    | x > 21    = 0
    | otherwise = x

main :: IO()
main = do
    {-}
    let s = "1234"
    let result = stringToInt s
    putStrLn (show result)
    let ossz = result + 2
    print $ ossz
    -}

    pakli <- fmap Text.lines (Text.readFile "deckOfCards.txt")
    {-}
    putStrLn ("Pakli: " ++ show pakli)
    let ketto = splitAt vel ls
    -}

{-}
    x <- veletlenSzam 1 10
    print x
-}
    {-print $ veletlenSzam    -}

    let kp=kever 100 pakli
    print $ kp
    {-}
    print $ kever2 (1,pakli)
    print $ ( Data.List.head kp , Data.List.tail kp )
    -}


    let jatekos = [ (Data.List.head kp) ]
    let kp2 = Data.List.tail kp
    {-}
    print $ jatekos
    print $ kp2
    -}

    let bank = [ (Data.List.head kp2) ]
    let kp3 = Data.List.tail kp2

    let jatekos2 = jatekos ++ [ (Data.List.head kp3) ]
    let kp4 = Data.List.tail kp3

    putStrLn ("Bank   : " ++ show bank)
    {-}
    putStrLn ("Jatekos: " ++ show jatekos2)
    -}

    let bank2 = bank ++ [ (Data.List.head kp4) ]
    let kp5 = Data.List.tail kp4

    let jatekPakli=jatszikJatekos (jatekos2, kp5)
    let jatekos3 = fst jatekPakli
    putStrLn ("jatekosPakli   : " ++ show jatekos3)
    let kp6 = snd jatekPakli

    {-}
    let bankPakli=unsafePerformIO ( jatszikBank (bank2,kp6) )
    -}

    let bankPakli=jatszikBank (bank2,kp6)
    {-}
    putStrLn ("bankPakli   : " ++ show bankPakli)
    -}
    let bank3 = fst bankPakli
    putStrLn ("bankPakli   : " ++ show bank3)
    let kp7 = snd bankPakli

    let pontJatekos=szamol jatekos3
    let pontBank=szamol bank3

    let pontBankVegso = vegpont pontBank
    let pontJatekosVegso = vegpont pontJatekos

    if ((pontJatekosVegso == 21) && (pontBankVegso < 21)) then
        putStrLn ("BLACKJACK Nyeremény 3:2")
    else if (pontJatekosVegso == pontBankVegso) then
        putStrLn ("PUSH Visszajár a tét 1:1")
    else if (pontJatekosVegso > pontBankVegso) then
        putStrLn ("BUST Nyeremeny 2:1")
    else
        putStrLn ("VESZTETTEL")

    {-}
    huzas kls
    let huzott = huzas kls
    print $ huzott
    kls <- snd huzott
    jatekos <- jatekos ++ [(fst huzott)]

    print $ jatekos
    -}

    {-
    print $ keverEgy ls
    let kls = kever x ls
    let kls = keverEgy ls
    print $ kls
    -}
    

    {-}
    let aaa =  myFunc "abc"
    print $ aaa
    -}
    