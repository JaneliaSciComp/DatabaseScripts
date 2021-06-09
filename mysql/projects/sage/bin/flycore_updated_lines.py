#!/opt/python/bin/python2.7

import argparse
import json
import sys
import colorlog
import requests


# Configuration
CONFIG_FILE = '/groups/scicomp/informatics/data/rest_services.json'
CONFIG = {}


def call_flycore_responder(endpoint):
    """ Call the SAGE responder
        Keyword arguments:
        endpoint: REST endpoint
    """
    url = CONFIG['flycore']['url'] + endpoint
    try:
        req = requests.get(url)
    except requests.exceptions.RequestException as err:
        logger.critical(err)
        sys.exit(-1)
    if req.status_code == 200:
        return req.json()
    else:
        logger.error('Status: %s', str(req.status_code))
        sys.exit(-1)


def initialize_program():
    """ Initialize databases """
    global CONFIG
    try:
        json_data = open(CONFIG_FILE).read()
        CONFIG = json.loads(json_data)
    except Exception, err:
        logger.critical(err)
        sys.exit(-1)


if __name__ == '__main__':
    PARSER = argparse.ArgumentParser(description="Find lines updated in FLYF2 for a specified window")
    PARSER.add_argument('--hours', dest='HOURS', action='store',
                        default='1', help='Delta hours for changed lines')
    PARSER.add_argument('--delay', dest='DELAY', action='store',
                        default='0', help='Hours for delay')
    PARSER.add_argument('--verbose', dest='VERBOSE', action='store_true',
                        default=False, help='Flag, Chatty')
    PARSER.add_argument('--debug', dest='DEBUG', action='store_true',
                        default=False, help='Flag, Very chatty')
    ARG = PARSER.parse_args()

    logger = colorlog.getLogger()
    if ARG.DEBUG:
        logger.setLevel(colorlog.colorlog.logging.DEBUG)
    elif ARG.VERBOSE:
        logger.setLevel(colorlog.colorlog.logging.INFO)
    else:
        logger.setLevel(colorlog.colorlog.logging.WARNING)
    HANDLER = colorlog.StreamHandler()
    HANDLER.setFormatter(colorlog.ColoredFormatter())
    logger.addHandler(HANDLER)

    initialize_program()
    response = call_flycore_responder("?request=aging&hours=" + ARG.HOURS + "&delay=" + ARG.DELAY)
    if 'lines' in response:
        for line in response['lines']:
            print line['line']
