# Copyright 2012, Google Inc. All rights reserved.
# Use of this source code is governed by a BSD-style license that can
# be found in the LICENSE file.

MAKEFLAGS = -s

all: build unit_test occ_test integration_test

build:
	cd go/cmd/mysqlctl; go build
	cd go/cmd/normalizer; go build
	cd go/cmd/vtaction; go build
	cd go/cmd/vtclient2; go build
	cd go/cmd/vtctl; go build
	cd go/cmd/vtocc; go build
	cd go/cmd/vttablet; go build
	cd go/cmd/zk; go build
	cd go/cmd/zkctl; go build

# alphabetically ordered unit tests
# the ones that are commented out don't pass
unit_test:
	cd go/bson; go test
	cd go/bytes2; go test
	cd go/cache; go test
	cd go/hack; go test
#	cd go/logfile; go test
	if [ -e "/usr/bin/memcached" ]; then \
		cd go/memcache; exec go test ; \
	fi
	cd go/pools; go test
	cd go/rpcplus; go test
	cd go/rpcplus/jsonrpc; go test
	cd go/rpcwrap/auth; go test
	cd go/timer; go test
	cd go/umgmt; go test
	cd go/vt/client2; go test
	cd go/vt/mysqlctl; go test
#	cd go/vt/sqlparser; go test
	cd go/vt/tabletmanager; go test
#	cd go/vt/tabletserver; go test
#	cd go/vt/wrangler; go test
#	cd go/zk; go test
#	cd go/zk/zkctl; go test

# put a custom dbtest.json in your HOME directory if required
occ_test:
	if [ -e $$HOME/dbtest.json ]; then \
		cd py/vttest ; ./occ_test.py -c $$HOME/dbtest.json ; \
	else \
		cd py/vttest ; ./occ_test.py ; \
	fi

# export VT_TEST_FLAGS=-v for instance
integration_test:
	cd test ; ./sharded.py $$VT_TEST_FLAGS
	cd test ; ./tabletmanager.py $$VT_TEST_FLAGS
	cd test ; ./zkocc.py $$VT_TEST_FLAGS

clean:
	cd go/cmd/mysqlctl; go clean
	cd go/cmd/normalizer; go clean
	cd go/cmd/vtaction; go clean
	cd go/cmd/vtclient2; go clean
	cd go/cmd/vtctl; go clean
	cd go/cmd/vtocc; go clean
	cd go/cmd/vttablet; go clean
	cd go/cmd/zk; go clean
	cd go/cmd/zkctl; go clean