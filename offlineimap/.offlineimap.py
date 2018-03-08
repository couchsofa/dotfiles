#! /usr/bin/env python2
import os, getpass
from keepass import kpdb

def get_keepass_pw(dbpath, title="", username=""):
    if os.path.isfile(dbpath):
        db = kpdb.Database(dbpath, getpass.getpass("Master password for '" + dbpath +    "': "))
        for entry in db.entries:
            if (entry.title == title) and (entry.username == username):
                return entry.password
    else:
        print "Error: '" + dbpath + "' does not exist."
        return
