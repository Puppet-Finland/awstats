#
# == Class: awstats::patch::buildstaticpages
#
# Patch awstats_buildstaticpages.pl. Currently this is needed to fix this bug:
#
# <http://sourceforge.net/p/awstats/bugs/846/>
#
# This bug is present in awstats 7.0 bundled with Ubuntu 12.04.
#
class awstats::patch::buildstaticpages inherits awstats::params {

    file { 'awstats-awstats_buildstaticpages.pl':
        ensure  => present,
        name    => $::awstats::params::awstats_buildstaticpages,
        content => template('awstats/awstats_buildstaticpages.pl.erb'),
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        mode    => '0755',
        require => Class['awstats::install'],
    }
}
