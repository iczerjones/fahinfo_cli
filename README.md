# fahinfo_cli
Simple bash shell script Folding@Home info viewer

This script uses bash built-ins and has been tested on bash 4.2.46.

There are two variables that should be adjusted to fit your specific needs:

logroot           ## This is the location of your fahclient log root (ex. /var/lib/fahclient)
update_frequency  ## How often to refresh the info in seconds


The 'display' is formatted such that it should fit nicely even on an 80x25 basic terminal. By default, the fahclient log will provide the last 8 log entries.  This can be updated to increase or decrease the number of shown entries within the fahlog() function. Point values are calculated based on parsing all logs, current and archived. These are the estimated point values from the F@H project servers and will not align with actual points granted.  


Known issues:
- This was built using a 6c/12t i7 processor.  Substantially more cores will expand the used screen space, potentially outside of the 25 row design constraint
- Point values will not match actual awarded points


TODO: 
- Add aggregate or per-core temperature feedback (where applicable)
- Add memory usage
- Add current project info
- Add GPU info
