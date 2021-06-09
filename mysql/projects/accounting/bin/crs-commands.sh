#! /bin/bash

JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/1.6.0/Home/bin/
CLASSPATH=/System/Library/Frameworks/JavaVM.framework/Versions/1.6.0/Home/lib/deploy.jar:/System/Library/Frameworks/JavaVM.framework/Versions/1.6.0/Home/lib/dt.jar:/System/Library/Frameworks/JavaVM.framework/Versions/1.6.0/Home/lib/javaws.jar:/System/Library/Frameworks/JavaVM.framework/Versions/1.6.0/Home/lib/jce.jar:/System/Library/Frameworks/JavaVM.framework/Versions/1.6.0/Home/lib/management-agent.jar:/System/Library/Frameworks/JavaVM.framework/Versions/1.6.0/Home/lib/plugin.jar:/System/Library/Frameworks/JavaVM.framework/Versions/1.6.0/Home/lib/sa-jdi.jar:/System/Library/Frameworks/JavaVM.framework/Versions/1.6.0/Home/../Classes/charsets.jar:/System/Library/Frameworks/JavaVM.framework/Versions/1.6.0/Home/../Classes/classes.jar:/System/Library/Frameworks/JavaVM.framework/Versions/1.6.0/Home/../Classes/dt.jar:/System/Library/Frameworks/JavaVM.framework/Versions/1.6.0/Home/../Classes/jce.jar:/System/Library/Frameworks/JavaVM.framework/Versions/1.6.0/Home/../Classes/jconsole.jar:/System/Library/Frameworks/JavaVM.framework/Versions/1.6.0/Home/../Classes/jsse.jar:/System/Library/Frameworks/JavaVM.framework/Versions/1.6.0/Home/../Classes/laf.jar:/System/Library/Frameworks/JavaVM.framework/Versions/1.6.0/Home/../Classes/management-agent.jar:/System/Library/Frameworks/JavaVM.framework/Versions/1.6.0/Home/../Classes/ui.jar:/System/Library/Frameworks/JavaVM.framework/Versions/1.6.0/Home/lib/ext/apple_provider.jar:/System/Library/Frameworks/JavaVM.framework/Versions/1.6.0/Home/lib/ext/dnsns.jar:/System/Library/Frameworks/JavaVM.framework/Versions/1.6.0/Home/lib/ext/localedata.jar:/System/Library/Frameworks/JavaVM.framework/Versions/1.6.0/Home/lib/ext/sunjce_provider.jar:/System/Library/Frameworks/JavaVM.framework/Versions/1.6.0/Home/lib/ext/sunpkcs11.jar:/Users/dolafit/develop/projects/ConsolidatedReportingTool/Trunk/dist/app/classes:/Users/dolafit/develop/projects/ConsolidatedReportingTool/Trunk/build/app/lib/jakarta-commons/commons-pool.jar:/Users/dolafit/develop/projects/ConsolidatedReportingTool/Trunk/build/app/lib/jakarta-commons/commons-logging-1.1.jar:/Users/dolafit/develop/projects/ConsolidatedReportingTool/Trunk/build/app/lib/jakarta-commons/commons-beanutils.jar:/Users/dolafit/develop/projects/ConsolidatedReportingTool/Trunk/build/app/lib/jakarta-commons/commons-io.jar:/Users/dolafit/develop/projects/ConsolidatedReportingTool/Trunk/build/app/lib/jakarta-commons/commons-fileupload.jar:/Users/dolafit/develop/projects/ConsolidatedReportingTool/Trunk/build/app/lib/jakarta-commons/commons-validator.jar:/Users/dolafit/develop/projects/ConsolidatedReportingTool/Trunk/build/app/lib/ireport-1.2.6/ireport.jar:/Users/dolafit/develop/projects/ConsolidatedReportingTool/Trunk/build/app/lib/javamail-1.4/activation.jar:/Users/dolafit/develop/projects/ConsolidatedReportingTool/Trunk/build/app/lib/mysql-connector-java-5.0.3/mysql-connector-java-5.0.3-bin.jar:/Users/dolafit/develop/projects/ConsolidatedReportingTool/Trunk/build/app/lib/jakarta-commons/jakarta-oro.jar:/Users/dolafit/develop/projects/ConsolidatedReportingTool/Trunk/build/app/lib/jakarta-commons/commons-digester.jar:/Users/dolafit/develop/projects/ConsolidatedReportingTool/Trunk/build/app/lib/jakarta-commons/commons-lang.jar:/Users/dolafit/develop/projects/ConsolidatedReportingTool/Trunk/build/app/lib/jakarta-commons/commons-dbcp.jar:/Users/dolafit/develop/projects/ConsolidatedReportingTool/Trunk/build/app/lib/jasperreports-1.2.6/jasperreports-1.2.6.jar:/Users/dolafit/develop/projects/ConsolidatedReportingTool/Trunk/build/app/lib/javamail-1.4/mail.jar:/Users/dolafit/develop/projects/ConsolidatedReportingTool/Trunk/build/app/lib/itext-1.4.5/itext-1.4.5.jar:/Users/dolafit/develop/projects/ConsolidatedReportingTool/Trunk/build/app/lib/jakarta-commons/commons-collections.jar:/Users/dolafit/develop/projects/ConsolidatedReportingTool/Trunk/build/test/lib/junit3.8.1/junit.jar:/Users/dolafit/develop/projects/ConsolidatedReportingTool/Trunk/build/app/lib/jcommon-1.0.0/jcommon-1.0.0.jar:/Users/dolafit/develop/projects/ConsolidatedReportingTool/Trunk/build/app/lib/jfreechart-1.0.0/jfreechart-1.0.0.jar:/Users/dolafit/develop/projects/ConsolidatedReportingTool/Trunk/build/app/lib/poi-2.5.1/poi-2.5.1-final-20040804.jar:/Users/dolafit/develop/projects/ConsolidatedReportingTool/Trunk/dist/app/config
FY_DATE=20080901
BEGIN_DATE=20090801
END_DATE=20090827

cd /Users/dolafit/develop/projects/ConsolidatedReportingTool/Trunk

# Science Shared Resource 2009 Budget
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $FY_DATE -e $END_DATE -t resource_transaction_by_month -u 309753 -g science
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $FY_DATE -e $END_DATE -t resource_transaction_by_month -u 10492 -g science -r "Cell Culture Facility"
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $FY_DATE -e $END_DATE -t resource_transaction_by_month -u 21799 -g science -r "Electron Microscopy"
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $FY_DATE -e $END_DATE -t resource_transaction_by_month -u 29240 -g science -r "Fly Lab"
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $FY_DATE -e $END_DATE -t resource_transaction_by_month -u 16560 -g science -r "Histology/anatomy Facility"
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $FY_DATE -e $END_DATE -t resource_transaction_by_month -u 43699 -g science -r "Instrument Development"
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $FY_DATE -e $END_DATE -t resource_transaction_by_month -u 4955 -g science -r "Light Microscopy"
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $FY_DATE -e $END_DATE -t resource_transaction_by_month -u 12168 -g science -r "Media Facility"
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $FY_DATE -e $END_DATE -t resource_transaction_by_month -u 26238 -g science -r "Molecular Biology"
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $FY_DATE -e $END_DATE -t resource_transaction_by_month -u 31509 -g science -r "Transgenics"
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $FY_DATE -e $END_DATE -t resource_transaction_by_month -u 113125 -g science -r "Vivarium"
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t resource_transaction -u 309753 -g science

sleep 95

# VS Program
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t user_transaction -d 093400

# Fly Projects
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t user_transaction -d 093416
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t user_transaction -d 093417
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t user_transaction -d 093418

sleep 95

# Computing Shared Resource
#$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $FY_DATE -e $END_DATE -t resource_transaction_by_month -u 1 -g computing
#$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t resource_transaction -g computing -r "Scientific Computing"
#$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t resource_transaction -g computing -r "Computing Services"
#$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t resource_transaction -g computing -r "Compute Farm"

# SR Revenue
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $FY_DATE -e $END_DATE -t resource_transaction_by_month

sleep 95

# Department Transaction
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction

sleep 95

# Fetter
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction -d 093093

sleep 95

# Sternson
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $FY_DATE -e $END_DATE -t resource_transaction_by_month -u 28500 -d 093206
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $FY_DATE -e $END_DATE -t resource_transaction_by_month -u 780 -g science -r "Cell Culture Facility" -d 093206
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $FY_DATE -e $END_DATE -t resource_transaction_by_month -u 0 -g science -r "Electron Microscopy" -d 093206
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $FY_DATE -e $END_DATE -t resource_transaction_by_month -u 0 -g science -r "Fly Lab" -d 093206
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $FY_DATE -e $END_DATE -t resource_transaction_by_month -u 5400 -g science -r "Histology/anatomy Facility" -d 093206
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $FY_DATE -e $END_DATE -t resource_transaction_by_month -u 0 -g science -r "Instrument Development" -d 093206
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $FY_DATE -e $END_DATE -t resource_transaction_by_month -u 0 -g science -r "Light Microscopy" -d 093206
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $FY_DATE -e $END_DATE -t resource_transaction_by_month -u 167 -g science -r "Media Facility" -d 093206
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $FY_DATE -e $END_DATE -t resource_transaction_by_month -u 500 -g science -r "Molecular Biology" -d 093206
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $FY_DATE -e $END_DATE -t resource_transaction_by_month -u 0 -g science -r "Transgenics" -d 093206
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $FY_DATE -e $END_DATE -t resource_transaction_by_month -u 9153 -g science -r "Vivarium" -d 093206
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $FY_DATE -e $END_DATE -t resource_transaction_by_month -u 0 -g computing -r "Scientific Computing" -d 093206
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $FY_DATE -e $END_DATE -t resource_transaction_by_month -u 0 -g computing -r "Computing Services" -d 093206

sleep 95

# Egnor
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $FY_DATE -e $END_DATE -t resource_transaction_by_month -u 0 -d 093308
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $FY_DATE -e $END_DATE -t resource_transaction_by_month -u 0 -g science -r "Cell Culture Facility" -d 093308
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $FY_DATE -e $END_DATE -t resource_transaction_by_month -u 0 -g science -r "Electron Microscopy" -d 093308
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $FY_DATE -e $END_DATE -t resource_transaction_by_month -u 0 -g science -r "Fly Lab" -d 093308
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $FY_DATE -e $END_DATE -t resource_transaction_by_month -u 0 -g science -r "Histology/anatomy Facility" -d 093308
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $FY_DATE -e $END_DATE -t resource_transaction_by_month -u 0 -g science -r "Instrument Development" -d 093308
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $FY_DATE -e $END_DATE -t resource_transaction_by_month -u 0 -g science -r "Light Microscopy" -d 093308
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $FY_DATE -e $END_DATE -t resource_transaction_by_month -u 0 -g science -r "Media Facility" -d 093308
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $FY_DATE -e $END_DATE -t resource_transaction_by_month -u 0 -g science -r "Molecular Biology" -d 093308
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $FY_DATE -e $END_DATE -t resource_transaction_by_month -u 0 -g science -r "Transgenics" -d 093308
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $FY_DATE -e $END_DATE -t resource_transaction_by_month -u 0 -g science -r "Vivarium" -d 093308
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $FY_DATE -e $END_DATE -t resource_transaction_by_month -u 0 -g computing -r "Scientific Computing" -d 093308
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $FY_DATE -e $END_DATE -t resource_transaction_by_month -u 0 -g computing -r "Computing Services" -d 093308


sleep 95

# Shared Resource purchases
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction -d 093090
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction -d 093091
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction -d 093092
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction -d 093093
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction -d 093094
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction -d 093095
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction -d 093096
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction -d 093097
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction -d 093098
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction -d 093100
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction -d 093101
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction -d 093102

sleep 95

# Operation purchases
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction -d 093036
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction -d 093035
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction -d 093026
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction -d 093055
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction -d 093056
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction -d 093057
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction -d 093058
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction -d 093059
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction -d 093060
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction -d 093010
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction -d 093011
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction -d 093022
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction -d 093023
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction -d 093024
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction -d 093045
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction -d 093046
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction -d 093047
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction -d 093098
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction -d 093102
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction -d 093025
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction -d 093030
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction -d 093070
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction -d 093071
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction -d 093072
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction -d 093073
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction -d 093074
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction -d 093077
$JAVA_HOME/java -Xms256m -Xmx256m -Dfile.encoding=MacRoman -classpath $CLASSPATH  org.janelia.it.crs.ConsolidatedReportingTool -b $BEGIN_DATE -e $END_DATE -t department_transaction -d 093061
