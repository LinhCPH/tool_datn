#!/bin/bash


BLUE='\033[0;34m'
NC='\033[0m'
score=0
index=1
winrm_check=0

echo -e "${BLUE}Scan Vulnerability${NC}" 

export score
export index
export winrm_check

#----------------------------CHON CHUC NANG -------------------------------------
header_text_vs(){
	echo -e "${BLUE}--------------------------------------VULNERABILITY SCANNING------------------------------------------${NC}" > Reports_Quick_Scan/report_$target.txt
}

smb_scan_vul(){
	echo "---------------------------Quet lo hong dich vu SMB---------------------------" >> Reports_Quick_Scan/report_$target.txt
	echo "Quet lo hong SMB...." 
	sudo nmap -n -sV -Pn -pT:139,445 --script=smb-vuln*  $target > Vul_Scan/vul_smb_$target.txt
	declare -a cve_array
	declare -a risk_array
	count=0
	while IFS= read -r line; do
	    if [[ "$line" == *CVE:* ]]; then
		cve=$(echo "$line" | grep -oP "CVE-[0-9]+-[0-9]+")
		echo "$cve" >> Vul_Scan/vuln_$target.txt
	    else if [[ "$line" == *Risk\ factor:* ]]; then
		risk=$(echo "$line" |  awk -F 'Risk factor: ' '{print $2}')
		echo "$risk" >> Vul_Scan/vuln_$target.txt
		echo -e "	\e[31mPhat hien mot lo hong: $cve ($risk) \e[0m \e[1m" 
		((count++))
	    fi
	    fi
	done < "Vul_Scan/vul_smb_$target.txt" 
	# In thông tin ra màn hình
	if [ $count == 0 ]; then
	    echo "	Không có thông tin về lỗ hổng được tìm thấy." 
	else
	    for ((i=0; i<${#cve_array[@]}; i++)); do
		echo "${cve_array[$i]} ${risk_array[$i]}" 
		if [ "$risk" == "HIGH" ]; then
			((score+=9))
	   		((index+=1))
	   	else if [ "$risk" == "MEDIUM" ]; then
	   		((score+=6))
	   		((index+=1))
	   	else if [ "$risk" == "LOW" ]; then
	   		((score+=3))
	   		((index+=1))
	   	fi
	   	fi
	   	fi
	    done
	fi
}

print_vuln_list(){
	if [ ! -f "Vul_Scan/vuln_$target.txt" ]; then
	    echo "File vuln.txt không tồn tại."
	    exit 1
	fi
	echo -n "Lo hong duoc phat hien:" >> Reports_Quick_Scan/report_$target.txt
	echo -n "Lo hong duoc phat hien:"
	while IFS= read -r cve; do
		IFS= read -r severity
		echo -n "$cve ($severity), "
		echo -n "$cve ($severity), " >> Reports_Quick_Scan/report_$target.txt
	done < "Vul_Scan/vuln_$target.txt"
	echo ""  	
}

export -f print_vuln_list

smb_brute(){
	result=$(sudo crackmapexec smb $target -u bruceforce/user_wordlist -p bruceforce/pass_wordlist --sessions --rid-brute 2000 --pass-pol --sam --users --groups --local-groups --loggedon-users > Vul_Scan/smb_brute_$target.txt)
	result1=$(sudo crackmapexec smb $target -u bruceforce/user_wordlist -p bruceforce/pass_wordlist)
	check=0
	while IFS= read -r line; do
	    if [[ "$line" != *STATUS_LOGON_FAILURE* ]]; then
		echo "$line" >> Vul_Scan/smb_brute_temp_$target.txt
		((check+=1))
	    fi
	done < "Vul_Scan/smb_brute_$target.txt"
	if [ "$check" -eq 0 ];then
		echo "Khong tim thay nguoi dung smb hop le!" >> Reports_Quick_Scan/report_$target.txt
	else
		echo "---------------------------Tan cong brute force SMB---------------------------" >> Reports_Quick_Scan/report_$target.txt
		echo -e "	\e[31mPhat hien thong tin user SMB\!e[0m \e[1m" 
		linex=$(echo "$result1" | grep '\[+\]')
		# Sử dụng awk và cut để lấy thông tin user và pass
		user=$(echo "$linex" | awk -F'\\' '{print $2}' | cut -d ':' -f 1)
		pass=$(echo "$linex" | awk -F':' '{print $2}' | cut -d ' ' -f 1)
		# Hiển thị kết quả
		echo "Username: $user"
		echo "Password: $pass"
		echo "$user $pass" >> bruceforce/account_plain_$target.txt
		((score+=10))
	   	((index+=1))
	fi
	
	# xu ly luu report
	read_next=false
	step=0
	while IFS= read -r line; do
	    # dumping SAM hashes
	    if [[ "$line" == *'Dumping SAM hashes'* ]]; then
	    	echo "Ket qua bruteforce SAM hashes: " >> Reports_Quick_Scan/report_$target.txt
		read_next=true
	    elif [[ "$line" == *'SAM hashes to the database'* ]]; then
	    	step=1
		read_next=false
	    elif  [ "$read_next" = true ] && [ "$step" -eq 0 ]; then
		extracted_text=$(echo "$line" | sed -n 's/.*\[33m\(.*\)\[0m.*/\1/p')
		echo "		+  $extracted_text" >> Reports_Quick_Scan/report_$target.txt
		IFS=':' read -ra parts <<< "$extracted_text"
		echo "${parts[0]} ${parts[2]}" >> bruceforce/account_brute.txt
		read_next=true
	
	    # Enumerated domain user
	    elif [[ "$line" == *'Enumerated domain user'* ]]; then
	    	echo "Liet ke domain users: " >> Reports_Quick_Scan/report_$target.txt
		read_next=true
	    elif [[ "$line" == *'Enumerated domain group'* ]]; then
	    	step=2
		read_next=false
	    elif [ "$read_next" = true ] && [ "$step" -eq 1 ] ; then
		extracted_text=$(echo "$line" | sed -n 's/.*\[33m\(.*\)\[0m.*/\1/p')
		echo "		+  $extracted_text" >> Reports_Quick_Scan/report_$target.txt
		read_next=true

	    # Enumerated domain group
	    elif [[ "$line" == *'Enumerated domain group'* ]]; then
	    	echo "Liet ke domain groups: " >> Reports_Quick_Scan/report_$target.txt
		read_next=true
	    elif [[ "$line" == *'Enumerated local groups'* ]]; then
	    	step=3
		read_next=false
	    elif [ "$read_next" = true ] && [ "$step" -eq 2 ]; then
		extracted_text=$(echo "$line" | sed -n 's/.*\[33m\(.*\)\[0m.*/\1/p')
		echo "		+  $extracted_text" >> Reports_Quick_Scan/report_$target.txt
		read_next=true
	    
	    # Password policy
	    elif [[ "$line" == *'Dumping password info for domain:'* ]]; then
	    	echo "Chinh sach mat khau cua domain: " >> Reports_Quick_Scan/report_$target.txt
		read_next=true
	    elif [[ "$line" == *'Brute forcing RIDs'* ]]; then
		read_next=false
	    elif [ "$read_next" = true ] && [ "$step" -eq 3 ] ; then
		extracted_text=$(echo "$line" | sed -n 's/.*\[33m\(.*\)\[0m.*/\1/p')
		echo "		+  $extracted_text" >> Reports_Quick_Scan/report_$target.txt
		read_next=true
	      
	    # Brute forcing RIDs
	    elif [[ "$line" == *'Brute forcing RIDs'* ]]; then
	    	echo "Tim thay cac RIDs: " >> Reports_Quick_Scan/report_$target.txt
		read_next=true
	    elif [[ "$line" == '' ]]; then
		read_next=false
	    elif [ "$read_next" = true ] && [ "$step" -eq 3 ] ; then
		extracted_text=$(echo "$line" | sed -n 's/.*\[33m\(.*\)\[0m.*/\1/p')
		echo "		+  $extracted_text" >> Reports_Quick_Scan/report_$target.txt
		read_next=true
	    fi
	done < "Vul_Scan/smb_brute_temp_$target.txt"
}

kerberos_pentest(){
	echo "---------------------------Kerberos Pentesting---------------------------" >> Reports_Quick_Scan/report_$target.txt
	echo "Dang kiem tra Kerberos...." 
	result=$(nmap -p 88 --script=krb5-enum-users --script-args krb5-enum-users.realm=$domain_name,userdb=/home/kali/B19DCAT110_Pentest_Tool_DATN/bruceforce/user_wordlist $target)
	echo "Danh sách người dùng Kerberos:" >> Reports_Quick_Scan/report_$target.txt
	while IFS= read -r line; do
	  	if [[ $line == *@"$domain_name"* && $line == "|"* ]]; then
    		username=$(echo "$line" | awk '{print $2}' | tr -d '@')
    		echo "$username" >> bruceforce/user_wordlist
    		echo "		+ $username" >> Reports_Quick_Scan/report_$target.txt
    		((score+=3))
	   	((index+=1))
    	fi
	done <<< "$result"
	
	#  Liet ke hashes cua nguoi dung Kerberos (Kerberoasting)

	impacket-GetNPUsers -dc-ip $target $domain_name/ -no-pass -usersfile bruceforce/user_wordlist > bruceforce/ker_hash_$target.txt
	while IFS= read -r line; do
	  	if [[ $line == *'$krb5asrep$'* ]]; then
    			user=$(echo $line | awk -F':' '{print $1}' | awk -F'[$]' '{print $4$5}' )
    			hash=$(echo $line | awk -F':' '{print $2}')
    			echo "	Da tim thay mot user va mat khau hashes:" >> Reports_Quick_Scan/report_$target.txt
    			echo -e "	\e[31m+Tim thay mot user: $user\e[0m \e[1m" 
    			echo "		+User:$user || 	Hash:$hash"   >> Reports_Quick_Scan/report_$target.txt
    			echo "$user $hash"   >> bruceforce/account_brute_$target.txt
    			echo -e "	\e[31mCo the tan cong Pass-the-Hash!\e[0m \e[1m" >> Reports_Quick_Scan/report_$target.txt
    			((score+=6))
	   		((index+=1))
    		fi
    	done < "bruceforce/ker_hash_$target.txt"
   	
}

ftp_scan_vul(){
	echo "---------------------------FTP Pentesting---------------------------" >> Reports_Quick_Scan/report_$target.txt
	echo "Dang kiem tra FTP...." 
	nmap_result=$(sudo nmap -p21 --script ftp-anon $target)
	if [[ $nmap_result == *"Anonymous FTP login allowed"* ]]; then
	    	echo -e "	\e[31mCo the dang nhap an danh vao dich vu FTP!\e[0m \e[1m" >> Reports_Quick_Scan/report_$target.txt
    		((score+=2))
    		((index+=1))
	fi 
}


ssh_scan_vul(){
	echo "---------------------------SSH Pentesting---------------------------" >> Reports_Quick_Scan/report_$target.txt
	echo "Dang kiem tra SSH...." 
	sudo nmap -p22  --script ssh-vuln-cve2017-15906,rsa-vuln-roca $target  >> Vul_Scan/vul_$target.txt
}

http_scan_vul(){
	echo "---------------------------HTTP Pentesting---------------------------" >> Reports_Quick_Scan/report_$target.txt
	echo "Dang kiem tra HTTP...." 
	sudo nmap -p80 --script http-vuln* $target >> Vul_Scan/vul_$target.txt
	dnsrecon -d $domain_name -n  $target -a > Vul_Scan/dns_$target.txt
	start_printing=false
	while IFS= read -r line; do
	    if [[ "$line" == *'DNSSEC is not configured for'* ]]; then
		echo "Bản ghi SOA,NS,A:" >> Reports_Quick_Scan/report_$target.txt
		echo " 	Tim thay cac ban ghi SOA,NS,A!"
		start_printing=true
		continue
	    fi
	    if [[ "$line" == *'Enumerating SRV Records'* ]]; then
    	    	echo "Bản ghi dịch vụ (Service Records - SRV Records):" >> Reports_Quick_Scan/report_$target.txt
    	    	echo " 	Tim thay cac ban ghi SRV!"
    	    	start_printing=true
		continue
	    fi
	    if [[ "$line" == *'Recursion enabled on NS Server'* ]]; then
	    	start_printing=true
		continue
	    fi
	    if [ "$start_printing" = true ] && [[ "$line" != *'Records Found'* ]]; then
		cleaned_line=$(echo "$line" | sed 's/^\[.*\] //')
		echo "	   +$cleaned_line" >> Reports_Quick_Scan/report_$target.txt
	    fi
	    if [ "$start_printing" = true ] && [[ "$line" == *'Records Found'* ]]; then
		start_printing=false
	    fi
	done < "Vul_Scan/dns_$target.txt"
}

snmp_scan_vul(){
	echo "---------------------------SNMP Pentesting---------------------------" >> Reports_Quick_Scan/report_$target.txt
	echo "Dang kiem tra SNMP...." 
	sudo nmap --script -p161 snmp-brute $target >> Vul_Scan/vul_$target.txt
}


msrpc_scan_vul(){
	echo "---------------------------MSRPC Pentesting---------------------------" >> Reports_Quick_Scan/report_$target.txt
	echo "Dang kiem tra MSRPC...." 
	check=0
	result=$(rpcdump.py $target -p 135 2>&1 | egrep 'MS-RPRN|MS-PAR')
	if [[ $result == *"MS-RPRN"* || $result == *"MS-PAR"* ]]; then
	    echo -e "	\e[31mMS-RPRN/MS-PAR dang hoat dong! Co the khai thac PrintNightmare.\e[0m \e[1m" >> Reports_Quick_Scan/report_$target.txt
	    echo -e "	\e[31mMS-RPRN/MS-PAR dang hoat dong! Co the khai thac PrintNightmare.\e[0m \e[1m"
	    ((check+=1))
	    ((score+=3))
	    ((index+=1))
	else
	    echo "Kết quả không chứa các ký tự MS-RPRN hoặc MS-PAR" 
	fi

}

winrm_scan_vul(){
	echo "---------------------------WinRM Pentesting---------------------------" >> Reports_Quick_Scan/report_$target.txt
	echo "Dang kiem tra WinRM...." 
	crackmapexec winrm $target -u bruceforce/user_wordlist -p bruceforce/pass_wordlist > bruceforce/winrm_brute_$target.txt
	user=$(cat bruceforce/winrm_brute_$target.txt |grep -i Pwn3d | awk '{print $6}' | cut -d'\' -f2 | cut -d':' -f1)
	pass=$(cat bruceforce/winrm_brute_$target.txt |grep -i Pwn3d | awk '{print $6}'   | cut -d':' -f2)
	if [[ -n "$user" && -n "$pass" ]]; then
	    echo -e "	\e[31mDa tim thay mot user WinRM! $user:$pass\e[0m \e[1m" >> Reports_Quick_Scan/report_$target.txt
	    echo -e "	\e[31mDa tim thay mot user WinRM! $user:$pass\e[0m \e[1m"
	    ((score+=8))
	    ((index+=1))
	    echo "$user $pass" >> bruceforce/account_plain_$target.txt
	else
	    echo "Không tìm thấy thông tin đăng nhập WinRM." >> Reports_Quick_Scan/report_$target.txt
	fi

	
}
# Active Directory Pentest 

ldap_pentest(){
	echo "---------------------------LDAP Pentesting---------------------------" >> Reports_Quick_Scan/report_$target.txt
	echo "Dang kiem tra LDAP...." 
	# Thu dang nhap an danh
	ldapsearch -H ldap://$target -x >/dev/null 2>&1
	if [ $? -eq 0 ]; then
	    echo -e "	\e[31mCo the dang nhap an danh vao dich vu LDAP!\e[0m \e[1m" 
	    echo -e "	\e[31mCo the dang nhap an danh vao dich vu LDAP!\e[0m \e[1m" >> Reports_Quick_Scan/report_$target.txt
	    ((score+=6))
	    ((index+=1))
	else
	    echo "	Khong the ket noi an danh qua dich vu LDAP!" >> Reports_Quick_Scan/report_$target.txt
	    echo "	Khong the ket noi an danh qua dich vu LDAP!"
	fi
 	
 	# Bruce Force LDAP
 	hydra_output=$(hydra -l bruceforce/user_wordlist -P bruceforce/pass_wordlist $target  ldap2 -V -f)
	if [ $? -eq 0 ] && [[ ! $hydra_output =~ "0 valid password found" ]]; then
	    echo -e "\e[31mPhat hien tai khoan nguoi dung cua dich vu LDAP!\e[0m \e[1m" >> Reports_Quick_Scan/report_$target.txt
	    login_info=$(echo "$hydra_output" | grep -E "login:|password:") >> Reports_Quick_Scan/report_$target.txt
	    echo "+ Thông tin đăng nhập: $login_info" >> Reports_Quick_Scan/report_$target.txt
	    echo -e "	\e[31mPhat hien thong tin user LDAP! $login_info\e[0m \e[1m"
	else
	    echo "	Khong co nguoi dung nao duoc tim thay qua dich vu LDAP!"
	fi
}

nmap_scan_vul(){
	if [ ! -f "NmapReports/ports-tcp_$target.txt" ]; then
	  exit 1
	fi
	while read -r port; do
	  case $port in
	    21)
	      ftp_scan_vul
	      ;;
	    22)
	      ssh_scan_vul
	      ;;
	    23)

	      ;;
	    53)
		http_scan_vul
	      ;;
	    88)
		kerberos_pentest
	      ;;
	    80)

	      ;;
	    135)
	    	msrpc_scan_vul
	      ;;
	    389)
	       ldap_pentest
	      ;;
	    443)
	    
	      ;;
	    445)
        	smb_scan_vul
		smb_brute
	      ;;
	    161)
	      snmp_scan_vul
	      ;;
	    5985)
	      
	      ;;
	      	
	    *)
	      ;;
	  esac

	done < NmapReports/ports-tcp_$target.txt
}



nikto_scan_vul(){
	#if [ ! -e "NmapReports/ports-tcp_$target.txt" ]; then
  		echo "Khong tim thay tệp NmapReports/ports-tcp_$target.txt"
  	#	exit 1
	#fi
	#mapfile -t ports_array < "NmapReports/ports-tcp_$target.txt"
	#for port in "${ports_array[@]}"; do
	#  result=$(nikto -h "$target" -p "$port")
	#  if [[ "$result" != *"0 host(s) tested"* ]]; then
	#  	echo "--------------Nikto Scan---------------"  >> Vul_Scan/vul_nikto_$target.txt
	#    	echo "$result"  >> Vul_Scan/vul_nikto_$target.txt
	#    	echo "Lỗ hổng trên cổng $port: $result" | awk '/^\+/ && !/1 host\(s\) tested|- Nikto v2.5.0/ {print $0} /- [0-9]+ requests:/ {print $0}'
	#    	filtered_result=$(echo "$result" | grep -E "^\+ Target IP:|^\+ Target Hostname:|^\+ Target Port:|^\+ Start Time:|^\+ Server:|^\+ End Time:")
	#    	 	if [[ "$filtered_result" == *"requests: 0 error(s) and"* ]]; then
	#		    x=0
	#		else
	#			    if [[ "$result" == *"Critical"* ]]; then
	#			      	((score+=5))
	#    				((index+=1))
	#			    elif [[ "$result" == *"High"* ]]; then
	#			      	((score+=4))
	#    				((index+=1))
	#			    elif [[ "$result" == *"Medium"* ]]; then
	#			     	((score+=3))
	#    				((index+=1))
	#			    elif [[ "$result" == *"Low"* ]]; then
	#			      	((score+=2))
	#    				((index+=1))
	#			    else
	#				((score+=1))
	#    				((index+=1))
	#			    fi
	#		fi
	#  else
	#  	echo "Không tim thấy lỗ hổng trên cổng $port"
	#  fi
	#done
}

#----------------------------CHON CHUC NANG QUET-------------------------------------
	header_text_vs
	nmap_scan_vul
	end_time=$(date +%s)
	echo "----------------------------Score: $score Index: $index----------------------------" >> Reports_Quick_Scan/report_$target.txt
	sleep 15
	./services_pentest.sh
        

	  

 

