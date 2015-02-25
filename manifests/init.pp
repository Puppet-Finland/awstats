#
# == Class: awstats
#
# Install and configure awstats.
#
# Currently this module does not integrate with webserver access controls. 
# Typically you'd add something like this to nginx site:
#
#   location /statistics/ {
#       alias /var/cache/awstats/;
#       auth_basic "Restricted";
#       auth_basic_user_file /etc/nginx/htpasswd/awstats;
#       autoindex on;
#   }
#
# Or to an Apache2 site:
#
#   Alias /statistics /var/cache/awstats
#   <Directory /var/cache/awstats>
#       Options Indexes
#       AuthName Login
#       AuthType Basic
#       AuthUserFile /etc/apache2/htusers
#       Require valid-user
#       Order allow,deny
#       Allow from 10.0.0.0/8
#   </Directory>
#
# Debian "awstats" package automatically installs cronjobs that update the 
# statistics. However, it's quite possible that the default cronjobs (in 
# /etc/cron.d/awstats) lack permissions to read Apache2's logfile. In this case 
# the cronjobs have to be modified to run as root instead of www-data. An 
# alternative is to use awstats::site to define the cronjobs.
#
# Note that at least on Debian the awstats update script assume all .conf files 
# have SiteDomain defined in them. As this module does not modify the default 
# awstats.conf file, awstats will start sending useless warnings unless 
# awstats.conf.local is added with contents like this:
#
#   SiteDomain="dummy"
#
# Both of the above two problems should definitely be fixed in this module.
#
# == Parameters
#
# [*manage*]
#   Manage awstats using Puppet. Valid values 'yes' (default) and 'no'.
# [*htmlbasedir*]
#   The directory under which each per-site report directory is placed. Defaults 
#   to '', which means that no reports are generated or updated via cron. See 
#   awstats::site for more details on advantages and limitations of this 
#   cron-based approach.
# [*dirdata*]
#   There directory where data files are stored. These data files are used to 
#   generate the HTML reports. Defaults to '/var/cache/awstats', which is valid 
#   for Debian.
# [*sites*]
#   A hash of awstats::site resources to realize.
#
# == Examples
#
#   class { 'awstats':
#       htmlbasedir => '/var/lib/awstats',
#       dirdata => '/var/lib/awstats',
#   }
#
#   awstats::site { 'site.domain.com':
#       sitedomain => 'www.domain.com',
#       logfile => '/var/log/nginx/site.domain.com.access.log',
#       minute => '15',
#       hour => '00',
#   }
#
# == Authors
#
# Samuli Seppänen <samuli@openvpn.net>
#
# == License
#
# BSD-license. See file LICENSE for details.
#
class awstats
(
    $manage = 'yes',
    $htmlbasedir = '',
    $dirdata = '/var/cache/awstats',
    $sites = {}
)
{

if $manage == 'yes' {

    include awstats::install

    class { 'awstats::config':
        htmlbasedir => $htmlbasedir,
        dirdata => $dirdata,
    }

    create_resources('awstats::site', $sites)
}
}
