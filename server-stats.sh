#!/bin/bash
# This script is used to collect server statistics and log them to a file.

#Total CPU usage
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
echo "CPU Usage: $cpu_usage%" >> server_stats.log

#Total Memory usage (Free vs Used percentage)
mem_usage=$(free | grep Mem | awk '{printf "%.2f%%", $3/$2 * 100.0}')
echo "Memory Usage: $mem_usage" >> server_stats.log

#Total Disk usage (Free vs Used percentage)
disk_usage=$(df -h / | awk 'NR==2 {print $5}')
echo "Disk Usage: $disk_usage" >> server_stats.log

#Top 5 processes by CPU usage
echo "Top 5 processes by CPU usage:" >> server_stats.log
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 >> server_stats.log

#Top 5 processes by Memory usage
echo "Top 5 processes by Memory usage:" >> server_stats.log
ps -eo pid,comm,%mem --sort=-%mem | head -n 6 >> server_stats.log

#os version
os_version=$(cat /etc/os-release | grep "PRETTY_NAME" | cut -d= -f2 | tr -d '"')
echo "OS Version: $os_version" >> server_stats.log

#Current date and time
current_time=$(date +"%Y-%m-%d %H:%M:%S")
echo "Current Time: $current_time" >> server_stats.log

#load average
load_average=$(uptime | awk -F 'load average: ' '{print $2}')
echo "Load Average: $load_average" >> server_stats.log

#logged in users
logged_in_users=$(who | wc -l)
echo "Logged in Users: $logged_in_users" >> server_stats.log 

#logged in users details
echo "Logged in Users Details:" >> server_stats.log
who >> server_stats.log 

#failed login attempts
failed_logins=$(grep "Failed password" /var/log/auth.log | wc -l)
echo "Failed Login Attempts: $failed_logins" >> server_stats.log

echo "----------------------------------------" >> server_stats.log