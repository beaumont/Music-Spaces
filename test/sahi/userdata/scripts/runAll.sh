java -cp ../../lib/ant-sahi.jar net.sf.sahi.test.TestRunner "scripts/contentSuite/content.suite" "open -a Firefox" "http://kroogi.al/" default localhost 9999 1 "Firefox" ""
java -cp ../../lib/ant-sahi.jar net.sf.sahi.test.TestRunner "scripts/generalUiSuite/generalUi.suite" "open -a Firefox" "http://kroogi.al/" default localhost 9999 1 "Firefox" ""
time mysql -uroot -ppassw0rd krugi_test < ../../fixtures.sql
java -cp ../../lib/ant-sahi.jar net.sf.sahi.test.TestRunner "scripts/settingsSuite/settings.suite" "open -a Firefox" "http://kroogi.al/" default localhost 9999 1 "Firefox" ""
time mysql -uroot -ppassw0rd krugi_test < ../../fixtures.sql