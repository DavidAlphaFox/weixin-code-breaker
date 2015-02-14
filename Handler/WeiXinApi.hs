{-# LANGUAGE OverloadedStrings #-}
module Handler.WeiXinApi where

import Import
import qualified Data.Text as T
import Lib.WxMessage
import Data.Time

postWeiXinApiR :: Handler TypedContent
postWeiXinApiR = do
    ([(reqContent, _)], _) <- runRequestBody
    case parseWxTextMessage $ T.unpack reqContent of
      Left _ -> 
          return $ TypedContent "text/html" $ toContent $ T.pack ""
      Right message ->
            do currTime <- liftIO getCurrentTime
               let timeNow = floor $ utctDayTime currTime :: Int                   
                   resp = WxTextMsg (fromUser message)  (toUser message) 
                                    timeNow (T.pack "text") (T.pack "Hello") (msgId message)
               return $ TypedContent "text/html" $ toContent $ T.pack $ renderWxTextMessage resp
