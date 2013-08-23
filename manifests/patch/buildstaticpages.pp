#
# == Class: awstats::patch::buildstaticpages
#
# Patch awstats_buildstaticpages.pl. Currently this is needed to fix this bug:
#
# <http://sourceforge.net/p/awstats/bugs/846/>
#
# This bug is present in awstats 7.0 bundled with Ubuntu 12.04.
#
class awstats::patch::buildstaticpages {

    include awstats::params

    file { 'awstats-awstats_buildstaticpages.pl':
        ensure => present,
        name => "${::awstats::params::awstats_buildstaticpages}",
        content => template('awstats/awstats_buildstaticpages.pl.erb'),
        owner => root,
        group => root,
        mode => 755,
        require => Class['awstats::install'],
    }
}
