#!/bin/bash

/usr/bin/clamdscan --no-summary --stdout - < "$EMAIL"

VSTATUS=$?
[ -z "$VSTATUS" ] && VSTATUS=9999

if [ $VSTATUS -eq 1 ]; then
        echo 550 Message contains a virus 1>&2
        exit 1
elif [ $VSTATUS -ne 0 ]; then
        echo 450 Unexpected virus scanning error, please retry later 1>&2
        echo CLAMDSCAN_ERROR - clamdscan returned unexpected exit code $VSTATUS | /usr/bin/logger -p mail.notice
        exit 1
fi

echo "X-Antivirus-Scanner: ClamAV (PASSED)" > "$OUTFILE"

cat "$EMAIL" | /usr/bin/spamc -E -x --headers -t 30 >> "$OUTFILE"
SSTATUS=$?
[ -z "$SSTATUS" ] && SSTATUS=9999

[ $SSTATUS -eq 0 ] && [ $VSTATUS -eq 0 ] && exit 0

if [ $SSTATUS -eq 1 ]; then
        echo 550 This message appears to be spam, sorry 1>&2
        exit 1
elif [ $SSTATUS -eq 74 ]; then
        echo 451 Spam filtering timeout, please retry later 1>&2
        echo SPAMC_TIMEOUT - spamc returned exit code $SSTATUS | /usr/bin/logger -p mail.notice
        exit 1
elif [ $SSTATUS -ne 0 ]; then
        echo 452 Unexpected spam filtering error, please retry later 1>&2
        echo SPAMC_ERROR - spamc returned unexpected exit code $SSTATUS | /usr/bin/logger -p mail.notice
        exit 1
fi

echo UNEXPECTED ERROR clamdscan exit code $VSTATUS spamd exit code $SSTATUS | /usr/bin/logger -p mail.notice
exit 2
