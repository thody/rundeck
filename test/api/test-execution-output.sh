#!/bin/bash

#test output from /api/execution/{id}/output

DIR=$(cd `dirname $0` && pwd)
source $DIR/include.sh

####
# Setup: create simple adhoc command execution to provide execution ID.
####

runurl="${APIURL}/run/command"
proj="test"
params="project=${proj}&exec=echo+testing+execution+output+api+line+1;sleep+2;echo+line+2;sleep+2;echo+line+3;sleep+2;echo+line+4+final"

# get listing
docurl ${runurl}?${params} > $DIR/curl.out
if [ 0 != $? ] ; then
    errorMsg "ERROR: failed query request"
    exit 2
fi

sh $DIR/api-test-success.sh $DIR/curl.out || exit 2

#select id

execid=$($XMLSTARLET sel -T -t -v "/result/execution/@id" $DIR/curl.out)

if [ -z "$execid" ] ; then
    errorMsg "FAIL: expected execution id"
    exit 2
fi


####
# Test: receive output using lastmod param
####

# now submit req
runurl="${APIURL}/execution/${execid}/output.xml"

echo "TEST: /api/execution/${execid}/output.xml using lastmod ..."

doff=0
ddone="false"
dlast=0
dmax=20
dc=0
while [[ $ddone == "false" && $dc -lt $dmax ]]; do
    #statements
    params="offset=$doff&lastmod=$dlast"

    # get listing
    docurl ${runurl}?${params} > $DIR/curl.out
    if [ 0 != $? ] ; then
        errorMsg "ERROR: failed query request"
        exit 2
    fi

    sh $DIR/api-test-success.sh $DIR/curl.out || exit 2

    ocount=$($XMLSTARLET sel -T -t -v "count(/result/output/entries/entry)" $DIR/curl.out)
    
    #output text
    $XMLSTARLET sel -T -t -m "/result/output/entries/entry" -o "OUT: " -v "." -n $DIR/curl.out

    unmod=$($XMLSTARLET sel -T -t -v "/result/output/unmodified" $DIR/curl.out)
    doff=$($XMLSTARLET sel -T -t -v "/result/output/offset" $DIR/curl.out)
    dlast=$($XMLSTARLET sel -T -t -v "/result/output/lastModified" $DIR/curl.out)
    ddone=$($XMLSTARLET sel -T -t -v "/result/output/completed" $DIR/curl.out)
    #echo "unmod $unmod, doff $doff, dlast $dlast, ddone $ddone"
    if [[ $unmod == "true" ]]; then
        #echo "unmodifed, sleep 3..."
        sleep 2
    else
        #echo "$ocount lines, sleep 1"
        if [[ $ddone != "true" ]]; then
            sleep 1
        fi
    fi
    dc=$(( $dc + 1 ))

done

if [[ $ddone != "true" ]]; then
    errorMsg "ERROR: not all output was received in $dc requests"
    exit 2
fi

echo "OK"


####
# Setup: run adhoc command to output lines
####

runurl="${APIURL}/run/command"
proj="test"
params="project=${proj}&exec=echo+testing+execution+output+api+line+1;sleep+2;echo+line+2;sleep+2;echo+line+3;sleep+2;echo+line+4+final"

# get listing
docurl ${runurl}?${params} > $DIR/curl.out
if [ 0 != $? ] ; then
    errorMsg "ERROR: failed query request"
    exit 2
fi

sh $DIR/api-test-success.sh $DIR/curl.out || exit 2

#select id

execid=$($XMLSTARLET sel -T -t -v "/result/execution/@id" $DIR/curl.out)

if [ -z "$execid" ] ; then
    errorMsg "FAIL: expected execution id"
    exit 2
fi


####
# Test: receive output with maxlines param
####

# now submit req
runurl="${APIURL}/execution/${execid}/output.xml"

echo "TEST: /api/execution/${execid}/output.xml using maxlines..."

doff=0
ddone="false"
dlast=0
dmax=20
dc=0
while [[ $ddone == "false" && $dc -lt $dmax ]]; do
    #statements
    params="offset=$doff&maxlines=1"

    # get listing
    docurl ${runurl}?${params} > $DIR/curl.out
    if [ 0 != $? ] ; then
        errorMsg "ERROR: failed query request"
        exit 2
    fi

    sh $DIR/api-test-success.sh $DIR/curl.out || exit 2

    ocount=$($XMLSTARLET sel -T -t -v "count(/result/output/entries/entry)" $DIR/curl.out)
    
    #output text
    $XMLSTARLET sel -T -t -m "/result/output/entries/entry" -o "OUT: " -v "." -n $DIR/curl.out

    unmod=$($XMLSTARLET sel -T -t -v "/result/output/unmodified" $DIR/curl.out)
    doff=$($XMLSTARLET sel -T -t -v "/result/output/offset" $DIR/curl.out)
    dlast=$($XMLSTARLET sel -T -t -v "/result/output/lastModified" $DIR/curl.out)
    ddone=$($XMLSTARLET sel -T -t -v "/result/output/completed" $DIR/curl.out)
    #echo "unmod $unmod, doff $doff, dlast $dlast, ddone $ddone"
    if [[ $unmod == "true" ]]; then
        #echo "unmodifed, sleep 3..."
        sleep 2
    else
        #echo "$ocount lines, sleep 1"
        if [[ $ddone != "true" ]]; then
            sleep 1
        fi
    fi
    dc=$(( $dc + 1 ))

done

if [[ $ddone != "true" ]]; then
    errorMsg "ERROR: not all output was received in $dc requests"
    exit 2
fi

echo "OK"



####
# Setup: run adhoc command to output lines
####

runurl="${APIURL}/run/command"
proj="test"
params="project=${proj}&exec=echo+testing+execution+output+api+line+1;sleep+2;echo+line+2;sleep+2;echo+line+3;sleep+2;echo+line+4+final"

# get listing
docurl ${runurl}?${params} > $DIR/curl.out
if [ 0 != $? ] ; then
    errorMsg "ERROR: failed query request"
    exit 2
fi

sh $DIR/api-test-success.sh $DIR/curl.out || exit 2

#select id

execid=$($XMLSTARLET sel -T -t -v "/result/execution/@id" $DIR/curl.out)

if [ -z "$execid" ] ; then
    errorMsg "FAIL: expected execution id"
    exit 2
fi


####
# Test: receive output greedily
####

# now submit req
runurl="${APIURL}/execution/${execid}/output.xml"

echo "TEST: /api/execution/${execid}/output.xml ..."

doff=0
ddone="false"
dlast=0
dmax=20
dc=0
while [[ $ddone == "false" && $dc -lt $dmax ]]; do
    #statements
    params="offset=$doff"

    # get listing
    docurl ${runurl}?${params} > $DIR/curl.out
    if [ 0 != $? ] ; then
        errorMsg "ERROR: failed query request"
        exit 2
    fi

    sh $DIR/api-test-success.sh $DIR/curl.out || exit 2

    ocount=$($XMLSTARLET sel -T -t -v "count(/result/output/entries/entry)" $DIR/curl.out)
    
    #output text
    $XMLSTARLET sel -T -t -m "/result/output/entries/entry" -o "OUT: " -v "." -n $DIR/curl.out

    unmod=$($XMLSTARLET sel -T -t -v "/result/output/unmodified" $DIR/curl.out)
    doff=$($XMLSTARLET sel -T -t -v "/result/output/offset" $DIR/curl.out)
    dlast=$($XMLSTARLET sel -T -t -v "/result/output/lastModified" $DIR/curl.out)
    ddone=$($XMLSTARLET sel -T -t -v "/result/output/completed" $DIR/curl.out)
    #echo "unmod $unmod, doff $doff, dlast $dlast, ddone $ddone"
    if [[ $unmod == "true" ]]; then
        #echo "unmodifed, sleep 3..."
        sleep 2
    else
        #echo "$ocount lines, sleep 1"
        if [[ $ddone != "true" ]]; then
            sleep 1
        fi
    fi
    dc=$(( $dc + 1 ))

done

if [[ $ddone != "true" ]]; then
    errorMsg "ERROR: not all output was received in $dc requests"
    exit 2
fi

echo "OK"