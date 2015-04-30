#
# == Class: awstats::install
#
# Install awstats
#
class awstats::install inherits awstats::params {

    package { 'awstats-awstats':
        ensure => installed,
        name   => 'awstats',
    }
}
