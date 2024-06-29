### Load .sh files under ~/.bash.d
files=$(find ~/.bash.d/ -type f -name "*.sh" | grep -v "old" | sort -V )
for f in $files; do
    . $f
done

### scd start ###
cd /home/ywatanabe/proj
if [ -f env/bin/activate ]; then
    source env/bin/activate
fi
### scd end ###
