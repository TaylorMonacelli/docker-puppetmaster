#!/bin/bash -e

sudo /etc/init.d/puppetmaster stop
sudo /etc/init.d/puppetmaster start

sudo python -c 'import ConfigParser;conf="/etc/puppet/puppet.conf";c=ConfigParser.ConfigParser();c.read(conf);c.has_option("main","manifest") and c.remove_option("main","manifest");c.set("main","server","docker.streambox.com");c.set("main","certname","docker.streambox.com");cfgfile=open(conf, "wb");c.write(cfgfile);cfgfile.close();'

sudo puppet cert sign --all
sudo puppet cert clean --all

sudo puppet resource service puppet ensure=stopped
sudo puppet resource service nginx ensure=stopped

sudo puppet config print ssldir --section master
sudo ls -la $(sudo puppet config print ssldir --section master)
sudo rm -rf $(sudo puppet config print ssldir --section master)

sudo puppet cert sign --all
sudo puppet cert clean --all

sudo puppet cert list -a
sudo /etc/init.d/puppetmaster stop
sudo /etc/init.d/puppetmaster start
sudo puppet resource service puppet ensure=running
