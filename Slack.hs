{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Slack where

import qualified Data.Aeson as A
import Data.Function ((&))
import qualified Data.Map.Strict as Map
import qualified Data.Text as T
import qualified Data.Text.Encoding as TextEncoding
import GHC.Generics (Generic)
import qualified Network.HTTP.Simple as HTTP
import qualified Data.Text.Lazy as TL

makeSlackRequest :: [(TL.Text, TL.Text)] -> IO T.Text
makeSlackRequest orderParamsDict = do
    baseRequest <- HTTP.parseRequest "https://slack.com/api/chat.postMessage"
    let token = "idToken"
    let bearerToken = TextEncoding.encodeUtf8 $ "Bearer " <> token
        request =
            baseRequest
                & HTTP.setRequestBodyJSON payload
                & HTTP.setRequestMethod "POST"
                & HTTP.addRequestHeader "Authorization" bearerToken
    response <- HTTP.httpBS request
    HTTP.getResponseBody response
        & TextEncoding.decodeUtf8
        & return
    where
        channelId = "channelId"
        payload :: MessagePayload
        payload = MessagePayload channelId messageBody
        messageBody = T.pack $ show orderParamsDict

data MessagePayload = MessagePayload
    { channel :: T.Text
    , text :: T.Text
    }
    deriving (Show, Eq, Ord, Generic)

instance A.ToJSON MessagePayload
