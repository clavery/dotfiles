#!/usr/bin/env python

import fileinput
import re
import sys

GROUPS_RE = re.compile(r'''^\n''', re.MULTILINE|re.VERBOSE )

ACCT_RE = re.compile(r'''A:\s*(?P<account_name>.+)$
                     (?:[^.$]*?U:\s*(?P<username>.+))?$
                     (?:[^.$]*?P:\s*(?P<password>.+))?''',
                     re.MULTILINE|re.VERBOSE)

def print_accounts():
    f = ''.join(fileinput.input())
    accounts = [ACCT_RE.search(g).group('account_name') for g in GROUPS_RE.split(f) if ACCT_RE.search(g)]
    print '\n'.join(accounts)

def print_account_info(account_name):
    f = ''.join(fileinput.input())
    groups = [ACCT_RE.search(g) for g in GROUPS_RE.split(f) if ACCT_RE.search(g)]
    passwords = [m.group('password') for m in groups if account_name in m.group('account_name')]
    if passwords:
        sys.stdout.write( passwords[0].rstrip())
    else:
        sys.stderr.write( "%s Not Found" % account_name)

def main():
    if '-a' in sys.argv:
        sys.argv.remove('-a')
        print_accounts()
    elif '-p' in sys.argv:
        idx = sys.argv.index('-p')
        del sys.argv[idx]
        account_name = ' '.join(sys.argv[idx:])
        del sys.argv[idx:]
        print_account_info(account_name)

if __name__ == '__main__':
    main()
