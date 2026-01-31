# Ubuntu Cheat Sheet

## System Commands

| Checkbox | Command | Description |
|----------|---------|-------------|
| [ ] | sudo apt update | Update package lists |
| [ ] | sudo apt upgrade | Upgrade installed packages |
| [ ] | sudo apt install [package] | Install a package |
| [ ] | sudo apt remove [package] | Remove a package |
| [ ] | sudo reboot | Reboot the system |
| [ ] | sudo shutdown -h now | Shutdown the system |

## File Management

| Checkbox | Command | Description |
|----------|---------|-------------|
| [ ] | ls | List directory contents |
| [ ] | cd [directory] | Change directory |
| [ ] | mkdir [directory] | Create a directory |
| [ ] | rm [file] | Remove a file |
| [ ] | rm -r [directory] | Remove a directory |
| [ ] | cp [source] [destination] | Copy files/directories |
| [ ] | mv [source] [destination] | Move/rename files/directories |

## User Management

| Checkbox | Command | Description |
|----------|---------|-------------|
| [ ] | sudo adduser [username] | Add a new user |
| [ ] | sudo deluser [username] | Delete a user |
| [ ] | sudo passwd [username] | Change user password |
| [ ] | groups [username] | Show user's groups |
| [ ] | sudo usermod -aG [group] [username] | Add user to a group |

## System Information

| Checkbox | Command | Description |
|----------|---------|-------------|
| [ ] | uname -a | Display system information |
| [ ] | lsb_release -a | Display Ubuntu version |
| [ ] | df -h | Show disk space usage |
| [ ] | free -h | Display memory usage |
| [ ] | top | Show running processes |

## Network

| Checkbox | Command | Description |
|----------|---------|-------------|
| [ ] | ifconfig | Display network interfaces |
| [ ] | ping [host] | Send ICMP echo request |
| [ ] | netstat -tuln | List open ports |
| [ ] | sudo ufw status | Check firewall status |
| [ ] | sudo ufw enable/disable | Enable/disable firewall |

## Package Management

| Checkbox | Command | Description |
|----------|---------|-------------|
| [ ] | apt search [package] | Search for a package |
| [ ] | apt show [package] | Show package details |
| [ ] | dpkg -l | List installed packages |
| [ ] | sudo apt autoremove | Remove unnecessary packages |

## Tips
- [ ] Use Tab for command auto-completion
- [ ] Use Ctrl+R to search command history
- [ ] Add `apt-get` commands to `/etc/cron.daily` for automatic updates

## Additional Resources
- [ ] [Ubuntu Documentation](https://help.ubuntu.com/)
- [ ] [Ubuntu Forums](https://ubuntuforums.org/)
