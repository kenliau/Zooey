Schemas
=======

Videos
------
* id
* filename
* path\_to\_file
* label
* size
* duration
* frame\_distance
* frame\_length
* created\_at
* updated\_at

Jobs
----
* id
* video\_id
* video\_resolution
* h264\_profile
* h264\_quality
* audio\_codec
* audio\_bitrate
* audio\_volume
* mux\_rate
* created\_at
* updated\_at
* finished\_at

Statuses
--------
* id
* job\_id
* chunks
* pull\_start\_time
* pull\_finish\_time
* chunker\_start\_time
* chunker\_finish\_time
* tcoder\_start\_time
* tcoder\_finish\_time
* merger\_start\_time
* merger\_finish\_time
* chunk\_tcode\_time
* chunks\_tcode\_sofar
* created\_at
* updated\_at
