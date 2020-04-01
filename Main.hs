{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified Web.Scotty as Scotty
import qualified Network.Wai.Middleware.Static as Static
import qualified Network.Wai.Middleware.RequestLogger as Log
import qualified Network.Wai.Middleware.HttpAuth as Auth
import qualified Data.Text.Lazy as TL
import qualified Slack
import Control.Monad.Trans (liftIO)

import Data.Monoid (mconcat)

main :: IO ()
main = Scotty.scotty 3000 $ do

    Scotty.middleware $ Auth.basicAuth (\u p -> return $ u == "michael" && p == "mypass") "My Realm"
    Scotty.middleware $ Static.staticPolicy (Static.addBase "site")
    Scotty.middleware Log.logStdoutDev


    Scotty.get "/" $ do
        Scotty.file "site/index.html"

    Scotty.post "/icanhas" $ do
        params <- Scotty.params 
        _ <- liftIO $ Slack.makeSlackRequest params
        Scotty.html $ "<h1>HUGE SUCCESS<h1/>" <> TL.pack (show params)

    -- Scotty.get "/:word" $ do
    --     beam <- Scotty.param "word"
    --     Scotty.html $ mconcat ["<h1>Scotty, ", beam, " me up!</h1>"]
