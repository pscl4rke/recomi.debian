
version := $(shell head -1 changelog  | sed 's|.*(\(.*\)).*|\1|')

build: recomi_$(version)_all.deb

# Find at https://pypi.org/project/recomi/#files
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
