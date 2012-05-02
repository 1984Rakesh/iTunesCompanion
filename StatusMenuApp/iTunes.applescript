#!/bin/sh

#  iTunes.applescript
#  StatusMenuApp
#
#  Created by Rakesh Patole on 02/05/12.
#  Copyright (c) 2012 Diaspark. All rights reserved.

script iTunes
    
    to checkItunesIsActive()
        tell application "System Events" to return (exists (some process whose name is "iTunes"))
    end checkItunesIsActive
    
    on playerStatus()
        (*if my checkItunesIsActive is true then*)
            tell application "iTunes"
                return get player state
            end tell
        (*end if*)
    end playerStatus
    
    on playerPosition()
        if my checkItunesIsActive is true then
            tell application "iTunes"
                return player position
            end tell
        end if
    end playerPosition
    
    on playorpause()
        tell application "iTunes"
            playpause
        end tell
    end playorpause

    on currentTrackArtWork()
        tell application "iTunes"
            return get data of artwork 1 of current track
        end tell
    end currentTrackArtWork

end script
