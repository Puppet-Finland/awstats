# awstats

A Puppet module for managing awstats

Note that this module is currently lacking integration with webserver access 
controls.

Some operating systems such as Debian have built-in mechanisms for updating both 
the statistics and the static awstats HTML pages built from those. This module 
provides an optional, generic and cron-based mechanism for doing the same on 
other platforms.

Although this module should work out of the box without any issues, it is 
recommended to bootstrap the awstats database from archived logfiles first. For 
example, on Debian you'd first merge all the existing access logfiles:

  $ nice -n 19 /usr/share/awstats/tools/logresolvemerge.pl \ 
    www.domain.com-access.log* > /tmp/www.domain.com-access-all.log

Then point that site's config (here "/etc/awstats/awstats.www.domain.com.conf") 
to that logfile. Finally, trigger updated of the awstats database manually. In 
standard Debian setup you'd do

  $ su - www-data
  $ nice -n 19 /usr/share/awstats/tools/buildstatic.sh

Once this is finished, you can let Puppet revert the config file back to it's 
correct contents.

# Module usage

* [Class: awstats](manifests/init.pp)
* [Define: awstats::site](manifests/site.pp)

# Dependencies

See [metadata.json](metadata.json).

# Operating system support

This module has been tested on

* Debian 7
* Ubuntu 12.04

It should work on other *NIX-like operating systems with minor modifications.

For details see [params.pp](manifests/params.pp).
