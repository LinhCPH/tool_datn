#!/bin/bash

BLUE='\033[0;34m'
NC='\033[0m'

version=0

export version

echo -e "${BLUE}Gather Information${NC}"
echo -e "${BLUE}SCAN IP: $target ${NC}"




# Hàm chạy lệnh Nmap và lưu kết quả vào tệp
run_nmap_command() {
    local command=$1
    echo "Running Nmap command: ${BLUE}$command${NC}"
    eval $command | tee -a $result_file  # Chạy lệnh và lưu kết quả vào tệp
}

#----------------------------NMAP COMMAND-------------------------------------
nmap21(){
	 echo "---------------------------Thong tin dich vu FTP---------------------------" >> NmapReports/gather_information_result_$target.txt 
    	 sudo nmap -n -sV -Pn -p21 --script "ftp* and not brute" $target | grep -vE "Starting|Nmap scan report|Host is up|Nmap done|Service detection performed|Please report any incorrect results at" >> NmapReports/gather_information_result_$target.txt
	 
}

nmap22(){
	echo "---------------------------Thong tin dich vu SSH---------------------------" >> NmapReports/gather_information_result_$target.txt
     	sudo nmap $target -Pn -n --open -p22 -sT -script-timeout 20s --script=ssh-hostkey,ssh-auth-methods,ssh-run,sshv1,ssh2-enum-algos --min-hostgroup 100 --scan-delay 5 | grep -vE "Starting|Nmap scan report|Host is up|Nmap done|Service detection performed|Please report any incorrect results at" >> NmapReports/gather_information_result_$target.txt
}

nmap23(){
	echo "---------------------------Thong tin dich vu Telnet---------------------------" >> NmapReports/gather_information_result_$target.txt
    	sudo nmap $target -Pn -n --open -p23 -sT --script-timeout 20s --script=banner,cics-info,cics-enum,cics-user-enum,telnet-encryption,telnet-ntlm-info,tn3270-screen,tso-enum --min-hostgroup 100 --scan-delay 5 | grep -vE "Starting|Nmap scan report|Host is up|Nmap done|Service detection performed|Please report any incorrect results at" >> NmapReports/gather_information_result_$target.txt
}

nmap25(){
	echo "---------------------------Thong tin dich vu SMTP---------------------------" >> NmapReports/gather_information_result_$target.txt
    	 sudo $target -Pn -n --open -p25,465,587 -sT --script-timeout 20s --script=banner,smtp-commands,smtp-ntlm-info,smtp-open-relay,smtp-strangeport,smtp-enum-users,ssl-cert,ssl-cert-intaddr,ssl-ccs-injection,ssl-date,ssl-dh-params,ssl-enum-ciphers,ssl-heartbleed,ssl-known-key,ssl-poodle,sslv2,sslv2-drown,tls-nextprotoneg -sV --script-args smtp-enum-users.methods={EXPN,RCPT,VRFY} --min-hostgroup 100 --scan-delay 5 | grep -vE "Starting|Nmap scan report|Host is up|Nmap done|Service detection performed|Please report any incorrect results at" >> NmapReports/gather_information_result_$target.txt
}

nmap53(){
	echo "---------------------------Thong tin dich vu DNS---------------------------" >> NmapReports/gather_information_result_$target.txt
    	sudo nmap $target -Pn -n --open -p53 -sU --script-timeout 20s --script=dns-blacklist,dns-cache-snoop,dns-nsec-enum,dns-nsid,dns-random-srcport,dns-random-txid,dns-recursion,dns-service-discovery,dns-update,dns-zeustracker,dns-zone-transfer --min-hostgroup 100 --scan-delay 5 | grep -vE "Starting|Nmap scan report|Host is up|Nmap done|Service detection performed|Please report any incorrect results at" >> NmapReports/gather_information_result_$target.txt
}

nmap67(){
	echo "---------------------------Thong tin dich vu DHCP---------------------------" >> NmapReports/gather_information_result_$target.txt
     	sudo nmap $target -Pn -n --open -p67 -sU --script-timeout 20s --script=dhcp-discover --min-hostgroup 100 --scan-delay 5 | grep -vE "Starting|Nmap scan report|Host is up|Nmap done|Service detection performed|Please report any incorrect results at" >> NmapReports/gather_information_result_$target.txt
}

nmap111(){
	echo "---------------------------Thong tin dich vu RPC---------------------------" >> NmapReports/gather_information_result_$target.txt
     	sudo nmap $target -Pn -n --open -p111 -sT --script-timeout 20s --script=nfs-ls,nfs-showmount,nfs-statfs,rpcinfo --min-hostgroup 100 --scan-delay 5  | grep -vE "Starting|Nmap scan report|Host is up|Nmap done|Service detection performed|Please report any incorrect results at" >> NmapReports/gather_information_result_$target.txt
}

nmap137(){
	echo "---------------------------Thong tin NetBIOS---------------------------" >> NmapReports/gather_information_result_$target.txt
     	sudo nmap $target -Pn -n --open -p137 -sU --script-timeout 20s --script=nbstat --min-hostgroup 100 --scan-delay 5 | grep -vE "Starting|Nmap scan report|Host is up|Nmap done|Service detection performed|Please report any incorrect results at" >> NmapReports/gather_information_result_$target.txt
}


nmap143(){
	echo "---------------------------Thong tin dich vu IMAP---------------------------" >> NmapReports/gather_information_result_$target.txt
     	sudo nmap $target -Pn -n --open -p143 -sT --script-timeout 20s --script=imap-capabilities,imap-ntlm-info,ssl-cert,ssl-cert-intaddr,ssl-ccs-injection,ssl-date,ssl-dh-params,ssl-enum-ciphers,ssl-heartbleed,ssl-known-key,ssl-poodle,sslv2,sslv2-drown,tls-nextprotoneg -sV --min-hostgroup 100 --scan-delay 5 | grep -vE "Starting|Nmap scan report|Host is up|Nmap done|Service detection performed|Please report any incorrect results at" >> NmapReports/gather_information_result_$target.txt
}

nmap161(){
	echo "---------------------------Thong tin dich vu SNMP---------------------------" >> NmapReports/gather_information_result_$target.txt
     	sudo nmap $target -Pn -n --open -p161 -sU --script-timeout 20s --script=snmp-hh3c-logins,snmp-info,snmp-interfaces,snmp-netstat,snmp-processes,snmp-sysdescr,snmp-win32-services,snmp-win32-shares,snmp-win32-software,snmp-win32-users -sV --min-hostgroup 100 --scan-delay 5 | grep -vE "Starting|Nmap scan report|Host is up|Nmap done|Service detection performed|Please report any incorrect results at" >> NmapReports/gather_information_result_$target.txt
}

nmap389(){
	echo "---------------------------Thong tin dich vu LDAP---------------------------" >> NmapReports/gather_information_result_$target.txt
     	sudo nmap -n -sV -p389,636,3268,3269 --script "ldap* and not brute" $target | grep -vE "Starting|Nmap scan report|Host is up|Nmap done|Service detection performed|Please report any incorrect results at"  >> NmapReports/gather_information_result_ldap_$target.txt
     	while IFS= read -r line; do
	    case $line in
		*'ldapServiceName:'*)
		    ldap_service_name=$(echo "$line" | grep -oP 'ldapServiceName: \K\S+')
		    echo "	+ldapServiceName: $ldap_service_name" >> NmapReports/gather_information_result_$target.txt
		    ;;
		*"serverName:"*)
		    server_name=$(echo "$line" | grep -oP 'serverName: \K\S+')
		    echo "	+serverName: $server_name" >> NmapReports/gather_information_result_$target.txt
		    ;;
		*"dsServiceName:"*)
		    ds_service_name=$(echo "$line" | grep -oP 'dsServiceName: \K\S+')
		    echo "	+dsServiceName: $ds_service_name" >> NmapReports/gather_information_result_$target.txt
		    ;;
		*"dnsHostName:"*)
		    dns_host_name=$(echo "$line" | grep -oP 'dnsHostName: \K\S+')
		    echo "	+dnsHostName: $dns_host_name" >> NmapReports/gather_information_result_$target.txt
		    ;;
	    esac
	done < "NmapReports/gather_information_result_ldap_$target.txt"
}

nmap445(){
	echo "---------------------------Thong tin dich vu SMB---------------------------" >> NmapReports/gather_information_result_$target.txt
     	result=$(sudo nmap $target -n -sV --open -Pn -pT:139,445 --script-timeout 20s --script=smb-double-pulsar-backdoor,smb-enum-domains,smb-enum-groups,smb-enum-processes,smb-enum-services,smb-enum-sessions,smb-enum-shares,smb-enum-users,smb-mbenum,smb-os-discovery,smb-protocols,smb-security-mode,smb-server-stats,smb-system-info,smb2-capabilities,smb2-security-mode,smb2-time,msrpc-enum,stuxnet-detect --min-hostgroup 100 --scan-delay 5 | grep -vE "Starting|Nmap scan report|Host is up|Nmap done|Service detection performed|Please report any incorrect results at" >> NmapReports/gather_information_result_$target.txt)
     	echo "$result" >> Reports_Quick_Scan/report_$target.txt
     	
}

nmap636(){
	echo "---------------------------Thong tin dich vu LDAP/S---------------------------" >> NmapReports/gather_information_result_$target.txt
     	sudo nmap $target -Pn -n --open -p636 -sT --script-timeout 20s --script=ldap-rootdse,ssl-cert,ssl-cert-intaddr,ssl-ccs-injection,ssl-date,ssl-dh-params,ssl-enum-ciphers,ssl-heartbleed,ssl-known-key,ssl-poodle,sslv2,sslv2-drown,tls-nextprotoneg -sV --min-hostgroup 100 --scan-delay 5 >> NmapReports/gather_information_result_$target.txt
}

nmap873(){
	echo "---------------------------Thong tin rsync---------------------------" >> NmapReports/gather_information_result_$target.txt
     	sudo nmap $target -Pn -n --open -p873 -sT --script-timeout 20s --script=rsync-list-modules --min-hostgroup 100 --scan-delay 5 | grep -vE "Starting|Nmap scan report|Host is up|Nmap done|Service detection performed|Please report any incorrect results at" >> NmapReports/gather_information_result_$target.txt
}

nmap993(){
	echo "---------------------------Thong tin dich vu IMAP/S---------------------------" >> NmapReports/gather_information_result_$target.txt
     	sudo nmap $target -Pn -n --open -p993 -sT --script-timeout 20s --script=banner,imap-capabilities,imap-ntlm-info,ssl-cert,ssl-cert-intaddr,ssl-ccs-injection,ssl-date,ssl-dh-params,ssl-enum-ciphers,ssl-heartbleed,ssl-known-key,ssl-poodle,sslv2,sslv2-drown,tls-nextprotoneg -sV --min-hostgroup 100 --scan-delay 5 | grep -vE "Starting|Nmap scan report|Host is up|Nmap done|Service detection performed|Please report any incorrect results at" >> NmapReports/gather_information_result_$target.txt
}

nmap995(){
	echo "---------------------------Thong tin dich vu POP3/S---------------------------" >> NmapReports/gather_information_result_$target.txt
     	sudo nmap $target -Pn -n --open -p995 -sT --script-timeout 20s --script=banner,pop3-capabilities,pop3-ntlm-info,ssl-cert,ssl-cert-intaddr,ssl-ccs-injection,ssl-date,ssl-dh-params,ssl-enum-ciphers,ssl-heartbleed,ssl-known-key,ssl-poodle,sslv2,sslv2-drown,tls-nextprotoneg -sV --min-hostgroup 100 --scan-delay 5 | grep -vE "Starting|Nmap scan report|Host is up|Nmap done|Service detection performed|Please report any incorrect results at" >> NmapReports/gather_information_result_$target.txt
}

nmap1433(){
	echo "---------------------------Thong tin dich vu MS-SQL---------------------------" >> NmapReports/gather_information_result_$target.txt
     	sudo nmap $target -Pn -n --open -p1433 -sT --script-timeout 20s --script=ms-sql-config,ms-sql-dac,ms-sql-dump-hashes,ms-sql-empty-password,ms-sql-info,ms-sql-ntlm-info --min-hostgroup 100 --scan-delay 5 | grep -vE "Starting|Nmap scan report|Host is up|Nmap done|Service detection performed|Please report any incorrect results at" >> NmapReports/gather_information_result_$target.txt
}

nmap1434(){
	echo "---------------------------Thong tin dich vu MS-SQL UDP---------------------------" >> NmapReports/gather_information_result_$target.txt
     	sudo nmap $target -Pn -n --open -p1434 -sU --script-timeout 20s --script=ms-sql-dac --min-hostgroup 100 --scan-delay 5 | grep -vE "Starting|Nmap scan report|Host is up|Nmap done|Service detection performed|Please report any incorrect results at" >> NmapReports/gather_information_result_$target.txt
}

nmap1723(){
	echo "---------------------------Thong tin dich vu PPTP---------------------------" >> NmapReports/gather_information_result_$target.txt
     	sudo nmap $target -Pn -n --open -p1723 -sT --script-timeout 20s --script=pptp-version --min-hostgroup 100 --scan-delay 5 | grep -vE "Starting|Nmap scan report|Host is up|Nmap done|Service detection performed|Please report any incorrect results at" >> NmapReports/gather_information_result_$target.txt
}

nmap2049(){
	echo "---------------------------Thong tin dich vu NFS---------------------------" >> NmapReports/gather_information_result_$target.txt
     	sudo nmap $target -Pn -n --open -p2049 -sT --script-timeout 20s --script=nfs-ls,nfs-showmount,nfs-statfs --min-hostgroup 100 --scan-delay 5 | grep -vE "Starting|Nmap scan report|Host is up|Nmap done|Service detection performed|Please report any incorrect results at" >> NmapReports/gather_information_result_$target.txt
}

nmap3306(){
	echo "---------------------------Thong tin dich vu MySql---------------------------" >> NmapReports/gather_information_result_$target.txt
     	sudo nmap $target -Pn -n --open -p3306 -sT --script-timeout 20s --script=mysql-databases,mysql-empty-password,mysql-info,mysql-users,mysql-variables --min-hostgroup 100 --scan-delay 5 | grep -vE "Starting|Nmap scan report|Host is up|Nmap done|Service detection performed|Please report any incorrect results at" >> NmapReports/gather_information_result_$target.txt
}

nmap3389(){
	echo "---------------------------Thong tin dich vu RPD---------------------------" >> NmapReports/gather_information_result_$target.txt
     	sudo nmap $target -Pn -n --open -p3389 -sT --script-timeout 20s --script=rdp-enum-encryption,rdp-ntlm-info --min-hostgroup 100 --scan-delay 5 | grep -vE "Starting|Nmap scan report|Host is up|Nmap done|Service detection performed|Please report any incorrect results at" >> NmapReports/gather_information_result_$target.txt
}

check_and_run_nmap() {
    local port=$1
    local function_name="nmap${port}"
    echo "Dang quet tren cong ${port}...."
    if declare -f "$function_name" > /dev/null; then
        "$function_name"
    fi
}



#----------------------------NMAP COMMAND-------------------------------------
#----------------------------MODULE SCANS-------------------------------------
header_text_ig(){
	echo -e "${BLUE}--------------------------------------GATHER INFORMATION------------------------------------------${NC}" > NmapReports/gather_information_result_$target.txt
}

scan_nmap(){
   	echo -e "${BLUE}--------------------------OS VERSION / OPEN PORT -------------------------------${NC}" >> NmapReports/gather_information_result_$target.txt
   	echo "Dang quet thong tin he dieu hanh...."
   	echo "Dang quet cong...."
   		custom='1-1040,1050,1080,1099,1158,1344,1352,1414,1433,1521,1720,1723,1883,1911,1962,2049,2202,2375,2628,2947,3000,3031,3050,3260,3306,3310,3389,3500,3632,4369,4786,5000,5019,5040,5060,5432,5560,5631,5632,5666,5672,5850,5900,5920,5984,5985,6000,6001,6002,6003,6004,6005,6379,6666,7210,7634,7777,8000,8009,8080,8081,8091,8140,8222,8332,8333,8400,8443,8834,9000,9084,9100,9160,9600,9999,10000,10443,10809,11211,12000,12345,13364,19150,20256,27017,28784,30718,35871,37777,46824,49152,50000,50030,50060,50070,50075,50090,60010,60030'
	full='1-65535'
	udp='53,67,123,137,161,407,500,523,623,1434,1604,1900,2302,2362,3478,3671,4800,5353,5683,6481,17185,31337,44818,47808'
	sourceport=53
     	maxrtt=500ms
     	tcp=$full
     	S='sSV'
	U='sUV'
	delay='5'
   	nmap_result=$(sudo nmap $target -Pn -O -p1-1040,1050,1080,1099,1158,1344,1352,1414,1433,1521,1720,1723,1883,1911,1962,2049,2202,2375,2628,2947,3000,3031,3050,3260,3268,3269,3306,3310,3389,3500,3632,4369,4786,5000,5019,5040,5060,5432,5560,5631,5632,5666,5672,5850,5900,5920,5984,5985,6000,6001,6002,6003,6004,6005,6379,6666,7210,7634,7777,8000,8009,8080,8081,8091,8140,8222,8332,8333,8400,8443,8834,9000,9084,9100,9160,9600,9999,10000,10443,10809,11211,12000,12345,13364,19150,20256,27017,28784,30718,35871,37777,46824,49152,50000,50030,50060,50070,50075,50090,60010,60030)
   	echo "$nmap_result" | egrep -iv '(0000:|0010:|0020:|0030:|0040:|0050:|0060:|0070:|0080:|0090:|00a0:|00b0:|00c0:|00d0:|1 hop|closed|guesses|guessing|filtered|fingerprint|general purpose|initiated|latency|network distance|no exact os|no os matches|os cpe|please report|rttvar|scanned in|unreachable|warning)' | sed 's/Nmap scan report for //g' >> NmapReports/gather_information_result_$target.txt
   	grep 'open' NmapReports/gather_information_result_$target.txt | grep -v 'WARNING' | awk '{print $1}' | sort -un > NmapReports/open_ports_$target.txt
	grep 'tcp' NmapReports/open_ports_$target.txt | cut -d '/' -f1 > NmapReports/ports-tcp_$target.txt
	grep 'udp' NmapReports/open_ports_$target.txt | cut -d '/' -f1 > NmapReports/ports-udp_$target.txt
	echo "$nmap_result" | grep -E "OS details:|Service Info:|OS guesses:|Running:" | awk -F': ' '{print $2}' > NmapReports/OSinfo_nmap_$target.txt
	#Luu report TCP port
	open_ports=""
	while IFS= read -r port; do
	 	open_ports+="$port, "
	done < NmapReports/ports-tcp_$target.txt
	open_ports=$(echo "$open_ports" | sed 's/,\s$//')
	echo "Các cổng TCP đang mở: $open_ports" >> NmapReports/gather_information_result_$target.txt
	#Luu report UDP port
	open_ports1=""
	while IFS= read -r port; do
	 	open_ports1+="$port, "
	done < NmapReports/ports-udp_$target.txt
	open_ports1=$(echo "$open_ports1" | sed 's/,\s$//')
	echo "Các cổng UDP đang mở: $open_ports1" >> NmapReports/gather_information_result_$target.txt
	os_info=$(cat "NmapReports/OSinfo_nmap_$target.txt")
	os_info="OS information: $os_info" 
	version=$os_info
	echo "$os_info" >> NmapReports/gather_information_result_$target.txt
	scan_domain
	# Quet cac cong dang mo
	port_tcp_file=NmapReports/ports-tcp_$target.txt
	port_udp_file=NmapReports/ports-udp_$target.txt
	while IFS= read -r port || [[ -n "$port" ]]; do
	    check_and_run_nmap "$port"
	done < "$port_tcp_file"
	while IFS= read -r port || [[ -n "$port" ]]; do
	    check_and_run_nmap "$port"
	done < "$port_udp_file"
   	# Luu file report
   	open_tcp_ports=$(awk '{print $1}' "NmapReports/ports-tcp_$target.txt" | tr '\n' ',' | sed 's/,$//')
	open_tcp_ports="Open tcp ports: $open_tcp_ports"
	echo "$open_tcp_ports" >> NmapReports/gather_information_result_$target.txt

}

scan_domain(){
	echo "Dang quet thong tin domain...."          
	domain_info=$(enum4linux -a $target | awk '/^.*<(00|03|20|1b|1c)>.*$/ {print $1, $7}' | tee NmapReports/Domain_Scan/domain_$target.txt)
	echo "---------------------------Domain and Group Information---------------------------" >> NmapReports/gather_information_result_$target.txt
	echo "$domain_info" >> NmapReports/gather_information_result_$target.txt
	result=$(nmap -n -sV -Pn -p389,636,3268,3269 --script=ldap-search.nse $target)
	domain_temp=$(echo "$result" | grep -oP -m 1 'Domain:\s*\K(.*)' | awk '{print $1}' | sed 's/,$//')
	if [ -n "$domain_temp" ]; then
	    domain_name=$domain_temp
	else
		while IFS= read -r line; do
		    if [[ $line == *'Domain/Workgroup'* ]]; then
			domain_name=$(echo "$line" | awk '{print $NF}' | sed 's/,$//')
			domain_name=$domain_temp
		    fi
		done < "NmapReports/Domain_Scan/domain_$target.txt"
	fi

}


#----------------------------MODULE SCANS-------------------------------------
	header_text_ig
	scan_nmap
        ./vulscan.sh
