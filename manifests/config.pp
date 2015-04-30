#
# == Class: awstats::config
#
# Configure awstats. Currently this class is basically empty, and only exists to 
# allow access to a few variables used by awstats::site instances.
#
class awstats::config
(
    $htmlbasedir,
    $dirdata

) inherits awstats::params
{
    # Add content if necessary
}
