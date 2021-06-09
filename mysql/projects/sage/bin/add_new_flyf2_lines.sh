#/bin/rm -f lines.in

echo "Line" >/tmp/lines.in
perl /opt/informatics/bin/find_new_flyf2_lines.pl | sort >>/tmp/lines.in
/opt/informatics/bin/sage_loader.pl -description "Initial load of new fly lines from FLYF2" -file /tmp/lines.in -config line_insert -module line -lab rubin -debug -out lines.out
/bin/rm -f /tmp/lines.in
