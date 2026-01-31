# Linux Directory Structure Cheat Sheet

## Root Directory (/)

| Checkbox | Directory | Description |
|----------|-----------|-------------|
| [ ] | /bin | Essential user command binaries |
| [ ] | /boot | Boot loader files |
| [ ] | /dev | Device files |
| [ ] | /etc | System configuration files |
| [ ] | /home | User home directories |
| [ ] | /lib | Essential shared libraries and kernel modules |
| [ ] | /media | Mount point for removable media |
| [ ] | /mnt | Mount point for temporary filesystems |
| [ ] | /opt | Optional application software packages |
| [ ] | /proc | Virtual filesystem for process and system information |
| [ ] | /root | Root user's home directory |
| [ ] | /sbin | System binaries |
| [ ] | /srv | Data for services provided by the system |
| [ ] | /tmp | Temporary files |
| [ ] | /usr | User utilities and applications |
| [ ] | /var | Variable files (logs, temporary files, caches) |

## Important Subdirectories

| Checkbox | Directory | Description |
|----------|-----------|-------------|
| [ ] | /etc/passwd | User account information |
| [ ] | /etc/shadow | Encrypted passwords for user accounts |
| [ ] | /etc/fstab | Filesystem table |
| [ ] | /etc/hosts | IP to hostname mappings |
| [ ] | /var/log | System and application log files |
| [ ] | /usr/bin | User commands |
| [ ] | /usr/sbin | System administration commands |
| [ ] | /usr/local | Locally installed software |

## Tips
- [ ] Use `ls -la /` to view root directory contents
- [ ] `df -h` shows disk usage for mounted filesystems
- [ ] `du -sh /*` displays disk usage for each directory in root

## Additional Resources
- [ ] [Filesystem Hierarchy Standard](https://refspecs.linuxfoundation.org/FHS_3.0/fhs-3.0.html)
- [ ] [Linux Directory Structure Explained](https://www.linuxfoundation.org/blog/blog/classic-sysadmin-the-linux-filesystem-explained)
