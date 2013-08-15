#
# == Define: awstats::site
#
# Configure awstats for a particular site. All parameters are currently tied to 
# awstats options explained here:
#
# <http://awstats.sourceforge.net/docs/awstats_config.html>
#
# == Parameters
#
# [*site*]
#   Name of this site. Defaults to $title. For example: "images.domain.com".
# [*sitedomain*]
#   Name of the "main intranet webserver used to reach the web site". For 
#   example "domain.com".
# [*logfile*]
#   Location of the logfile. This depends on the operating system, webserver 
#   type and webserver configuration and can't be reliably guessed.
# [*logtype*]
#   Type of the log. Defaults to 'W' (webserver log). Other options are listed 
# in awstats documentation (link above).
# [*logformat*]
#   Logfile format. Defaults to '1'. Other options are listed in awstats 
#   documentation (link above).
#
define awstats::site
(
    $site = $title,
    $sitedomain,
    $logfile,
    $logtype = 'W',
    $logformat = '1',
)
{
    file { "awstats-awstats.${site}.conf":
        name => "/etc/awstats/awstats.${site}.conf",
        ensure => present,
        content => template('awstats/awstats.model.conf.erb'),
        owner => root,
        group => root,
        mode => 644,
        require => Class['awstats::install'],
    }
}
