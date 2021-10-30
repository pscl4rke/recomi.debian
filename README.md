

This codebase builds `.deb` files for the
[Recomi](https://github.com/pscl4rke/recomi/)
Python program.

It automates the process of downloading a version from PyPI,
unpacking it, and then building it into a format that can
be installed on Debian/Ubuntu/etc machines.

It is driven by the `changelog` file.
When a new version is release add a new section to the top of this file.
Then run `make`.
Bob's your uncle.
Mostly. :)
