module Banner
  ( printBanner
  ) where

import Data.Text qualified as T
import Data.Text.IO qualified as T
import Himari

-- | Print banner.
printBanner :: (MonadIO m) => m ()
printBanner = liftIO $ T.putStrLn banner

banner :: Text
banner =
  T.unlines
    [ "╔═════════════════════════════════════════════════════════════════════╗"
    , "║ Millennium Science School - Paranormal Affairs Dept.                ║"
    , "║ Anomaly Monitoring System                                           ║"
    , "║                                                                     ║"
    , "║ I am the all-knowing Himari! Leave system monitoring to me, Sensei! ║"
    , "║                                                                     ║"
    , "╚═════════════════════════════════════════════════════════════════════╝"
    ]
