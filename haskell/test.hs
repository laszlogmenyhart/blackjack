import qualified Data.Text    as Text
import qualified Data.Text.IO as Text
import System.Random
import System.IO.Unsafe
import Data.List
import Data.List.Split
import Data.Text
import Text.Read (readMaybe)
import Data.Maybe (fromMaybe)


vegpont2 :: Int -> IO Int
vegpont2 x = do
    putStrLn ("vegpont2=" ++ show x)
    if (x > 21) then
        return 0
    else
        return x

main :: IO()
main = do
    let a = unsafePerformIO ( vegpont2 23 )
    putStrLn ("a=" ++ show a)
    let b = unsafePerformIO ( vegpont2 20 )
    putStrLn ("a=" ++ show b)
    putStrLn ("a=" ++ show b)
    {-}
    b <- vegpont 22
    -}

