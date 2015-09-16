import argparse
import requests
import time
import sys
import random
import trollius
from trollius import From

@trollius.coroutine
def request_every(url, delay):
    print "Querying {0} every {1}s".format(url, delay)
    while True:
        sys.stdout.flush()
        try:
            r = requests.get(url)
        except requests.exceptions.ConnectionError as e:
            print "{0} {1}: Error connecting {2}".format(time.strftime('%X %x %Z'), url, e)
            continue

        if r.status_code != 200:
            print "{0} {1}: {2} {3} {4}".format(url, time.strftime('%X %x %Z'), r.status_code, r.elapsed, r.text)
        else:
            if r.elapsed.total_seconds() > 1.0 or random.randint(0, 100) < 10:
                print "{0} {1}: {2} {3}".format(url, time.strftime('%X %x %Z'), r.status_code, r.elapsed.total_seconds())
        yield From(trollius.sleep(int(delay)))



if __name__ == '__main__':
    usage = """usage: %prog [options]
        """
    parser = argparse.ArgumentParser()
    parser.add_argument("-u", "--url", dest="url", action='append', \
            default=[], help="the url to request")
    parser.add_argument("-d", "--delay", dest="delay", \
            default=2, help="the delay between requests")

    options = parser.parse_args()

    if not options.url or len(options.url) == 0:
        parser.error("-u is required")

    loop = trollius.get_event_loop()
    tasks = []
    for url in options.url:
        tasks.append(trollius.ensure_future(request_every(url, options.delay)))

    loop.run_until_complete(trollius.wait(tasks))
    loop.close()

