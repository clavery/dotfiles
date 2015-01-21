#!/usr/bin/env python

from os import path
import argparse
import os
import sys
import time
import logging
from datetime import datetime
from threading import Timer

from daemonargs import Daemon


log = logging.getLogger(__name__)
parser = argparse.ArgumentParser(description='Pomodoro.')
subparsers = parser.add_subparsers(dest='cmd')

start_parser = subparsers.add_parser('start', help='Start a pomodoro')
start_parser.add_argument('desc', help='description', nargs='?', default=None)

quit_parser = subparsers.add_parser('quit', help='Quit background process')


def say(message):
    os.system('osascript -e \'say "%s" using "Vicki"\'' % message)

def notify(title, message):
    os.system('osascript -e \'display notification "{0}" with title "{1}"\''.format(message, title))


DEFAULT = "#[default]"
GREEN = "#[default]#[fg=green]"
YELLOW = "#[default]#[fg=yellow]"
RED = "#[default]#[fg=red]"


class Pomo(object):
    def __init__(self, desc, tmuxfile, length=25):
        self.desc = desc
        self.length = length
        self.timer = None
        self.tmuxfile = tmuxfile

    def report_remaining(self, remaining):
        say("{0} minutes".format(remaining))

    def report_done(self):
        say("{0} -- is finished".format(self.desc))
        notify("Pomo", "{0} -- FINISHED".format(self.desc))

    def write_tmux(self, remaining):
        if remaining > 10:
            val = "{0}{1}:00{2}".format(GREEN, remaining, DEFAULT)
        elif remaining > 5:
            val = "{0}{1}:00{2}".format(YELLOW, remaining, DEFAULT)
        else:
            val = "{0}{1}:00{2}".format(RED, remaining, DEFAULT)
        with open(self.tmuxfile, 'w') as f:
            f.write(val)

    def do_interval(self, interval):
        minute = self.length - interval

        if minute in [24, 10, 5, 1]:
            self.report_remaining(minute)

        self.write_tmux(minute)

        if minute > 0:
            self.timer = Timer(60, self.do_interval, args=[interval + 1])
            self.timer.start()
        else:
            self.report_done()

    def start(self):
        timer = Timer(60, self.do_interval, args=[1])
        timer.start()
        self.timer = timer
        self.write_tmux(self.length)

    def cancel(self):
        with open(self.tmuxfile, 'w') as f:
            f.write("N/A")

        if self.timer:
            self.timer.cancel()


class PomoCli(Daemon):
    def __init__(self, pomofile, tmuxfile, *args, **kwargs):
        self.pomofile = pomofile
        self.tmuxfile = tmuxfile
        self.pomo = None
        super(PomoCli, self).__init__(*args, **kwargs)

    def do_start(self, desc, *args, **kwargs):
        if desc is None:
            desc = "N/A"

        pomo = Pomo(desc, self.tmuxfile, 25)
        pomo.start()
        self.pomo = pomo

    def do_quit(self):
        if self.pomo:
            self.pomo.cancel()
        self._quit()


def main():
    home = path.expanduser("~")
    pomodir = path.join(home, '.pomo')
    pid_file = path.join(pomodir, 'pid')
    log_file = path.join(pomodir, 'log')

    pomo_file = path.join(pomodir, 'pomos')
    tmux_file = path.join(pomodir, 'tmux')

    if not path.exists(pomodir):
        os.mkdir(pomodir)

    args = parser.parse_args()

    pomo_cli = PomoCli(pomo_file, tmux_file, pid_file=pid_file, log_file=log_file)
    pomo_cli.process_args(args)


if __name__ == "__main__":
    main()
