#! /bin/bash
chown -R postgres:root /var/lib/postgresql/ && /etc/init.d/postgresql start && msfdb init
