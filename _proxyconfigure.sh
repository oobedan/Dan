#Config Files
#--------------------------------------
#Squid Config /etc/squid/squid.conf

#
#auth_param negotiate program /usr/lib64/squid/negotiate_kerberos_auth -i -d -k /etc/squid/squid.keytab -s HTTP/proxy.fqdn@ADDOMAIN.fqdn
#
#acl kerb-auth proxy_auth REQUIRED
#
#http_access deny !kerb-auth
#http_access allow kerb-auth
#http_access deny all

#--------------------------------------

#--------------------------------------
#chrony config

#pool timehost1.fqdn iburst
#pool timehost1.fqdn iburst iburst
#--------------------------------------

#--------------------------------------
#samba config /etc/samba.smb.conf

#[global]
#        workgroup = DOMAIN
#        client signing = yes
#        client use spnego = yes
#        kerberos method = secrets and keytab
#        log file = /var/log/samba/%m.log
#        password server = ADSERVER1.fqdn,ADSERVER2.fqdn
#        realm = ADDOMAIN.FQDN
#        security = ads
#--------------------------------------

#--------------------------------------
#Kerberos config /etc/krb5.conf
#[logging]
#    default = FILE:/var/log/krb5libs.log
#    kdc = FILE:/var/log/krb5kdc.log
#    admin_server = FILE:/var/log/kadmind.log
#
#[libdefaults]
#   dns_lookup_realm = false
#    ticket_lifetime = 24h
#    renew_lifetime = 7d
#    forwardable = true
#    rdns = false
#    pkinit_anchors = FILE:/etc/pki/tls/certs/ca-bundle.crt
#    spake_preauth_groups = edwards25519
#    default_realm = ADDOMAIN.FQDN
#    default_ccache_name = KEYRING:persistent:%{uid}

#--------------------------------------

#--------------------------------------
# sssd.conf /etc/sssd/sssd.conf
#
#[sssd]
#config_file_version = 2
#domains = ADDOMAIN.FQDN
#services = nss, pam
#
#[domain/ADDOMAIN.FQDN]
#id_provider = ad
#chpass_provider = ad
#access_provider = ad
#--------------------------------------


#--------------------------------------
# sudoers /etc/sudoers
# > add below %wheel group
# %DOMAIN\\rol-admingroupname  ALL=(ALL)       ALL
#--------------------------------------

#--------------------------------------
# SSHD /etc/ssh/sshd_config
# find them in VIM using / then insert mode
#   LoginGraceTime 60
#   HostbasedAuthentication no
#   IgnoreRhosts yes
#   PermitRootLogin no
#   PermitEmptyPasswords no
#   AllowTCPForwarding no
#   GatewayPorts no
#   X11Forwarding no

#--------------------------------------


#======================================START=============================================

#Configure Chrony (Time Synchronisation).

#1. > systemctl status chronyd
#2. >  sudo vim /etc/chrony.conf
#3. > sudo systemctl stop chronyd
#4. > sudo systemctl start chronyd
#5. > systemctl status chronyd 
#6. > chronyc tracking


#Configure Domain Join SSSD and SAMBA (https://access.redhat.com/articles/3023951)

#1. > sudo yum install krb5-workstation samba-common-tools sssd-ad
#2. > sudo vim /etc/krb5.conf
#3.	> default_realm = ADDOMAIN.FQDN
#4. > sudo vim /etc/samba/smb.conf
#5. > sudo kinit <username> e.g kinit da.1234w
#6. > sudo net ads join -k

# In AD Users and Computers.
# Move Computer to RHEL  OU and Create DNS records (A record for each host)

#Install and Configure Squid:

#1. > sudo yum install squid
#2. > sudo vim /etc/squid/squid.conf
#3. > sudo firewall-cmd --permanent --add-port=8080/tcp
#4. > sudo firewall-cmd --reload
#5. > sudo systemctl enable --now squid

#Configure Kerberos


# Step is one Windows Server with DA a user (Windows jump host or DC)
#1. # Create a user account in domain, set password not to expire
#2. # ktpass -out c:\fileName.keytab -princ HTTP/proxy.fqdn@DOMAIN.FQDN -mapuser svc.account@domain.fqdn -pass <pass> -crypto AES256-SHA1 -ptype KRB5_NT_PRINCIPAL
#3. Upload to /var/tmp via SCP.

# jump back to Linux host
#4. > sudo mv /var/tmp/squid.keytab /etc/squid/squid.keytab
#5. > sudo chown squid:squid /etc/squid/squid.keytab
#6. > sudo chmod 400 /etc/squid/squid.keytab
#7. > sudo vim /etc/squid/squid.conf
#8. > sudo systemctl restart squid

#sssd for Kerb Auth to SSH
#1. > sudo yum install oddjob-mkhomedir
#2. > sudo vim /etc/sssd/sssd.conf     # update file
#3. > sudo chmod 600 /etc/sssd/sssd.conf
#4. > sudo authconfig --update --enablesssd --enablesssdauth --enablemkhomedir
#5. > sudo systemctl status sssd.service


#Configure SUDOERs.
#1. > sudo visudo /etc/sudoers   # add rol-adminaccount
 
#Harden SSH.
#1. > /etc/ssh/sshd_config      # add required lines from config file to Match ISM Controls


#Configure ATP and Patching.

