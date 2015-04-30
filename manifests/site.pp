#
# == Define: awstats::site
#
# Configure awstats for a particular site. Most parameters are derived from the 
# awstats options explained here:
#
# <http://awstats.sourceforge.net/docs/awstats_config.html>
#
# Note that the cronjob for updating the reports is only activated if 
# $htmlbasedir is defined for the awstats class.
#
# == Parameters
#
# [*site*]
#   Name of this site. Defaults to $title. For example: "images.domain.com".
# [*sitedomain*]
#   Name of the "main intranet webserver used to reach the web site". For 
#   example "domain.com".
# [*hostaliases*]
#   List of domain names, addresses and virtual host definitions that can be 
#   used to access this site (as a string). Defaults to $title.
# [*logfile*]
#   Location of the logfile. This depends on the operating system, webserver 
#   type and webserver configuration and can't be reliably guessed.
# [*logtype*]
#   Type of the log. Defaults to 'W' (webserver log). Other options are listed 
#   in awstats documentation (link above).
# [*logformat*]
#   Logfile format. Defaults to '1'. Other options are listed in awstats 
#   documentation (link above).
# [*hour*]
#   Hour(s) when the awstats pages are updated. Defaults to '*' which means that 
#   reports are updated every hour. Note that this setting has no effect unless 
#   $htmlbasedir is defined for the awstats class.
# [*minute*]
#   Minute(s) when the awstats pages are updated. Defaults to '10'. Note that 
#   this setting has no effect unless $htmlbasedir is defined for the awstats class.
# [*email*]
#   Email address where notifications are sent. Defaults to top-scope variable
#   $::servermonitor.
#
define awstats::site
(
    $sitedomain,
    $logfile,
    $site = $title,
    $hostaliases = $title,
    $logtype = 'W',
    $logformat = '1',
    $hour='*',
    $minute='10',
    $email = $::servermonitor
)
{
    include ::awstats::params

    file { "awstats-awstats.${site}.conf":
        ensure  => present,
        name    => "/etc/awstats/awstats.${site}.conf",
        content => template('awstats/awstats.model.conf.erb'),
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        mode    => '0644',
        require => Class['awstats::install'],
    }

    # Update statistics for this site periodically. Preferably this should be 
    # done in logrotate prerotate function, but logrotate setups differ widely 
    # between operating systems, so creating a generic mechanism for handling 
    # prerotate would be very heavy and error-prone. For example, Debian has a 
    # built-in, cron-based "prerotation" script, buildstaticpages.sh, that 
    # launches every night. RHEL/CentOS, on the other hand, use anacron and the 
    # logrotate runs can occur at any time between 3 and 22.
    #
    # The downside for any cron-based approach is that the produced statistics 
    # will be missing some data. The amount of error can be reduced by running 
    # the update cronjob often.
    #
    # Note this cronjob is only activate if $htmlbasedir is specifically defined 
    # for the awstats class.
    #
    if $::awstats::config::htmlbasedir {
        cron { "awstats-${site}-cron":
            command     => "nice -n 19 ${::awstats::params::awstats_buildstaticpages} -update -config=${site} -awstatsprog=${::awstats::params::awstats} -dir=${::awstats::config::htmlbasedir}/${site}/",
            user        => $::os::params::adminuser,
            hour        => $hour,
            minute      => $minute,
            weekday     => '*',
            environment => "MAILTO=${email}",
        }
    } else {
        # We were not told where to put the reports, so we don't generate them
    }
}
