#
# == Class: awstats::params
#
# Defines some variables based on the operating system
#
class awstats::params {

    case $::osfamily {
        'RedHat': {
            $awstats_buildstaticpages = '/usr/bin/awstats_buildstaticpages.pl'
            $awstats = '/var/www/awstats/awstats.pl'
        }
        'Debian': {
            $awstats_buildstaticpages = '/usr/share/awstats/tools/awstats_buildstaticpages.pl'
            $awstats = '/usr/lib/cgi-bin/awstats.pl'
        }
        default: {
            fail("Unsupported OS: ${::osfamily}")
        }
    }
}
