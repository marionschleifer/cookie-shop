{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_haskookie (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/marion/.cabal/bin"
libdir     = "/Users/marion/.cabal/lib/x86_64-osx-ghc-8.8.3/haskookie-0.1.0.0-inplace-haskookie"
dynlibdir  = "/Users/marion/.cabal/lib/x86_64-osx-ghc-8.8.3"
datadir    = "/Users/marion/.cabal/share/x86_64-osx-ghc-8.8.3/haskookie-0.1.0.0"
libexecdir = "/Users/marion/.cabal/libexec/x86_64-osx-ghc-8.8.3/haskookie-0.1.0.0"
sysconfdir = "/Users/marion/.cabal/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "haskookie_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "haskookie_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "haskookie_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "haskookie_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "haskookie_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "haskookie_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
