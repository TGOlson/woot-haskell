-- utility for building WStrings

module Woot.WString.Builder where

import Woot.WString
import Woot.WChar

endOfBufferWCharId :: WCharId
endOfBufferWCharId = WCharId (-1, -1)

makeEmptyChar :: WCharId -> WCharId -> WCharId -> WChar
makeEmptyChar wid prev next = WChar wid False '_' prev next

beginningChar :: WChar
beginningChar = makeEmptyChar (WCharId (0, 0)) endOfBufferWCharId (WCharId (0, 1))

endingChar :: WChar
endingChar = makeEmptyChar (WCharId (0, 1)) (WCharId (0, 0)) endOfBufferWCharId


-- try array for inserts
initialString :: WString
initialString = WString [beginningChar, endingChar]
