from os import path
import argparse
import os
import sys
import time
import logging
from datetime import datetime
from contextlib import contextmanager
import zmq

log = logging.getLogger(__name__)

UMASK = 0
WORKDIR = "/"
MAXFD = 1024


if (hasattr(os, "devnull")):
    REDIRECT_TO = os.devnull
else:
    REDIRECT_TO = "/dev/null"


@contextmanager
def create_daemon(pidfile):
    """Detach a process from the controlling terminal and run it in the
    background as a daemon.
    """

    try:
        pid = os.fork()
    except OSError, e:
        raise Exception("%s [%d]" % (e.strerror, e.errno))

    if (pid == 0):
        os.setsid()

        try:
            pid = os.fork()
        except OSError, e:
            raise Exception("%s [%d]" % (e.strerror, e.errno))

        if (pid == 0):
            os.chdir(WORKDIR)
            os.umask(UMASK)
        else:
            os._exit(0)
    else:
        os._exit(0)

    import resource
    maxfd = resource.getrlimit(resource.RLIMIT_NOFILE)[1]
    if (maxfd == resource.RLIM_INFINITY):
        maxfd = MAXFD

    for fd in range(0, maxfd):
        try:
            os.close(fd)
        except OSError:
            pass

    os.open(REDIRECT_TO, os.O_RDWR)

    os.dup2(0, 1)
    os.dup2(0, 2)

    with open(pidfile, 'w') as f:
        f.write("{0}\n".format(os.getpid()))

    yield

    os.unlink(pidfile)
    os._exit(0)


def init_logging(logfile):
    handler = logging.FileHandler(logfile)
    handler.setFormatter(logging.Formatter(fmt='%(asctime)s - %(levelname)s - %(message)s'))
    root_logger = logging.getLogger()
    root_logger.addHandler(handler)
    root_logger.setLevel(logging.INFO)


class Daemon(object):
    """Daemonizing application that accepts `ArgumentParser` arguments over a ZMQ channel"""

    def __init__(self, pid_file=None, log_file=None):
        self.pid_file = pid_file
        self.log_file = log_file

    def process_args(self, args):
        app_running = False

        if path.exists(self.pid_file):
            with open(self.pid_file, 'r') as f:
                pid = int(f.read())

            try:
                os.kill(pid, 0)
                app_running = True
            except OSError:
                pass

        if not app_running:
            with create_daemon(self.pid_file):
                self._server(args)
        else:
            self._client(args)

    def _client(self, args):
        context = zmq.Context()
        client = context.socket(zmq.PUSH)
        client.connect('tcp://127.0.0.1:9867')
        client.send_pyobj(args)

    def _server(self, initial_args=None):
        if self.log_file:
            init_logging(self.log_file)

        log.info("Starting new daemon...")

        context = zmq.Context()
        server = context.socket(zmq.PULL)
        server.bind('tcp://127.0.0.1:9867')

        if initial_args:
            self._process_command(initial_args)

        while True:
            args = server.recv_pyobj()
            self._process_command(args)

    def _process_command(self, args):
        cmd = args.cmd

        log.info("Processing command `%s` (args: %s)" % (cmd, args))

        try:
            # expand cli arguments to handler methods
            arguments = vars(args)
            del arguments['cmd']
            getattr(self, 'do_%s' % cmd)(**arguments)
        except Exception, e:
            log.exception(e)
            raise

    def _quit(self):
        log.info("Stopping daemon...")
        sys.exit(0)

    def do_quit(self):
        self._quit()

