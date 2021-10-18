#!@python@/bin/python
import os
import sys
import subprocess

nix = "@nix@/bin/nix-env"
profiles = "/nix/var/nix/profiles" 
system = sys.argv[1]

found = None
for each in os.listdir(profiles):
    symlink = os.path.join(profiles, each)
    if not os.path.islink(symlink):
        continue
    if os.readlink(symlink) == system:
        found = symlink

if not found:
    print(f"Registering profile for {system}")
    subprocess.check_call(f"{nix} -p {profiles}/system --set {system}", shell=True)
else:
    print(f"{system} already registered as {found}")
