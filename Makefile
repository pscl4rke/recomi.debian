
version := $(shell head -1 changelog  | sed 's|.*(\(.*\)).*|\1|')

build: recomi_$(version)_all.deb

newer: export DEBFULLNAME := P. S. Clarke
newer: export DEBEMAIL := debs@pscl4rke.net
newer:
	sensible-browser "https://pypi.org/project/recomi/#files"
	read -p "What is the new X.Y.Z version: " newversion \
	 && dch --changelog changelog --newversion $$newversion New upstream release.
	dch --changelog changelog --release --no-force-save-on-release
	@echo
	@echo REMEMBER TO UPDATE Makefile WITH THE DOWNLOAD URL
	@echo REMEMBER TO UPDATE verify.sha256 WITH THE FILE HASH

# Find at https://pypi.org/project/recomi/#files
#recomi-%.tar.gz:
#	pip download recomi==$(version)
recomi-1.2.0.tar.gz:
	wget https://files.pythonhosted.org/packages/19/c0/e9d033ccb1a1b42998e371b033bcfcc16d9b85c1a108a3afb58c205c660b/recomi-1.2.0.tar.gz
recomi-1.1.0.tar.gz:
	wget https://files.pythonhosted.org/packages/b1/e8/528447f484ca1de37f140fc21f7b7558d7fdb665a44b08588c958bde2301/recomi-1.1.0.tar.gz
recomi-1.0.5.tar.gz:
	wget https://files.pythonhosted.org/packages/9c/35/fabb8b5e0f5870d25e4cb1b21429995560864e570e389c15c57dc6dd68a3/recomi-1.0.5.tar.gz
recomi-1.0.4.tar.gz:
	wget https://files.pythonhosted.org/packages/4d/09/302ebed4a762914272ec3f30933e09b6b6bf90184a7c851c1deb7e3e719b/recomi-1.0.4.tar.gz

recomi-$(version): recomi-$(version).tar.gz
	grep -q $< verify.sha256
	sha256sum --check --quiet --ignore-missing verify.sha256
	tar xzf $<

recomi-$(version)/debian: recomi-$(version) Makefile changelog control rules
	rm -rf $@.tmp $@
	mkdir $@.tmp
	cp changelog $@.tmp/changelog
	cp control $@.tmp/control
	cp rules $@.tmp/rules
	echo 10 > $@.tmp/compat
	mv $@.tmp $@

recomi_$(version)_all.deb: recomi-$(version)/debian
	cd recomi-$(version) && debuild -us -uc
	ls -lh $@

clean:
	rm *.deb
