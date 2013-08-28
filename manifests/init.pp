#
# == Class: awstats
#
# Install and configure awstats.
#
# Currently this module does not integrate with webserver access controls.
# Updating the reports via cron is supported, but has certain inherent
# limitations discussed in detail in the awstats::site define.
#
# == Parameters
#
# [*htmlbasedir*]
#   The directory under which each per-site report directory is placed. Defaults 
#   to '', which means that no reports are generated or updated via cron. See 
#   awstats::site for more details on advantages and limitations of this 
#   cron-based approach.
# [*dirdata*]
#   There directory where data files are stored. These data files are used to 
#   generate the HTML reports. Defaults to '/var/cache/awstats', which is valid 
#   for Debian.
#
# == Examples
#
# class { 'awstats':
#   htmlbasedir => '/var/lib/awstats',
#   dirdata => '/var/lib/awstats',
# }
#
# awstats::site { 'site.domain.com':
#   sitedomain => 'www.domain.com',
#   logfile => '/var/log/nginx/site.domain.com.access.log',
#   minute => '15',
#   hour => '00',
# }
#
# == Authors
#
# Samuli Seppänen <samuli@openvpn.net>
#
# == License
#
# BSD-lisence
# See file LICENSE for details
#
class awstats
(
    $htmlbasedir = '',
    $dirdata = '/var/cache/awstats',
)
{
    include awstats::install

    class { 'awstats::config':
        htmlbasedir => $htmlbasedir,
        dirdata => $dirdata,
    }
}
