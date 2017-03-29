module Example.List where

import Prelude
import Data.Array as A
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Class (liftEff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Control.Monad.List.Trans (ListT, runListTRec, iterate, takeWhile)
import Control.MonadZero (guard)

-- based on http://hackage.haskell.org/package/list-transformer
logList :: forall eff.
   ListT (Eff (console :: CONSOLE | eff)) String
-> Eff (console :: CONSOLE | eff) Unit
logList l = runListTRec do
  liftEff $ log "logging listT"
  str <- l
  liftEff $ log str

-- based on https://wiki.haskell.org/ListT_done_right#Sum_of_squares
sumSqrs :: forall eff.
   Int
-> ListT (Eff (console :: CONSOLE | eff)) Unit
sumSqrs n = do
  let
    nats = iterate (add one) zero
    squares = takeWhile (_ <= n) $ map (\x -> x * x) nats
  x <- squares
  y <- squares
  liftEff $ log ("<" <> show x <> "," <> show y <> ">")
  guard $ x + y == n
  liftEff $ log "Sum of squares."

main :: forall eff. Eff (console :: CONSOLE | eff) Unit
main = do
  logList $ A.toUnfoldable ["one", "two", "three"]
  runListTRec $ sumSqrs 10
