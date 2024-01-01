#!/bin/bash

# Dòng cần xử lý
line="[1m[34mSMB[0m         192.168.133.139 445    CHAUPHANHOAILIN  [1m[32m[+][0m hoailinh110.it\administrator:Linh123! [1m[33m(Pwn3d!)[0m"

# Sử dụng awk và cut để lấy thông tin user và pass
user=$(echo "$line" | awk -F'\\' '{print $2}' | cut -d ':' -f 1)
pass=$(echo "$line" | awk -F':' '{print $2}' | cut -d ' ' -f 1)

# Hiển thị kết quả
echo "Username: $user"
echo "Password: $pass"

