.phony: build
build:
	./build.bash
	./Documentation/MANPAGE-render.bash

.phony: test
test:
	./test.bash

.phony: root_test
root_test:
	./build.bash
	cd tests/root_test && go test -c && sudo ./root_test.test -test.v

.phony: format
format:
	go fmt ./...

.phony: install
install:
	install -Dm755 -t "$(DESTDIR)/usr/bin/" gocryptfs
	install -Dm755 -t "$(DESTDIR)/usr/bin/" gocryptfs-xray/gocryptfs-xray
	install -Dm644 -t "$(DESTDIR)/usr/share/man/man1/" Documentation/gocryptfs.1
	install -Dm644 -t "$(DESTDIR)/usr/share/man/man1/" Documentation/gocryptfs-xray.1
	install -Dm644 -t "$(DESTDIR)/usr/share/licenses/gocryptfs" LICENSE

.phony: ci
ci:
	uname -a ; go version ; openssl version
	df -Th / /tmp /var/tmp

	./build-without-openssl.bash
	./build.bash
	./test.bash
	make root_test
	./crossbuild.bash

	echo "Rebuild with locked dependencies"
	# Download dependencies to "vendor" directory
	go mod vendor
	# Delete global cache
	go clean -modcache
	# GOPROXY=off makes sure we fail instead of making network requests
	# (we should not need any!)
	GOPROXY=off ./build.bash
	# Delete "vendor" dir
	rm -R vendor
