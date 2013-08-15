#
# == Class: awstats::install
#
# Install awstats
#
class awstats::install {

    package { 'awstats-awstats':
        name => 'awstats',
        ensure => installed,
    }
}
