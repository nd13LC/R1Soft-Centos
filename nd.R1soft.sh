#!/bin/bash

echo -e "Pe ce server de restore vrei sa adaugi? (Ex.: 1,2,3,5,6,7)\n"
read SR;


touch /etc/yum.repos.d/r1soft.repo

echo -e  '[r1soft]\n\nname=R1Soft Repository Server\n\nbaseurl=http://repo.r1soft.com/yum/stable/$basearch/\n\nenabled=1\n\ngpgcheck=0\n' > /etc/yum.repos.d/r1soft.repo

yum -y install r1soft-cdp-enterprise-agent

yum -y update kernel; yum -y install kernel-devel kernel-headers

/usr/bin/r1soft-setup --get-module

/etc/init.d/cdp-agent restart

r1soft-setup --get-key restore"$SR".easyhost.com || r1soft-setup --get-key http://restore"$SR".easyhost.com

ping restore"$SR".easyhost.com -c 3

if test -e /etc/csf/csf.allow;
	then			
		ping restore"$SR".easyhost.com -c 1 | grep "PING " | awk '{print $3}' | sed -e 's/^(//' -e 's/)$//' >> /etc/csf/csf.allow
		
		csf -r
	else 
		echo "N-ai CSF"
		exit
fi

chkconfig --levels 345 cdp-agent on


echo "Ai configurat R1Soft pe server pentru restore"$SR".easyhost.com! "	
